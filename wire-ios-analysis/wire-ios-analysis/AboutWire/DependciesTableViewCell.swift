//
//  DependciesTableViewCell.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 14/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class DependciesTableViewCell: UITableViewCell {
    @IBOutlet weak var dependencyNameLabel: UILabel!
    @IBOutlet weak var dependencySizeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
