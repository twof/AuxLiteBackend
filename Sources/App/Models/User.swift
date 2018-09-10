import Vapor
import FluentSQLite

public struct User: SQLiteModel {
    public var id: Int?
    public let spotifyId: Int?
    public let name: String
}

extension User: Migration { }
extension User: Content { }
extension User: Parameter { }
