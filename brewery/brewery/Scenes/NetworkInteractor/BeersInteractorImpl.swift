//
//  BeersInteractorImpl.swift
//  brewery
//
//  Created by Filipe Boeck on 22/10/23.
//

import Foundation
import Networking

protocol BeerInteractor {
    typealias FetchCompletion = (Result<Response, Error>) -> Void
    
    func getBeers(page: Int, completion: @escaping FetchCompletion)
}

struct BeersInteractorImpl: BeerInteractor {
    let service = NetworkServiceImpl<BeerAPI>()
    
    func getBeers(page: Int, completion: @escaping FetchCompletion) {
        service.request(.getBeer(page)) { result in
            completion(result)
        }
    }
}
