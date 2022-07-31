//
//  TransformationsTableVC.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 14/7/22.
//

import UIKit

final class TransformationsTableVC: UITableViewController {
    
    var heroId: String?
    var transformations: [Transformation] = []
    
    func set(heroId: String){
        self.heroId = heroId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: "TransformationsTVCell", bundle: nil), forCellReuseIdentifier: "TransformationsTVCell")
        
        guard let token = LocalDataModel.getToken() else { return }

        // Set transformations
        let networkModel = NetworkModel(token: token)
        guard let heroId = heroId else { return }
        networkModel.getTransformations(id: heroId) { [weak self] transformations, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.transformations = transformations.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending}
                self.tableView.reloadData()
                // Show error message for heroes who have no transformations
                if(transformations.count == 0) {
                    self.showOkAlert(withTitle: "Este héroe no tiene transformaciones") { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transformations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransformationsTVCell", for: indexPath) as? TransformationsTVCell else { return UITableViewCell()}
        
        guard transformations.count > 0 else { return UITableViewCell()}
        let transformation = transformations[indexPath.row]
        cell.set(model: transformation)
        

        return cell
    }
    
    // Set the row height to 100. Same as the height constraint of the image to avoid UIView-Encapsulated-Layout-Height warning.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transformationDetailVC = TransformationVC()
        transformationDetailVC.set(transformation: transformations[indexPath.row])
        navigationController?.pushViewController(transformationDetailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TransformationsTVCell else {return}
        cell.iv_transformation.alpha = 0.5
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {cell.iv_transformation.alpha = 1}, completion: nil)
    }
}
