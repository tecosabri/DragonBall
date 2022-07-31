//
//  HeroDetailVC.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 10/7/22.
//

import UIKit

class HeroDetailVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var iw_heroImage: UIImageView!
    @IBOutlet weak var l_heroName: UILabel!
    @IBOutlet weak var tv_heroDescription: UITextView!
    @IBOutlet weak var bu_transformations: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var iv_heightConstraint: NSLayoutConstraint!
    
    private var model: Hero?
    let imageHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        guard let model = model else {return}
        
        self.title = model.name
        self.l_heroName.text = model.name
        self.tv_heroDescription.text = model.description
        self.iw_heroImage.setImage(url: model.photo)
    }
    
    func set(model: Hero){
        self.model = model
    }
    
    
    @IBAction func navigate(_ sender: Any) {
        guard let model = model else { return }
        let transformations = TransformationsTableVC()
        transformations.set(heroId: model.id)
        navigationController?.pushViewController(transformations, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let correctedOffset = scrollView.contentOffset.y + view.safeAreaInsets.top
        iv_heightConstraint.constant = imageHeight - correctedOffset
    }
}

