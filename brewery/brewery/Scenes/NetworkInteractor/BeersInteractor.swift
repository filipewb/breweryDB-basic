//
//  BeersInteractor.swift
//  brewery
//
//  Created by Filipe Boeck on 22/10/23.
//

import Foundation
import Networking

protocol BeersInteractor {
    typealias FetchCompletion = (Result<[Beer], Error>) -> Void
    
    func getBeers(page: Int, completion: @escaping FetchCompletion)
}

struct BeersInteractorImpl: BeersInteractor {
    let service = NetworkServiceImpl<BeerAPI>()
    
    func getBeers(page: Int, completion: @escaping FetchCompletion) {
        service.request(.getBeer(page)) { result in
            completion(result)
        }
    }
}
