//
//  BeerResponse.swift
//  brewery
//
//  Created by Filipe Boeck on 22/10/23.
//

import Foundation

struct Response {
    var count: Int = 0
    var beers: [Beer] = []
    var next: String?
    var previous: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.count = try container.decode(Int.self, forKey: .count)
        self.beers = try container.decode([Beer].self, forKey: .beers)
        self.next = try container.decode(String?.self, forKey: .next)
        self.previous = try container.decode(String?.self, forKey: .previous)
    }
}

extension Response: Decodable {
    enum CodingKeys: String, CodingKey {
        case count
        case beers = "results"
        case next
        case previous
    }
}
