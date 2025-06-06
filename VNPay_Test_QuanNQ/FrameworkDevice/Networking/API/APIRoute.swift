//
//  APIRoute.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import Foundation

enum APIRoute {
    case getData(page: Int, limit: Int)
}

extension APIRoute: EndPoint {
    var baseURL: String {
        switch self {
        case.getData:
            return "https://picsum.photos/"
        }
    }
    
    var path: String {
        switch self {
        case .getData(let page, let limit):
            return "v2/list?page=\(page)&limit=\(limit)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getData:
            return .get
        }
    }
    
    var parameter: Params {
        switch self {
        case .getData:
            return .plain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Accept": "application/json", "Content-Type": "application/json"]
        }
    }
}
