import FluentSQLite

struct RoomTrackPivot: SQLitePivot {
    typealias Left = PartyRoom
    typealias Right = Track

    static var leftIDKey: LeftIDKey = \.roomId
    static var rightIDKey: RightIDKey = \.trackId
    
    var id: Int?

    var roomId: PartyRoom.ID
    var trackId: Track.ID
}

extension RoomTrackPivot: Migration {}
extension RoomTrackPivot: ModifiablePivot {
    init(_ room: PartyRoom, _ track: Track) throws {
        roomId = try room.requireID()
        trackId = try track.requireID()
    }
}
