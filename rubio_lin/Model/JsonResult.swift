import Foundation

struct JsonResult: Codable {
    let lightyear_list: [LightyearList?]
    let stream_list: [StreamList?]
}

struct LightyearList: Codable {
    let stream_title: String?
    let head_photo: String?
    let nickname: String?
    let tags: String?
    let online_num: Int?
}

struct StreamList: Codable {
    let stream_title: String?
    let head_photo: String?
    let nickname: String?
    let tags: String?
    let online_num: Int?
}

class FetchJsonModal {
    
    static let shared = FetchJsonModal()
    
    func load<T>(_ filename: String) -> T where T : Decodable {
        let data: Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
}

