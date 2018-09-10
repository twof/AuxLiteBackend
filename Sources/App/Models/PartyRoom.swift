import FluentSQLite
import Vapor

struct PartyRoom: SQLiteModel {
    var id: Int?
    var ownerId: Int?
    var name: String
    /// session ids
    var members: [String]
    var streamingService: StreamingService
}

extension PartyRoom: Migration { }
extension PartyRoom: Content { }
extension PartyRoom: Parameter { }

extension PartyRoom {
    var tracks: Siblings<PartyRoom, Track, RoomTrackPivot> {
        return siblings()
    }
}

struct PopulatedPartyRoom: Encodable {
    var id: Int?
    var ownerId: Int?
    var name: String
    var members: [String]
    let tracks: [Track]
    var streamingService: StreamingService
    
    init(with room: PartyRoom, tracks: [Track]) {
        self.id = room.id
        self.ownerId = room.ownerId
        self.name = room.name
        self.members = room.members
        self.tracks = tracks
        self.streamingService = room.streamingService
    }
}
