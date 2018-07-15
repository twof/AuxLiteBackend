import Vapor

public struct Artist: Content {
    let externalUrls: [String: URL]
    let href: URL
    let id: String
    let name: String
    let type: String
    let uri: URL
    
    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href
        case id
        case name
        case type
        case uri
    }
}

public struct ImageEntity: Content {
    let height: UInt
    let url: URL
    let width: UInt
}
    
public struct Album: Content {
    let albumType: String
    let artists: [Artist]
    let availableMarkets: [String]
    let externalUrls: [String: URL]
    let href: URL
    let id: String
    let images: [ImageEntity]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let type: String
    let uri: URL
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href
        case id
        case images
        case name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case type
        case uri
    }
}

public struct Song: Content {
    let album: Album
    let artists: [Artist]
    let availableMarkets: [String]
    let discNumber: UInt
    let durationInMilliseconds: UInt
    let isExplicit: Bool
    let externalIds: [String: String]
    let externalUrls:  [String: URL]
    let href: URL
    let id: String
    let isLocal: Bool
    let name: String
    let popularity: UInt
    let previewUrl: URL
    let trackNumber: UInt
    let type: String
    let uri: URL
    
    enum CodingKeys: String, CodingKey {
        case album
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationInMilliseconds = "duration_ms"
        case isExplicit = "explicit"
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href
        case id
        case isLocal = "is_local"
        case name
        case popularity
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type
        case uri
    }
}
