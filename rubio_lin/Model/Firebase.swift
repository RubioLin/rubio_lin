import Foundation

struct UserInfo: Codable {
    let nickname: String
    let email: String
    let password: String
    let userPhotoUrl: URL
}
