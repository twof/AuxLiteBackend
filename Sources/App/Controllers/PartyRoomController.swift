import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class PartyRoomController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[PartyRoom]> {
        return PartyRoom.query(on: req).all()
    }
    
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request, for user: User, named name: String) throws -> Future<PartyRoom> {
//        guard user.spotifyId != nil else { throw Abort(.badRequest, reason: "user needs to be logged into spotify") }
        let newRoom = PartyRoom(id: nil, ownerId: user.id, name: name, members: [], streamingService: .spotify)
        
        return newRoom.save(on: req)
    }
    
    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(PartyRoom.self).flatMap { todo in
            return todo.delete(on: req)
            }.transform(to: .ok)
    }
}
