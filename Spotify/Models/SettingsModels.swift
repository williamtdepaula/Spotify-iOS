//
//  SettingsModels.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 06/10/21.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
