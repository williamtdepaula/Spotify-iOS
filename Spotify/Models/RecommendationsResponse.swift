//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 09/10/21.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
