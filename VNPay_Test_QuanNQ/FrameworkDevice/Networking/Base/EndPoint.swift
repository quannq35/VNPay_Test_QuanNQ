//
//  EndPoint.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Params {
    case plain
    case parameters(parameters: [String: Any])
}

protocol EndPoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameter: Params { get }
    var headers: [String: String]? { get }
}

