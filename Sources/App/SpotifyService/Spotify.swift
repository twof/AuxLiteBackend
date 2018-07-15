import Vapor
import Foundation


// MARK: - Service

public protocol SpotifyService: Service {
    var clientId: String { get }
    var clientSecret: String { get }
    func auth(on req: Request) throws -> Future<TokenRequestResult>
    func getSong(songId: String, on req: Request) throws -> Future<Song>
}

public enum SpotifyError: Error {    
    case encodingProblem
    case authenticationFailed
    case genericError
}

public struct Spotify: SpotifyService {
    public let clientId: String
    public let clientSecret: String
    
    public init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    public func auth(on req: Request) throws -> Future<TokenRequestResult> {
        let authKeyEncoded = "Basic \(try encode(apiKey: "\(self.clientId):\(self.clientSecret)"))"
        
        var headers = HTTPHeaders([])
        headers.add(name: .authorization, value: authKeyEncoded)
        
        let spotifyAuthUrl = "https://accounts.spotify.com/api/token"
        
        let client = try req.make(Client.self)
        
        struct AuthBody: Content {
            public static var defaultContentType: MediaType = MediaType.urlEncodedForm
            
            let grantType: String
            
            enum CodingKeys: String, CodingKey {
                case grantType = "grant_type"
            }
        }
        
        return client.post(spotifyAuthUrl, headers: headers) { req in
            try req.content.encode(AuthBody(grantType: "client_credentials"))
            print(req)
        }.map(to: Response.self) { response in
            switch response.http.status.code {
            case HTTPStatus.ok.code:
                return response
            case HTTPStatus.unauthorized.code:
                throw SpotifyError.authenticationFailed
            default:
                throw SpotifyError.genericError
            }
        }.flatMap(to: TokenRequestResult.self) { resp in
            return try TokenRequestResult.decode(from: resp, for: req)
        }
    }
    
    public func getSong(songId: String, on req: Request) throws -> Future<Song> {
        return try auth(on: req)
            .map{ tokenResponse in
                return tokenResponse.accessToken
            }.flatMap { accessToken in
                let getSongURL = "https://api.spotify.com/v1/tracks/\(songId)"
                let client = try req.make(Client.self)
                let authKey = "Bearer \(accessToken)"
                
                var headers = HTTPHeaders([])
                headers.add(name: .authorization, value: authKey)
                
                return client.get(getSongURL, headers: headers)
            }.flatMap { (response: Response) in
                return try Song.decode(from: response, for: req)
            }
    }
}

// MARK: Private

fileprivate extension SpotifyService {
    
    func encode(apiKey: String) throws -> String {
        guard let apiKeyData = apiKey.data(using: .utf8) else {
            throw SpotifyError.encodingProblem
        }
        let authKey = apiKeyData.base64EncodedData()
        guard let authKeyEncoded = String.init(data: authKey, encoding: .utf8) else {
            throw SpotifyError.encodingProblem
        }
        
        return authKeyEncoded
    }
}
