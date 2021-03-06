//
//  ServiceProvider.swift
//  NewsApp
//
//  Created by Shalu Scaria on 2021-03-05.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError: Error {
    case badURL, requestFailed, unknown , decodeFailed
}

/// Class that will actually handle the API calls with a URLSession and resturn response
class ServiceProvider<T:Service> {
    //MARK:- Properties
    var urlSession = URLSession.shared
    
}

//MARK:- Public funcs
extension ServiceProvider {
    
    /// Performs API request which is called by any service class
    ///
    /// - Parameters:
    ///     - service: any service that confirms to Service protocol
    ///     - completion: Request completion Handler, will be returning Data
    func loadService(service:T, completion:@escaping(Result<Data>) -> Void) {
        executeRequest(service.urlRequest, completion: completion)
    }
    
    
    /// Performs API request which is called by any service class
    ///
    /// - Parameters:
    ///     - service: any service that confirms to Service protocol
    ///     - decodeType: decodable object.type
    ///     - completion: Request completion Handler
    func load<U>(
        service: T,
        decodeType: U.Type,
        completion:@escaping(Result<U>)
    -> Void) where U: Decodable {
        
        executeRequest(service.urlRequest) { result in
            
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(decodeType, from: data)
                    completion(.success(response))
                }
                catch {
                    completion(.failure(.decodeFailed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}

//MARK:- Private funcs
extension ServiceProvider {
    
    private func executeRequest(
        _ request: URLRequest,
        completion:@escaping(Result<Data>)
    -> Void) {
        
        urlSession.dataTask(with: request) { data, _ , error in
            
            if let data = data  {
                /// success: send data back
                completion(.success(data))
            } else if error != nil {
                /// any sort of network failure
                completion(.failure(.requestFailed))
            } else {
                completion(.failure(.unknown))
            }
        }.resume()
    }
    
}
