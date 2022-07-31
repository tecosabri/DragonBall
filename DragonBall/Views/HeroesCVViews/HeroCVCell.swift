//
//  HeroCVCell.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 9/7/22.
//

import UIKit

final class HeroCVCell: UICollectionViewCell {

    @IBOutlet weak var iv_heroImage: UIImageView!
    @IBOutlet weak var l_heroName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iv_heroImage.image = nil
        l_heroName.text = nil
    }
    
    func set(model: Hero){
        iv_heroImage.setImage(url: model.photo)
        l_heroName.text = model.name
    }

}
