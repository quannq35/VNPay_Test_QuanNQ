//
//  FetchPhotoUseCase.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 5/6/25.
//

import Foundation

class PhotoUseCase: PhotoUseCaseProtocol {

    private let repository: PhotoRepositoryProtocol
    init(repository: PhotoRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchPhotos(page: Int, limit: Int, comletion: @escaping (Result<[PhotoModel], APIError>) -> Void) {
        repository.fetchPhotos(page: page, limit: limit) { result in
            comletion(result)
        }
    }
    
    func downloadPhoto(url: URL, completion: @escaping (Result<Data, APIError>) -> Void) {
        repository.downloadPhoto(url: url) { result in
            completion(result)
        }
    }
    
    func searchPhoto(query: String, photos: [PhotoModel], completion: @escaping ([PhotoModel]) -> Void) {
        let filterResult = photos.filter{$0.id == query || ($0.author ?? "").contains(query)}
        completion(filterResult)
    }    
}
