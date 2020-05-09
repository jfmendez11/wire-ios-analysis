//
//  StartViewController.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 9/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    let image = UIImageView()
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleFilledButton(button)
        // Do any additional setup after loading the view
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        let tabViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabViewController
        
        view.window?.rootViewController = tabViewController
        view.window?.makeKeyAndVisible()
    }
}
