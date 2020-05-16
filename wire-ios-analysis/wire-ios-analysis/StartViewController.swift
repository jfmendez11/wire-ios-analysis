//
//  StartViewController.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 9/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var namesLabel: UILabel!
    
    let image = UIImageView()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(button)
        // Do any additional setup after loading the view
        namesLabel.adjustsFontSizeToFitWidth = true
        namesLabel.numberOfLines = 0
        namesLabel.text = getNames()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabViewController
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
    
    private func getNames() -> String {
        return """
        Diana Cepeda       201613662
        Juan Felipe Méndez 201423877
        """
    }
}
