//
//  PerformanceSmallDetailViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 15/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class PerformanceSmallDetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var lableDescription: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var section:Section?
        
        var sectionsCode1 = [SectionCode]()
        var sectionsCode2 = [SectionCode]()
        var sectionsCode3 = [SectionCode]()
        var sectionsCode4 = [SectionCode]()
        var sectionsCode5 = [SectionCode]()
        var sectionsCode6 = [SectionCode]()
        var sectionsCode7 = [SectionCode]()
        
       /* fileprivate let collectionView: UICollectionView = {
               let layout = UICollectionViewFlowLayout()
               layout.scrollDirection = .horizontal
               let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
               cv.showsHorizontalScrollIndicator = false
               cv.translatesAutoresizingMaskIntoConstraints = false
               cv.register(UICustomCell.self, forCellWithReuseIdentifier: "codeCell")
               return cv
           }()*/
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            imageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            imageView.layer.shadowOffset = CGSize(width: 6.0, height: 6.0)
            imageView.layer.shadowOpacity = 1.0
            imageView.layer.shadowRadius = 2.0
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 4.0
            
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 10.0
            
            labelTitle.text = section?.title
            lableDescription.text = section?.description
            imageView.image = section?.image
            
            
            
            setupInformation()
            
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return conteinerView
        }
        
        func setupInformation(){
             let cpu = SectionCode(description: getCPU(),image: UIImage(named: "cpu1")!)
                           sectionsCode1.append(cpu)
            
            let memory = SectionCode(description: getMemory(),image: UIImage(named: "memory1")!)
                      sectionsCode2.append(memory)
            
            let disk = SectionCode(description: getDisk(),image: UIImage(named: "disk1")!)
                      sectionsCode3.append(disk)
            
            let network = SectionCode(description: getNetwork(),image: UIImage(named: "network1")!)
            sectionsCode4.append(network)
            
            let thread = SectionCode(description: getThread(),image: UIImage(named: "thread1")!)
                      sectionsCode5.append(thread)
            
            let storage = SectionCode(description: getStorage(),image: UIImage(named: "storage1")!)
            sectionsCode6.append(storage)
            
            let insights = SectionCode(description: getInsigths(),image: #imageLiteral(resourceName: "wire"))
            sectionsCode7.append(insights)
            
          }
          
          private func getCPU() -> String {
              return """
                Wire uses it's one icon kit which is called StyleKitIcon and they use and enum to show all the icons possible. In this snippet we can only see a few icons that are used, but the list is very long. When icons are needed, the class IconButton.swift is called which is the one that sets icons depending on a certain style as seen in the next picture.
              """
          }
        private func getMemory() -> String {
            return """
                Here we see the class IconButton.swift which sets icons depending on it's purpose. In this portion of code we can see that there are certain styles for the icons like circular, navigation and default, each with their own design. As they are taking some time to do each icon, they should take into account the design metaphor they are aiming to. The key is to use icons filled especially in tab navigators and hollow in the rest of the application, be consistent with the use of the same icons for certain purposes, and try to make them similar to the system icons.
            """
        }
          private func getDisk() -> String {
              return """
                In the app we can see that they take into account the notch for the users who have the newer iPhones. This is a good practice because Wire is "personalized" for the user and this helps with the user experience. The snippet of code is in the class UIScreen+SafeArea.swift and what it does is if the phone has a notch, the view controller safe area changes to adapt to the phone. This is used throughout the whole app to give an overal better experience.
              """
          }
        private func getNetwork() -> String {
            return """
                Wire allows landscape mode to be used for iPads. First, Wire verifies if the device that is used allows landscape mode, which is done in class UIViewController.swift. If the device is supported, in the UIDeviceOrientation.swift class we can see this snippet where the device orientation is set given the variable aspect ratio. This aspect ratio verifies the width and height of the view to define if they are dealing with landscape or portrait mode. This is an excelent practice because, as they are letting the user download the app in an iPad, Wire should give the user the possibility to use the app in all the orientations possible to give a better experience.
            """
        }
        
          private func getThread() -> String {
              return """
                The main problem we can see with use of colors is when you pick an accent color, it also changes the background color of the app, and it doesn't let you go back to the clear or white background. The options the user has to choose are colors that are too vibrant, which are shown in this snippet.This accent colors can be selected using the function allSelectable() in class AccentColor. The only colors available were the ones we can see in the image.The code after changes is shown in the image.

              """
          }
        private func getStorage() -> String {
                 return """
                 The snippet of code that shows the setting of the backgroung color is done in this method ContainerBackgroundColor in class UserImageView.swift. This method changes the background color taking into account the reference the user has to an accent color. They set some cases that are .image and .text, and in both cases if the user is connected it sets the background color, to the accent one. More cases are needed to solve this problem.

                 """
             }
          private func getInsigths() -> String {
              return """
                Wire uses localizations to manage the user's device language. This problem that was found can be easyly solved by adding a new line to the locations. In this snippet we can see that whenever .leave case is called (User leaves a group), the text that is put in the alert notification corresponds to: meta.leave_conversation_button_leave_and_delete. This function is found in the enum class LeaveResult.swift were the bar is initialized.

              """
          }
    }
