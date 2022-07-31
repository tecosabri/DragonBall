//
//  TabBarC.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 15/7/22.
//

import UIKit

final class TabBarC: UITabBarController, UISearchResultsUpdating {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let heroesTable = HeroesTableVC()
        heroesTable.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "list.dash"), tag: 0)
        let heroesCollection = HeroesCollectionVC(collectionViewLayout: UICollectionViewFlowLayout())
        heroesCollection.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "squareshape.split.2x2"), tag: 1)
        viewControllers = [heroesTable, heroesCollection]
        title = "Heroes"
        setLogOutButton(onTabBar: self)
        navigationItem.hidesBackButton = true
        setSearchBar(onTabBar: self)
    }

    private func setLogOutButton(onTabBar tabBar: TabBarC) {
        tabBar.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salir", style: .plain, target: self, action: #selector(logout))
    }
    @objc
    func logout() {
        showYesNoAlert(withTitle: "¿Cerrar sesión?", andMessage: "¿Está seguro de que quiere cerrar la sesión?") { answer in
            if answer {
                LocalDataModel.deleteToken()
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    private func setSearchBar(onTabBar tabBar: TabBarC) {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = tabBar
        // Set up search bar
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "¡Busca a tu héroe!"
        searchController.searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let heroesTable = viewControllers?[0] as? HeroesTableVC else { return }
        guard let heroesCollection = viewControllers?[1] as? HeroesCollectionVC else { return }
    
        
        heroesTable.updateSearchResults(for: searchController)
        heroesCollection.updateSearchResults(for: searchController)
    }
    
}
