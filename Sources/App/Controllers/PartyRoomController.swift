import Vapor
import Fluent

/// Controls basic CRUD operations on `Todo`s.
final class PartyRoomController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[PartyRoom]> {
        return PartyRoom.query(on: req).all()
    }
    
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request, for user: User, named name: String) throws -> Future<PartyRoom> {
//        guard user.spotifyId != nil else { throw Abort(.badRequest, reason: "user needs to be logged into spotify") }
        let newRoom = PartyRoom.init(id: nil, partyCode: Int16.random(in: 1000...9999), ownerId: user.id, name: name, members: [], streamingService: .spotify)
        
        return newRoom.save(on: req)
    }
    
    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(PartyRoom.self).flatMap { todo in
            return todo.delete(on: req)
            }.transform(to: .ok)
    }
    
    func join(_ req: Request) throws -> Future<PartyRoom> {
        guard let sessionId = req.http.headers.firstValue(name: .authorization) else { fatalError() }
        guard let partyCode: Int16 = try req.content.syncGet(at: "partyCode") else { throw Abort(.notFound) }
        
        return PartyRoom
            .query(on: req)
            .filter(\PartyRoom.partyCode == partyCode)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { partyRoom -> PartyRoom in
                if partyRoom.members.contains(sessionId) {
                    throw Abort(.badRequest, reason: "you are already in this party!")
                } else {
                    return partyRoom
                }
            }.flatMap { partyRoom -> Future<PartyRoom> in
                var updatedRoom = partyRoom
                updatedRoom.members.append(sessionId)
                return updatedRoom.update(on: req)
            }
    }
}
