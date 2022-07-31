//
//  HeroVCell.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 9/7/22.
//

import UIKit

final class HeroTVCell: UITableViewCell {

    @IBOutlet weak var iv_heroImage: UIImageView!
    @IBOutlet weak var l_heroName: UILabel!
    @IBOutlet weak var tv_heroDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iv_heroImage.image = nil
        l_heroName.text = nil
        tv_heroDescription.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(model: Hero){
        iv_heroImage.setImage(url: model.photo)
        l_heroName.text = model.name
        tv_heroDescription.text = model.description
    }
}
