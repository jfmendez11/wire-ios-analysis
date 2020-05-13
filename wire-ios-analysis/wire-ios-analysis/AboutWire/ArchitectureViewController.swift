//
//  ArchitectureViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 13/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class ArchitectureViewController: UIViewController {
    
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var followUpLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        introLabel.numberOfLines = 0
        introLabel.textAlignment = .justified
        introLabel.text = getIntro()
        
        followUpLabel.numberOfLines = 0
        followUpLabel.textAlignment = .justified
        followUpLabel.text = getFollowUp()
        // Do any additional setup after loading the view.
    }
    
    private func getIntro() -> String {
        return """
        The Wire mobile app has an architectural layer that we call sync engine . It is the client-side layer that processes all the data that is displayed in the mobile app. It handles network communication and authentication with the backend, push notifications, local caching of data, client-side business logic, signaling with the audio-video libraries, encryption and decryption (using encryption libraries from a lower level) and other bits and pieces.
        
        The user interface layer of the mobile app is built on top of the sync engine, which provides the data to display to the UI. The sync engine itself is built on top of a few third-party frameworks, and uses Wire components that are shared between platforms for cryptography (Proteus/Cryptobox) and audio-video signaling (AVS).
        """
    }
    
    private func getFollowUp() -> String {
        return """
        Wire iOS client is structured in a modular way. The main application is using the set of libraries that are implementing the different logical parts of the synchronization and caching logic. Most of those libraries are developer and maintained by Wire in-house.
        
        The libraries source and binaries reside on GitHub. Carthage is used to resolve the dependencies and fetch the correct libraries versions.
        
        The list of all the libraries used can be found in Cartfile.resolved of the Wire-iOS project. Some other UI-related libraries are fetched via CocoaPods, list of those can be found in Podfile.
        """
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
