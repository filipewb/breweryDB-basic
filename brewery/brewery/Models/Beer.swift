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
    let imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case id, name, tagline
        case description
        case imageURL = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        tagline = try container.decode(String.self, forKey: .tagline)
        description = try container.decode(String.self, forKey: .description)
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        print(imageURL?.absoluteString)
    }
}
