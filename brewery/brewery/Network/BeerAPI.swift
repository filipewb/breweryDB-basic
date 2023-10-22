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
        URL(string: "https://api.punkapi.com/v2/")!
    }
    
    var path: String {
        switch self {
        case .getBeer:
            return "beers/"
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
        case .getBeer(let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page": page])
        }
    }
    
    var headers: Networking.HTTPHeaders {
        switch self {
        case .getBeer:
            return [:]
        }
    }
}
