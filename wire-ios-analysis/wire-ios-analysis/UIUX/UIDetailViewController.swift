//
//  UIDetailViewController.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 13/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class UIDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDescription: UITextView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var labelCode: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containterView: UIView!
    
    
    var section:Section?
    
    var sectionsCode1 = [SectionCode]()
    var sectionsCode2 = [SectionCode]()
    var sectionsCode3 = [SectionCode]()
    var sectionsCode4 = [SectionCode]()
    var sectionsCode5 = [SectionCode]()
    
    fileprivate let collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
           cv.showsHorizontalScrollIndicator = false
           cv.translatesAutoresizingMaskIntoConstraints = false
           cv.register(UICustomCell.self, forCellWithReuseIdentifier: "codeCell")
           return cv
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        codeView.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: labelCode.bottomAnchor, constant: 4).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: codeView.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: codeView.trailingAnchor, constant: -8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: codeView.bottomAnchor, constant: -8).isActive = true
    
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        labelDescription.text = section?.description
        imageView.image = section?.image
        
        
        
        setupInformation()
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containterView
    }
    
    func setupInformation(){
         let designMetaphor1 = SectionCode(description: getDesignMetaphor1(),image: UIImage(named: "designMetaphor1")!)
                       sectionsCode1.append(designMetaphor1)
        let designMetaphor2 = SectionCode(description: getDesignMetaphor2(),image: UIImage(named: "designMetaphor2")!)
           sectionsCode1.append(designMetaphor2)
        
        let uiDevelopment1 = SectionCode(description: getUIDevelopment1(),image: UIImage(named: "uiDevelopment1")!)
                  sectionsCode2.append(uiDevelopment1)
        let uiDevelopment2 = SectionCode(description: getUIDevelopment2(),image: UIImage(named: "uiDevelopment2")!)
        sectionsCode2.append(uiDevelopment2)
        
        let useColors1 = SectionCode(description: getUseColors1(),image: UIImage(named: "useColors1")!)
                  sectionsCode3.append(useColors1)
        let useColors2 = SectionCode(description: getUseColors2(),image: UIImage(named: "useColors2")!)
        sectionsCode3.append(useColors2)
        
        let useLocal1 = SectionCode(description: getUseLocalizations1(),image: UIImage(named: "useLocation1")!)
                  sectionsCode4.append(useLocal1)
        let useLocal2 = SectionCode(description: getUseLocalizations2(),image: UIImage(named: "useLocation2")!)
        sectionsCode4.append(useLocal2)
        let useLocal3 = SectionCode(description: getUseLocalizations3(),image: UIImage(named: "useLocation3")!)
        sectionsCode4.append(useLocal3)
        
        let useText1 = SectionCode(description: getUseTextFields1(),image: UIImage(named: "useText2")!)
                  sectionsCode5.append(useText1)
        let useText2 = SectionCode(description: getUseTextFields2(),image: UIImage(named: "useText3")!)
        sectionsCode5.append(useText2)
      }
      
      private func getDesignMetaphor1() -> String {
          return """
            Wire uses it's one icon kit which is called StyleKitIcon and they use and enum to show all the icons possible. In this snippet we can only see a few icons that are used, but the list is very long. When icons are needed, the class IconButton.swift is called which is the one that sets icons depending on a certain style as seen in the next picture.
          """
      }
    private func getDesignMetaphor2() -> String {
        return """
            Here we see the class IconButton.swift which sets icons depending on it's purpose. In this portion of code we can see that there are certain styles for the icons like circular, navigation and default, each with their own design. As they are taking some time to do each icon, they should take into account the design metaphor they are aiming to. The key is to use icons filled especially in tab navigators and hollow in the rest of the application, be consistent with the use of the same icons for certain purposes, and try to make them similar to the system icons.
        """
    }
      private func getUIDevelopment1() -> String {
          return """
            In the app we can see that they take into account the notch for the users who have the newer iPhones. This is a good practice because Wire is "personalized" for the user and this helps with the user experience. The snippet of code is in the class UIScreen+SafeArea.swift and what it does is if the phone has a notch, the view controller safe area changes to adapt to the phone. This is used throughout the whole app to give an overal better experience.
          """
      }
    private func getUIDevelopment2() -> String {
        return """
            Wire allows landscape mode to be used for iPads. First, Wire verifies if the device that is used allows landscape mode, which is done in class UIViewController.swift. If the device is supported, in the UIDeviceOrientation.swift class we can see this snippet where the device orientation is set given the variable aspect ratio. This aspect ratio verifies the width and height of the view to define if they are dealing with landscape or portrait mode. This is an excelent practice because, as they are letting the user download the app in an iPad, Wire should give the user the possibility to use the app in all the orientations possible to give a better experience.
        """
    }
    
      private func getUseColors1() -> String {
          return """
            The main problem we can see with use of colors is when you pick an accent color, it also changes the background color of the app, and it doesn't let you go back to the clear or white background. The options the user has to choose are colors that are too vibrant, which are shown in this snippet.This accent colors can be selected using the function allSelectable() in class AccentColor. The only colors available were the ones we can see in the image.The code after changes is shown in the image.

          """
      }
    private func getUseColors2() -> String {
             return """
             The snippet of code that shows the setting of the backgroung color is done in this method ContainerBackgroundColor in class UserImageView.swift. This method changes the background color taking into account the reference the user has to an accent color. They set some cases that are .image and .text, and in both cases if the user is connected it sets the background color, to the accent one. More cases are needed to solve this problem.

             """
         }
      private func getUseLocalizations1() -> String {
          return """
            Wire uses localizations to manage the user's device language. This problem that was found can be easyly solved by adding a new line to the locations. In this snippet we can see that whenever .leave case is called (User leaves a group), the text that is put in the alert notification corresponds to: meta.leave_conversation_button_leave_and_delete. This function is found in the enum class LeaveResult.swift were the bar is initialized.

          """
      }
    private func getUseLocalizations2() -> String {
        return """
            Now, we are focusing on the alert notification found in class ParticipantsStringFormatter.swift. Here we can see that theres an extension which has a function called format key. This function triggers the .leave case as the user wants to leave a group.

        """
    }
    private func getUseLocalizations3() -> String {
        return """
            To solve the problem, as said in previous images, its only necesary to change the localizations code of the language, in this case Spanish Localization file. In this snippet we can see that the localization for the corresponding message is changed. So, when the app is launched, the alert notification would be all in Spanish. 

        """
    }
      private func getUseTextFields1() -> String {
          return """
            In this picture we can see the account information of the user like UserName, Phone Number and Email. All these text fields are editable and we found that any of the fields has a restriction of the numbers of characters that can be used, nor the type of character that can be put in the text field (Only phone number has restriction to put numbers but it can be as long as the user likes, no revision is made). So, focusing in the user name, we can put a super long user name with special characters that aren't necessary and can be a source of trouble later on.

          """
      }
    private func getUseTextFields2() -> String {
        return """
            In this snippet taken from the class SettingsPropertyTextValueCellDescription.swift the text fields in the settings section are managed. As we can see, when the settingsProperty is enabled which happens everytime the user opens the Settings view, text fields were enabled and no restriction was handled. The main problem is the fact that the user can create a very long username that can be trouble later. So, adding some lines corresponding to max characters in the text field should be enough to solve this problem.
        """
    }
}
extension UIDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: codeView.frame.width/1.1, height: codeView.frame.height/1.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if labelTitle.text == "Use of localizations" {
            return 3
        } else{
        return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as! UICustomCell
        cell.backgroundColor = UIColor(red: CGFloat(231)/255.0, green: CGFloat(231)/255.0, blue: CGFloat(231)/255.0, alpha: 1.0)
    
        cell.layer.cornerRadius = 5
        
       if labelTitle.text == "Design Metaphor"{
         
         cell.imageView.image = sectionsCode1[indexPath.row].image
         cell.descriptionLabel.text = sectionsCode1[indexPath.row].description
         }
         else if labelTitle.text == "UI development" {
             cell.imageView.image = sectionsCode2[indexPath.row].image
             cell.descriptionLabel.text = sectionsCode2[indexPath.row].description
         }
         else if labelTitle.text == "Use of colors" {
            cell.imageView.image = sectionsCode3[indexPath.row].image
            cell.descriptionLabel.text = sectionsCode3[indexPath.row].description
        }
        else if labelTitle.text == "Use of localizations" {
             cell.imageView.image = sectionsCode4[indexPath.row].image
             cell.descriptionLabel.text = sectionsCode4[indexPath.row].description
         }
         else if labelTitle.text == "Use of text fields" {
            cell.imageView.image = sectionsCode5[indexPath.row].image
            cell.descriptionLabel.text = sectionsCode5[indexPath.row].description
        }
         return cell
    }
    
}

class UICustomCell: UICollectionViewCell {
    
    var sectionCode: SectionCode? {
        didSet {
            guard let codeAnalysis = sectionCode else { return }
            imageView.image = codeAnalysis.image
            descriptionLabel.text = codeAnalysis.description
        }
    }
    
    fileprivate let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
          img.backgroundColor = .white
          img.layer.cornerRadius = 8.0
          img.clipsToBounds = true
        return img
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.textAlignment = .natural
           lbl.font = UIFont.systemFont(ofSize: 11)
           lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 0.5
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

