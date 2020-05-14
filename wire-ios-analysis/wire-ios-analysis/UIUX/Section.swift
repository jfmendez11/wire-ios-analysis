//
//  Section.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 13/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class Section {
    
    var title: String
    var description: String
    var image: UIImage
    
    init(title: String, description: String, image: UIImage)
    {
        self.title = title
        self.description = description
        self.image = image
    }
}
