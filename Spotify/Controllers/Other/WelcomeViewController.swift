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
        
        button.backgroundColor = .systemGreen
        button.setTitle("Entrar com o Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        return button
    }()
    
    
    private let borderedButton: UIButton = {
        let button = UIButton()
        
        button.tintColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .clear
        button.setTitle("Continuar com um núemro de telefone", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.contentHorizontalAlignment = .center
        
        return button
    }()
    
    lazy private var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2))
        
        backgroundImage.image = UIImage(named: "musica")
        
        backgroundImage.contentMode = .scaleAspectFill
        
        return backgroundImage
    }()
    
    
    lazy private var iconImage: UIImageView = {
        let icon = UIImageView(frame: CGRect(x: view.bounds.width / 2.4, y: view.frame.height/2.8, width: 60, height: 60))

        icon.image = UIImage(named: "mini-icon")
        
        return icon
    }()
    
    lazy private var titleLabel: UILabel = {
        let title = UILabel()
        
        title.text = "Milhões de músicas á sua escolha.\nGrátis no Spotify"
        title.numberOfLines = 2
        title.textAlignment = .center
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        
        return title
    }()
    
    private var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout(){
        view.backgroundColor = .black
        
        view.addSubview(backgroundImage)
        view.addSubview(iconImage)
        view.addSubview(titleLabel)
        view.addSubview(signButton)
        view.addSubview(borderedButton)
        
        gradient.frame = backgroundImage.frame
        
        backgroundImage.layer.insertSublayer(gradient, at: 0)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        signButton.translatesAutoresizingMaskIntoConstraints = false
        borderedButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        signButton.addSize(width: view.frame.width - 50, height: 50)
        signButton.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 50).isActive = true
        signButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        borderedButton.addSize(width: view.frame.width - 50, height: 50)
        borderedButton.topAnchor.constraint(equalTo: signButton.bottomAnchor, constant: 10).isActive = true
        borderedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        signButton.addTarget(self, action: #selector(onTapButtonSignIn), for: .touchUpInside)
    }
    
    @objc func onTapButtonSignIn(){
        navigateToLogin()
    }
    
    func navigateToLogin(){
        
        let authVC = AuthViewController()
        
        authVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.backButtonTitle = "Voltar"
        
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
