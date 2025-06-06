//
//  PhotoViewModel.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 5/6/25.
//

import Foundation
class PhotoViewModel {
    private let photoUseCase: PhotoUseCaseProtocol
    var photos: [PhotoModel] = []
    var cachePhotos: [PhotoModel] = []
    var onPhotoUpdated: (() -> Void)?
    let limit = 100
    
    init(photoUseCase: PhotoUseCaseProtocol) {
        self.photoUseCase = photoUseCase
    }
    
    func fetchPhotos() {
        photoUseCase.fetchPhotos(page: 0, limit: limit) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.cachePhotos = photos
                self?.onPhotoUpdated?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadMore(page: Int) {
        photoUseCase.fetchPhotos(page: page, limit: limit) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let photos):
                strongSelf.photos += photos
                strongSelf.cachePhotos += photos
                strongSelf.onPhotoUpdated?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshPhotos() {
        photoUseCase.fetchPhotos(page: 0, limit: self.limit) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let photos):
                strongSelf.photos.removeAll()
                strongSelf.photos = photos
                strongSelf.cachePhotos = photos
                strongSelf.onPhotoUpdated?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func downloadPhoto(url: URL, completion: @escaping (Data?) -> Void) {
        photoUseCase.downloadPhoto(url: url) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }
    
    func searchPhoto(query: String) {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        photoUseCase.searchPhoto(query: query, photos: self.cachePhotos) { [weak self] photos in
            guard let strongSelf = self else { return }
            strongSelf.photos.removeAll()
            if query.isEmpty {
                strongSelf.photos = strongSelf.cachePhotos
            } else {
                strongSelf.photos = photos
            }
            strongSelf.onPhotoUpdated?()
        }
    }
}
