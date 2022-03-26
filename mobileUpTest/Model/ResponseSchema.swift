//
//  ResponseSchema.swift
//  mobileUpTest
//
//  Created by Виталий on 25.03.2022.
//

import Foundation
// MARK: - PhotosResponse
struct PhotosResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let count: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id, albumID, ownerID, userID: Int
    let sizes: [Size]
    let text: String
    let date: Int

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case userID = "user_id"
        case sizes, text, date
    }
}

// MARK: - Size
struct Size: Codable {
    let type: String
    let url: String
    let width, height: Int
}
