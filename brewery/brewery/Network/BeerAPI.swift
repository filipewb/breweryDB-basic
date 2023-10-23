//
//  BeerAPI.swift
//  brewery
//
//  Created by Filipe Boeck on 22/10/23.
//

import Foundation
import Networking

enum BeerAPI {
    case getBeer(Int)
}

extension BeerAPI: EndPointType {
    var baseURL: URL {
        URL(string: Environment.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getBeer(let page):
            return "beers?page=\(page)&per_page=20"
        }
    }
    
    var httpMethod: Networking.HTTPMethod {
        switch self {
        case .getBeer:
            return .get
        }
    }
    
    var task: Networking.HTTPTask {
        switch self {
        case .getBeer:
            return .request
        }
    }
    
    var headers: Networking.HTTPHeaders {
        switch self {
        case .getBeer:
            return [:]
        }
    }
}
