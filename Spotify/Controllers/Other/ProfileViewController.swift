//
//  ProfileViewController.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDataSource {
    

    let tableViewCell = "cell"
    
    var userInfo = [String]()
    
    var imageProfile: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    lazy var tableview: UITableView = {
        let tableView = UITableView(frame: .zero)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCell)
        
        tableView.isHidden = true
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserInfo()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableview.frame = view.bounds
    }
    
    private func setupViews(){
        view.backgroundColor = .systemBackground
        view.addSubview(tableview)
        
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    private func fetchUserInfo(){
        APICaller.shared.getCurrentUserProfile{res in
            switch res {
            case .success(let model):
                self.updateUI(user: model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateUI(user: UserProfile){
        DispatchQueue.main.async {
            self.tableview.isHidden = false
            self.userInfo.append("Nome: \(user.display_name)")
            self.userInfo.append("E-mail: \(user.email)")
            self.userInfo.append("ID: \(user.id)")
            self.userInfo.append("Plano: \(user.product)")
            self.setupTableViewHeader(imageURL: URL(string: user.images.first?.url ?? "")!)
            self.tableview.reloadData()
        }
    }
    
    private func setupTableViewHeader(imageURL: URL){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 2))
        
        let imageSize: CGFloat = 150
        imageProfile.sd_setImage(with: imageURL, completed: .none)
        imageProfile.translatesAutoresizingMaskIntoConstraints = false
        imageProfile.addSize(width: imageSize, height: imageSize)
        
        imageProfile.contentMode = .scaleAspectFill
        imageProfile.layer.masksToBounds = true
        imageProfile.layer.cornerRadius = imageSize/2
        
        headerView.addSubview(imageProfile)
        
        imageProfile.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        imageProfile.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        tableview.tableHeaderView = headerView
    }

}

extension ProfileViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: tableViewCell)

        cell?.textLabel?.text = userInfo[indexPath.row]
        
        cell?.selectionStyle = .none
        
        return cell!
    }
}
