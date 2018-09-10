import FluentSQLite

enum StreamingService: String, SQLiteEnumType {
    static func reflectDecoded() throws -> (StreamingService, StreamingService) {
        return (.spotify, .googlePlay)
    }
    
    case spotify = "spotify"
    case googlePlay = "googlePlay"
}
