//
//  HeroesTableVC.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 9/7/22.
//

import UIKit

final class HeroesTableVC: UITableViewController, UISearchResultsUpdating {

    
        
    var heroes: [Hero] = []
    var filteredHeroes: [Hero] = []
    var isFiltered: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: "HeroTVCell", bundle: nil), forCellReuseIdentifier: "HeroTVCell")
        
        setHeroes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return number of heroes or filtered heroes
        var numberOfHeros = 0
        if !isFiltered {
            numberOfHeros = heroes.count
        } else {
            numberOfHeros = filteredHeroes.count
        }
        return numberOfHeros
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeroTVCell", for: indexPath) as? HeroTVCell else { return HeroTVCell()}
        
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
    
    // Set the row height to 100. Same as the height constraint of the image to avoid UIView-Encapsulated-Layout-Height warning.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = HeroDetailVC()
        
        // Set hero from heroes list or filtered list
        if !isFiltered {
            detailVC.set(model: heroes[indexPath.row])
        } else {
            detailVC.set(model: filteredHeroes[indexPath.row])
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HeroTVCell else {return}
        // Fade in animation only happens to be when showing the full list of heroes
        guard !isFiltered else { return }
        // Fade in hero images
        cell.iv_heroImage.alpha = 0.5
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {cell.iv_heroImage.alpha = 1}, completion: nil)
    }
    
    private func setHeroes() {
        guard let token = LocalDataModel.getToken() else { return }
        // Set heroes
        let networkModel = NetworkModel(token: token)
        networkModel.getHeroes { [weak self] heroes, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.heroes = heroes
                self.tableView.reloadData()
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
                tableView.reloadData()
            }
            isFiltered = false
            filteredHeroes = heroes
            return
        }
        filteredHeroes = heroes.filter { $0.name.localizedCaseInsensitiveContains(text) }
        isFiltered = true
        tableView.reloadData()
    }
    
}
