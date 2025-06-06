//
//  PhotoUseCaseProtocol.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 5/6/25.
//

import Foundation

protocol PhotoUseCaseProtocol {
    func fetchPhotos(page: Int, limit: Int, comletion: @escaping (Result<[PhotoModel], APIError>) -> Void)
    
    func downloadPhoto(url: URL, completion: @escaping (Result<Data, APIError>) -> Void)
    
    func searchPhoto(query: String, photos: [PhotoModel], completion: @escaping ([PhotoModel])->Void)
}
