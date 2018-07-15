import Vapor


//{"access_token":"BQCRO0JV8YtEmfBZTKLclZ7j3NtvAl7Ag12Qy7tgVlZeZiFISg6nNUIXHVLx-1N6niIujkQWLcSbg0BETjE","token_type":"Bearer","expires_in":3600,"scope":""}
public struct TokenRequestResult: Content {
    public static var defaultContentType: MediaType = MediaType.urlEncodedForm
    
    let accessToken: String
    let tokenType: String
    let expiresIn: UInt
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope = "scope"
    }
}
