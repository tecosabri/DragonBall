//
//  TransformationsTVCell.swift
//  DragonBall
//
//  Created by Ismael Sabri Pérez on 14/7/22.
//

import UIKit

final class TransformationsTVCell: UITableViewCell {

    @IBOutlet weak var iv_transformation: UIImageView!
    @IBOutlet weak var l_transformationName: UILabel!
    @IBOutlet weak var l_transformationDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(model: Transformation){
        iv_transformation.setImage(url: model.photo)
        l_transformationName.text = model.name
        l_transformationDescription.text = model.description
    }
}
