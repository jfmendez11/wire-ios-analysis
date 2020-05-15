//
//  ConsSecTableViewCell.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 15/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class ConsSecTableViewCell: UITableViewCell {
    @IBOutlet weak var conLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        conLabel.adjustsFontSizeToFitWidth = true
        conLabel.minimumScaleFactor = 0.2
        conLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
