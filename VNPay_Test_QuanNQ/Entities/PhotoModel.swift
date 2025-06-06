//
//  PhotoModel.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import Foundation

class PhotoModel: Codable {
    var id: String?
    var author: String?
    var width: Int?
    var height: Int?
    var url: String?
    var downloadURL: String?

    init(id: String?, author: String?, width: Int?, height: Int?, url: String?, downloadURL: String?) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadURL = downloadURL
    }

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadURL = "download_url"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        downloadURL = try container.decodeIfPresent(String.self, forKey: .downloadURL)
    }
}
