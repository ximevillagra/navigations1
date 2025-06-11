import Foundation

struct EntradaHistorial: Codable {
    let userId: String
    let gameId: Int
    let score: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case gameId = "game_id"
        case score
        case date
    }
}
