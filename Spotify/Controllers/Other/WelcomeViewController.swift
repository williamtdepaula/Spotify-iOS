//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .white
        button.setTitle("Entrar com o Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        
        view.backgroundColor = .systemGreen
        
        view.addSubview(signButton)
        
        signButton.addTarget(self, action: #selector(onTapButtonSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        signButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
    }
    
    @objc func onTapButtonSignIn(){
        navigateToLogin()
    }
    
    func navigateToLogin(){
        
        let authVC = AuthViewController()
        
        authVC.navigationItem.largeTitleDisplayMode = .never
        
        authVC.successHandler = {[weak self] success in
            DispatchQueue.main.async {
                self?.handleSign(success: success)
            }
        }
        
        navigationController?.pushViewController(authVC, animated: true)
    }
    
    private func handleSign(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops!", message: "Algo de errado aconteceu no login", preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(title: "Tentar novamente", style: .default){ _ in
                    self.navigateToLogin()
                }
            )
            
            alert.addAction(
                UIAlertAction(title: "Cancelar", style: .default)
            )
            
            present(alert, animated: true)
            
            return
        }
        let mainAppTabBarVC = TabBarViewController()
        
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        
        present(mainAppTabBarVC, animated: true)
    }
}
