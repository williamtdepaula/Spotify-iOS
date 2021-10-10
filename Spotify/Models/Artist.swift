//
//  Artist.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
