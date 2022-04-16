//
//  Network.swift
//  rubio_lin
//
//  Created by Class on 2022/4/2.
//

import Foundation
    
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

