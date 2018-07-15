import Vapor
import FluentSQLite

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req -> Future<Song> in
        let spotify = try req.make(SpotifyService.self)
        
        return try spotify.getSong(songId: "2TpxZ7JUBn3uw46aR7qd6V", on: req)
    }
    
    router.get("wordlist") { req -> Future<Response> in
        let encoder = JSONEncoder()
        var headers: HTTPHeaders = HTTPHeaders([])
        
        headers.add(name: HTTPHeaderName.contentType, value: "appliction/json")
        
        return try encoder
            .encode(
                [
                    "words": "to be or not to be that is the question whether tis nobler in the mind to suffer slings and arrows than outragous fortunes or to take arms against a sea of troubles and by opposing end them"
                        .split(separator: " ")
                        .map { String($0) }
                ]).toString().encode(status: .ok, headers: headers, for: req)
    }
    
    router.post(User.self, at: "user") { (req, user) -> Future<User> in
        print(user)
        return user.save(on: req)
    }
    
    router.post("partyRoom") { (req) -> Future<PartyRoom> in
        guard let userId: User.ID = try req.content.syncGet(at: "userId"),
            let roomName: String = try req.content.syncGet(at: "name")
            else { throw Abort(.notFound, reason: "user id not supplied") }
        
        return User
            .find(userId, on: req)
            .unwrap(or: Abort(.notFound))
            .flatMap { (user) -> Future<PartyRoom> in
                return try PartyRoomController().create(req, for: user, named: roomName)
            }
    }
    
    router.put("joinParty") { (req) -> Future<PartyRoom> in
        guard let partyId: PartyRoom.ID = try req.content.syncGet(at: "partyId") else { throw Abort(.notFound) }
        guard let sessionId = req.http.headers.firstValue(name: .authorization) else { throw Abort(.unauthorized) }
        
        return try req
            .keyedCache(for: .sqlite)
            .get(sessionId, as: Session.self)
            .unwrap(or: Abort(.unauthorized))
            .and(PartyRoom.find(partyId, on: req).unwrap(or: Abort(.notFound)))
            .flatMap { (session, partyRoom) -> Future<PartyRoom> in
                var updatedRoom = partyRoom
                updatedRoom.members.append(sessionId)
                return updatedRoom.update(on: req)
            }
    }
    
    // create a route at GET /sessions/get
    router.get("get") { req -> Future<String> in
        // access "name" from session or return n/a
        let name = try req.session()["name"] ?? "n/a"
        let id = try req.session().id ?? "no id"
        let encoder = JSONEncoder()
        
        let session = Session(dateIssued: Date(), userName: name)
        let sessionId = try req.session().id!
        return try req
            .keyedCache(for: .sqlite)
            .set(sessionId, to: session)
            .transform(to: sessionId)
       
//        return try encoder.encode([name, id]).toString().encode(for: req)
    }
    
    // create a route at GET /sessions/set/:name
    router.get("set", String.parameter) { req -> String in
        // get router param
        let name = try req.parameters.next(String.self)
        
        // set name to session at key "name"
        try req.session()["name"] = name
        
        return name
    }
    
    // create a route at GET /sessions/del
    router.get("del") { req -> String in
        // destroy the session
        try req.destroySession()
        
        // signal success
        return "done"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}

extension Data
{
    func toString() -> String
    {
        return String(data: self, encoding: .utf8)!
    }
}
