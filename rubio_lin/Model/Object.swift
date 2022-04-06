//
//  stream_list.swift
//  rubio_lin
//
//  Created by Class on 2022/4/1.
//

import Foundation

struct Result: Codable {
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
