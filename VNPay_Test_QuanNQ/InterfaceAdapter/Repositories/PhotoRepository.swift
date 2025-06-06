//
//  PhotoRepository.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 5/6/25.
//

import Foundation

class PhotoRepository: PhotoRepositoryProtocol {
    
    
    private let remoteDataSource: RemotePhotoDataSourceProtocol
    
    init(remoteDataSource: RemotePhotoDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchPhotos( page: Int, limit: Int, completion: @escaping (Result<[PhotoModel], APIError>) -> Void) {
        remoteDataSource.fetchPhotos(page: page, limit: limit) { result in
            completion(result)
        }
    }
    
    func downloadPhoto(url: URL, completion: @escaping (Result<Data, APIError>) -> Void) {
        remoteDataSource.downloadPhoto(url: url) { result in
            completion(result)
        }
    }
}
