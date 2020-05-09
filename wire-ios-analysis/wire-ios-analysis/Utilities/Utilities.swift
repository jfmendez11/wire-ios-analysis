//
//  Utilities.swift
//  TuristApp
//
//  Created by Diana Cepeda on 4/9/20.
//  Copyright © 2020 Diana Cepeda. All rights reserved.
//

import Foundation
import UIKit

public class Utilities {
    
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        //button.backgroundColor = UIColor.init(red: 206/255, green: 181/255, blue: 167/255, alpha: 1)
        button.backgroundColor = UIColor.init(red: 132/255, green: 140/255, blue: 142/255, alpha: 1)
        button.layer.cornerRadius = 25.0
    }
    
    static func styleHollowButton(_ button:UIButton) {
    
    // Hollow rounded corner style
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.darkGray.cgColor
    button.layer.cornerRadius = 25.0
    button.tintColor = UIColor.black
}
}
