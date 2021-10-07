//
//  SettingsViewController.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource {
    
    private var cellTableOptions = "cell"
    
    private var sections = [Section]()
    
    lazy private var tableOptions: UITableView  = {
        let table = UITableView(frame: .zero, style: .grouped)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellTableOptions)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureModels()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableOptions.frame = view.bounds
    }
    
    private func setupViews(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableOptions)
        tableOptions.dataSource = self
        tableOptions.delegate = self
        
    }
    
    private func configureModels() {
        sections.append(Section(title: "Perfil", options: [Option(title: "Ver Perfil", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        sections.append(Section(title: "Conta", options: [Option(title: "Sair", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOut()
            }
        })]))
    }
    
    private func viewProfile() {
       let vc = ProfileViewController()
        
        vc.title = "Perfil"
        
        vc.navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOut(){
        let alert = UIAlertController(title: "Sair", message: "Você tem certeza que deseja sair?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: {_ in
            AuthManager.shared.signOut{[weak self] _ in
                DispatchQueue.main.async {
                    let vc = UINavigationController(rootViewController: WelcomeViewController())
                    
                    vc.navigationBar.prefersLargeTitles = true
                    vc.navigationItem.largeTitleDisplayMode = .always
                    vc.modalPresentationStyle = .fullScreen
                    
                    self?.present(vc, animated: true){
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    
                }
            }
        
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOptions.dequeueReusableCell(withIdentifier: cellTableOptions)
        
        cell?.textLabel?.text = sections[indexPath.section].options[indexPath.row].title
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Call handler for cll
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }
}
