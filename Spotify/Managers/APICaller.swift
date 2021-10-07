//
//  APICaller.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init(){}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET){ baseResult in
            let task = URLSession.shared.dataTask(with: baseResult) { data, _, error in
                guard let response = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(UserProfile.self, from: response)
                    completion(.success(response))
                } catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }
            
            task.resume()
        }
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        AuthManager.shared.withValidToken { token in
            guard let URL = url else {
                return
            }
            
            var request = URLRequest(url: URL)
            
            request.httpMethod = type.rawValue
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            completion(request)
            
        }
    }
}
