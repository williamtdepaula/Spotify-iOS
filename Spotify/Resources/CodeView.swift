//
//  CodeView.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 10/10/21.
//

import Foundation

protocol CodeView {
    func setupHierarchy()
    func setupConstraints()
    func setupAdditional()
}

extension CodeView {
    func setupView(){
        setupHierarchy()
        setupConstraints()
        setupAdditional()
    }
}
