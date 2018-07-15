import Vapor
import FluentSQLite

struct Session: Codable {
    var dateIssued: Date
    var userName: String?
}

///// Allows `Todo` to be used as a dynamic migration.
//extension Session: Migration { }
//
///// Allows `Todo` to be encoded to and decoded from HTTP messages.
//extension Session: Content { }
//
///// Allows `Todo` to be used as a dynamic parameter in route definitions.
//extension Session: Parameter { }
