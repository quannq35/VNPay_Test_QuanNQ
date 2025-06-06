//
//  PhotoRepositoryProtocol.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 5/6/25.
//

import Foundation

protocol PhotoRepositoryProtocol {
    func fetchPhotos(page: Int, limit: Int, completion: @escaping (Result<[PhotoModel], APIError>) -> Void)
    func downloadPhoto(url: URL, completion: @escaping (Result<Data, APIError>) -> Void)
}
