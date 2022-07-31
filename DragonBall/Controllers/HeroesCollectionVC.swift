//
//  HeroesCollectionVC.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 9/7/22.
//

import UIKit

final class HeroesCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var heroes: [Hero] = []
    var filteredHeroes: [Hero] = []
    var isFiltered: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib(nibName: "HeroCVCell", bundle: nil), forCellWithReuseIdentifier: "HeroCVCell")
        
        setHeroes()
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return number of heroes or filtered heroes
        var numberOfHeros = 0
        if !isFiltered {
            numberOfHeros = heroes.count
        } else {
            numberOfHeros = filteredHeroes.count
        }
        return numberOfHeros
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCVCell", for: indexPath) as? HeroCVCell else { return HeroCVCell()}
        
        // Display complete or filtered list
        let hero: Hero
        if !isFiltered {
            hero = heroes[indexPath.row]
        } else {
            hero = filteredHeroes[indexPath.row]
        }
        
        cell.set(model: hero)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 140)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = HeroDetailVC()
        
        // Set hero from heroes list or filtered list
        if !isFiltered {
            detailVC.set(model: heroes[indexPath.row])
        } else {
            detailVC.set(model: filteredHeroes[indexPath.row])
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? HeroCVCell else {return}
        // Fade in animation only happens to be when showing the full list of heroes
        guard !isFiltered else { return }
        // Fade in hero images
        cell.iv_heroImage.alpha = 0.5
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {cell.iv_heroImage.alpha = 1}, completion: nil)
    }
    
    
    // Spaces between cells are set with constraints
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    private func setHeroes() {
        guard let token = LocalDataModel.getToken() else { return }
        // Set heroes
        let networkModel = NetworkModel(token: token)
        networkModel.getHeroes { [weak self] heroes, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.heroes = heroes
                self.collectionView.reloadData()
            }
        }
    }
    
    
    private func getSearchController() -> UISearchController {
        guard let navController = self.navigationController,
              let tabBarC = navController.viewControllers[1] as? TabBarC,
              let searchController = tabBarC.navigationItem.searchController
        else { return UISearchController() }
        
        return searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty
        else {
            if isFiltered {
                isFiltered = false
                collectionView.reloadData()
            }
            isFiltered = false
            filteredHeroes = heroes
            return
        }
        filteredHeroes = heroes.filter { $0.name.localizedCaseInsensitiveContains(text) }
        isFiltered = true
        collectionView.reloadData()
    }
    
}
