import FluentSQLite
import Vapor

struct Track: Codable {
    var id: Int?
    let name: String
    let artist: String
}

extension Track: SQLiteModel { }
extension Track: Migration { }
extension Track: Content { }
extension Track: Parameter { }

extension Track {
    var rooms: Siblings<Track, PartyRoom, RoomTrackPivot> {
        return siblings()
    }
}
