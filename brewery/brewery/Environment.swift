//
//  Environment.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import Foundation

enum Environment {
    enum Keys {
        static let baseUrl = "BASE_URL"
    }
    
    private static let infoDisctionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let baseUrl: String = {
        guard let baseUrlString = Environment.infoDisctionary[Keys.baseUrl] as? String else {
            fatalError("API Key not set in plist")
        }
        return baseUrlString
    }()
}
