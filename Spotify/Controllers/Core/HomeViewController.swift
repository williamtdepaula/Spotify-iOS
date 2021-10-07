//
//  ViewController.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(openUserProfile))
        
    }
    
    @objc func openUserProfile() {
        let vc = SettingsViewController()
        
        vc.title = "Configurações"
        
        vc.navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

