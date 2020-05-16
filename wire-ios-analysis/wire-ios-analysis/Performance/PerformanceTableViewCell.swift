//
//  PerformanceTableViewCell.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 16/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class PerformanceTableViewCell: UITableViewCell {
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardContainerView: DropShadowView!
    
    let cornerRadius : CGFloat = 25.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardContainerView.layer.cornerRadius = cornerRadius
        cardContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cardContainerView.layer.shadowRadius = 10.0
        cardContainerView.layer.shadowOpacity = 0.3
        
        cardImageView.layer.cornerRadius = cornerRadius
        cardImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
