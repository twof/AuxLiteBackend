import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    let cache = MemoryKeyedCache()
    services.register(cache, as: KeyedCache.self)
    
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
    
    let workingDirectory = DirectoryConfig.detect().workDir
    let sqliteFile = workingDirectory + "partybot.sqlite"

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .file(path: sqliteFile))

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .sqlite)
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: PartyRoom.self, database: .sqlite)
    migrations.add(model: Track.self, database: .sqlite)
    migrations.prepareCache(for: .sqlite)
    services.register(migrations)
}
