import Vapor

public struct SessionAuthMiddleware: Middleware
//, ServiceType
{
//    public static func makeService(for worker: Container) throws -> SessionAuthMiddleware {
//        return .init()
//    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        guard let sessionId = request.http.headers.firstValue(name: .authorization) else { throw Abort(.unauthorized) }
        
        return try request
            .keyedCache(for: .sqlite)
            .get(sessionId, as: Session.self)
            .unwrap(or: Abort(.unauthorized))
            .flatMap { _ in
                return try next.respond(to: request)
            }
    }
}
