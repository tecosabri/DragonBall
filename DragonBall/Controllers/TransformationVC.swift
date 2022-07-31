//
//  TransformationVC.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 14/7/22.
//


import UIKit

final class TransformationVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet var l_name: UILabel!
    @IBOutlet weak var l_descritpion: UITextView!
    @IBOutlet weak var iv_image: UIImageView!
    @IBOutlet weak var iv_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var transformation: Transformation?
    let imageHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self

        
        guard let transformation = transformation else {
            return
        }
        


        l_name.text = transformation.name
        l_descritpion.text = transformation.description
        iv_image.setImage(url: transformation.photo)
     
    }


    func set(transformation: Transformation){
        self.transformation = transformation
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let correctedOffset = scrollView.contentOffset.y + view.safeAreaInsets.top
        iv_heightConstraint.constant = imageHeight - correctedOffset
    }
}
