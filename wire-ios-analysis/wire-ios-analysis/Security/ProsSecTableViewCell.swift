//
//  ProsSecTableViewCell.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 15/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class ProsSecTableViewCell: UITableViewCell {
    @IBOutlet weak var proLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        proLabel.adjustsFontSizeToFitWidth = true
        proLabel.minimumScaleFactor = 0.2
        proLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
