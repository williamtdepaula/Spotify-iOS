//
//  AuthManager.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import Foundation

final class AuthManager{
    static let shared = AuthManager()
    
    private init(){}
    
    struct Constants {
        static let clientID = "34b813662d4e4c669acca255c08295c7"
        static let clientSecret = "ea56c4b0c9934633bee240527eb39a51"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURL = "https://www.google.com"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let url = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURL)&show_dialog=TRUE"
        
        return URL(string: url)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }

    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }

    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expiration") as? Date
    }

    private var shouldRefrehToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentTimeMoreFiveMin = Date().addingTimeInterval(500)
        return currentTimeMoreFiveMin >= expirationDate
    }

    //Get token
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void){
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }

        let token = (Constants.clientID+":"+Constants.clientSecret).data(using: .utf8)
        
        guard let tokenBase64 = token?.base64EncodedString() else {
            print("Error get token base64")
            completion(false)
            return
        }
        
        var components = URLComponents()
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(tokenBase64)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: response)
                completion(true)
            } catch {
                print("Error", error.localizedDescription)
                completion(false)
            }
        }
        
        task.resume()
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void){
        guard shouldRefrehToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = self.refreshToken else {
            completion(false)
            return
        }
        
        //Get new refresh token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }
        
        let token = (Constants.clientID+":"+Constants.clientSecret).data(using: .utf8)
        
        guard let tokenBase64 = token?.base64EncodedString() else {
            print("Error get token base64")
            completion(false)
            return
        }
        
        var components = URLComponents()
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(tokenBase64)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: response)
                completion(true)
            } catch {
                print("Error", error.localizedDescription)
                completion(false)
            }
        }
        
        task.resume()
        
    }
    
    public func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expiration")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
    }
}
