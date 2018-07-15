import Vapor
import FluentSQLite

enum StreamingService: String, SQLiteEnumType {
    static func reflectDecoded() throws -> (StreamingService, StreamingService) {
        return (.spotify, .googlePlay)
    }
    
    case spotify = "spotify"
    case googlePlay = "googlePlay"
}

public struct User: SQLiteModel {
    public var id: Int?
    public let spotifyId: Int?
    public let name: String
}

/// Allows `Todo` to be used as a dynamic migration.
extension User: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }

struct Track: SQLiteModel {
    var id: Int?
    let name: String
    let artist: String
}

/// Allows `Todo` to be used as a dynamic migration.
extension Track: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Track: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Track: Parameter { }

struct PartyRoom: SQLiteModel {
    var id: Int?
    var ownerId: Int?
    var name: String
    /// session ids
    var members: [String]
//    let tracks: [Track]
    var streamingService: StreamingService
}

/// Allows `Todo` to be used as a dynamic migration.
extension PartyRoom: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension PartyRoom: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension PartyRoom: Parameter { }

//struct RoomUserPivot: SQLiteUUIDModel {
//    var id: UUID?
//
//    var memberId: User.ID
//    var roomId: PartyRoom.ID
//}
