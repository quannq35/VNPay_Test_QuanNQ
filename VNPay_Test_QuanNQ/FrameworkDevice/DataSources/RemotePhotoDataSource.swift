//
//  RemotePhotoDataSource.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 5/6/25.
//

import Foundation
class RemotePhotoDataSource: RemotePhotoDataSourceProtocol {
    
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoModel], APIError>) -> Void) {
        APIClient.shared.fetchData(page: page, limit: limit) { result in
            completion(result)
        }
    }
    
    func downloadPhoto(url: URL, completion: @escaping (Result<Data, APIError>) -> Void) {
        APIClient.shared.loadImage(url: url) { result in
            completion(result)
        }
    }
}
