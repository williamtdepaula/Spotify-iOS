//
//  AuthResponse.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 05/10/21.
//

import Foundation

class AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String    
}
