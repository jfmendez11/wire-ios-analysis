//
//  UIDetailViewController.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 13/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class UIDetailViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDescription: UITextView!
    
    
    var section:Section?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        imageView.layer.shadowOffset = CGSize(width: 6.0, height: 6.0)
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowRadius = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 4.0
        
        // Do any additional setup after loading the view.
        print(section!.title)
        
        labelTitle.text = section?.title
        labelDescription.text = section?.description
        imageView.image = section?.image
    }
    
    
    
}
