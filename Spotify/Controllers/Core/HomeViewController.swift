//
//  ViewController.swift
//  Spotify
//
//  Created by William Tristão de Pauloa on 04/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    let collectionViewID = "cell"
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSectionLayout(section: sectionIndex)
        }
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewID)
        
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    private func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(110)
            ),
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        
        fetchData()
    }
    
    @objc func openUserProfile() {
        let vc = SettingsViewController()
        
        vc.title = "Configurações"
        
        vc.navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchData(){
        APICaller.shared.getRecommendedGenres { response in
            switch response {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                
                while seeds.count < 5 {
                    if let randomGenre = genres.randomElement(), (seeds.first(where: {$0 == randomGenre}) == nil) {
                        seeds.insert(randomGenre)
                    }
                }
                
                
                APICaller.shared.getRecommendations(genres: seeds) { responseRecommendations in
                    
                    print("Genres Recommended: \(responseRecommendations)")
                    
                }
                
            case .failure(_):
                break
            }
        }
    }
}

//MARK: - CodeView
extension HomeViewController: CodeView {
    func setupHierarchy() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(openUserProfile))
        
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.frame = view.bounds
    }
    
    func setupAdditional() {
        
    }
    
}

//MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewID, for: indexPath)
        
        cell.backgroundColor = .systemGreen
        
        return cell
    }
    
    
}
