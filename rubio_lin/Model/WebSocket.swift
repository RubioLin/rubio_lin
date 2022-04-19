import Foundation

struct receiveInfo: Codable {
    let event: String
    let room_id: String
    let sender_role: Int
    let body: receive_body
    let time: String
}

struct receive_body: Codable {
    let nickname: String?
    let text: String?
    let type: String?
    let entry_notice: body_entry_notice?
    let content: body_content?
}

struct body_entry_notice: Codable {
    let username: String?
    let action: String?
}

struct body_content: Codable {
    let cn: String?
    let en: String?
    let tw: String?
}
