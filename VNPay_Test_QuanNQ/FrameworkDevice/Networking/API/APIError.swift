//
//  APIError.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(statusCode: Int)
    case downloadFail(Error)
}
