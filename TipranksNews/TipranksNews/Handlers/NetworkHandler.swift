//
//  NetworkHandler.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import Foundation

enum NetworkError: Error {
    case noData
    case decodeError
    case urlError
    case responseError
}

class NetworkHandler {
    
    static let shared = NetworkHandler()
    
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
        
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private func decode<T>(model: T.Type, data: Data) -> (Decodable?, Error?) where T:Decodable {
        do {
            let decodable = try JSONDecoder().decode(model, from: data)
            return (decodable, nil)
        } catch {
            return (nil, NetworkError.decodeError)
        }
    }
    
    func getRequest<T>(address: String, decodeType: T.Type, completion: @escaping (Bool, Decodable?, Error?) -> Void) where T: Decodable {
        
        guard let url = URL.init(string: address) else { completion(false, nil, NetworkError.urlError)
            return }
        
        // in case the data task already exists, we will cancel it for reusing
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url, completionHandler: {[weak self] (data,response, error) in
            defer { self?.dataTask = nil }
            
            if let error = error {
                completion(false, nil, error)
            } else if let data = data,
                let response = response as? HTTPURLResponse
            {
                if response.statusCode == 200 {
                    // decode the data by the decodable type
                     let (decodeModel, errorDecode) = self?.decode(model: decodeType, data: data) ?? (nil, NetworkError.noData)
                    
                    completion(true, decodeModel, errorDecode ?? nil)
                } else {
                    completion(false, nil, NetworkError.responseError)
                }
            }
        })
        
        dataTask?.resume()
    }
}

