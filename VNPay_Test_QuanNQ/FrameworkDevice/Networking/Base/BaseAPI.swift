//
//  BaseAPI.swift
//  VNPay_Test_QuanNQ
//
//  Created by Quan on 4/6/25.
//

import Foundation

class BaseAPI<T: EndPoint> {
    func requestAPI<M: Codable> (target: T, responseClass: M.Type, completion: @escaping (Result<M, APIError>) -> Void) {
        
        guard let url = URL(string: target.baseURL + target.path) else {
            print("url invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        
        if let headers = target.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if case .parameters(let parameters) = target.parameter {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(M.self, from: data)
                completion(.success(decodedObject))
                
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
    
    private let semaphore = DispatchSemaphore(value: 3)

    func downloadImage(url: URL, completion: @escaping (Result<Data, APIError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.downloadFail(error)))
                return
            }
            self.semaphore.wait()
            
            DispatchQueue.global(qos: .userInitiated).async {
                defer { self.semaphore.signal() }
                if let data = data {
                    completion(.success(data))
                }
            }
        }.resume()
    }
}
