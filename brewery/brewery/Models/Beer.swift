//
//  Beer.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import Foundation

struct Beer: Codable, Identifiable, Hashable {
    let id: Int
    let name, tagline, description: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, tagline
        case description
        case imageURL = "image_url"
    }
}
