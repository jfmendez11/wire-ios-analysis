//
//  DataEntry.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 12/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import Foundation
import UIKit

struct DataEntry {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Float
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
}
