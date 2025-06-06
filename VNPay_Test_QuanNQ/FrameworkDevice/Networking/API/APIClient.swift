//
//  APIClient.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import Foundation

class APIClient: BaseAPI<APIRoute> {
    static let shared = APIClient()
    
    func fetchData(page:Int, limit: Int, completion: @escaping (Result<[PhotoModel], APIError>) -> Void) {
        self.requestAPI(target: .getData(page: page, limit: limit), responseClass: [PhotoModel].self) { result in
            completion(result)
        }
    }
    
    func loadImage(url: URL, completion: @escaping (Result<Data, APIError>) -> Void) {
        self.downloadImage(url: url) { result in
            completion(result)
        }
    }
}
