import FluentSQLite
import Vapor

struct PartyRoom: Codable {
    var id: Int?
    var partyCode: Int16 // will max out at 4 digits
    var ownerId: Int?
    var name: String
    /// session ids
    var members: [String]
    var streamingService: StreamingService
    
    func partyRoomEntity(on conn: DatabaseConnectable) throws -> Future<PopulatedPartyRoom> {
        guard let ownerId = self.ownerId else { throw Abort(.notFound) }
        let userFuture = User
            .find(ownerId, on: conn)
            .unwrap(or: Abort(.notFound))
        let tracksFuture = try tracks.query(on: conn).all()
        
        return flatMap(userFuture, tracksFuture) { (user, tracks) in
            return conn.future(PopulatedPartyRoom(with: self, tracks: tracks, owner: user))
        }
    }
}

extension PartyRoom: SQLiteModel { }
extension PartyRoom: Migration { }
extension PartyRoom: Content { }
extension PartyRoom: Parameter { }

extension PartyRoom {
    var tracks: Siblings<PartyRoom, Track, RoomTrackPivot> {
        return siblings()
    }
}

struct PopulatedPartyRoom: Encodable {
    var id: Int
    var owner: User
    var name: String
    let tracks: [Track]
    var streamingService: StreamingService
    
    init(with room: PartyRoom, tracks: [Track], owner: User) {
        self.id = room.id ?? 0
        self.owner = owner
        self.name = room.name
        self.tracks = tracks
        self.streamingService = room.streamingService
    }
}
