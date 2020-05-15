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
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var labelCode: UILabel!
    
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
        collectionView.trailingAnchor.constraint(equalTo: codeView.trailingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        imageView.layer.shadowOffset = CGSize(width: 6.0, height: 6.0)
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowRadius = 2.0
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 4.0
        
        
        labelTitle.text = section?.title
        labelDescription.text = section?.description
        imageView.image = section?.image
        
        
        
        setupInformation()
        
    }
    func setupInformation(){
         let designMetaphor1 = SectionCode(description: getDesignMetaphor1(),image: #imageLiteral(resourceName: "wire"))
                       sectionsCode1.append(designMetaphor1)
        let designMetaphor2 = SectionCode(description: getDesignMetaphor2(),image: #imageLiteral(resourceName: "notch"))
           sectionsCode1.append(designMetaphor2)
        
        let uiDevelopment1 = SectionCode(description: getUIDevelopment1(),image: #imageLiteral(resourceName: "notch"))
                  sectionsCode2.append(uiDevelopment1)
        let uiDevelopment2 = SectionCode(description: getUIDevelopment2(),image: #imageLiteral(resourceName: "notch"))
        sectionsCode2.append(uiDevelopment2)
        
        let useColors1 = SectionCode(description: getUseColors1(),image: #imageLiteral(resourceName: "notch"))
                  sectionsCode3.append(useColors1)
        let useColors2 = SectionCode(description: getUseColors2(),image: #imageLiteral(resourceName: "notch"))
        sectionsCode3.append(useColors2)
        
        let useLocal1 = SectionCode(description: getUseLocalizations1(),image: #imageLiteral(resourceName: "notch"))
                  sectionsCode4.append(useLocal1)
        let useLocal2 = SectionCode(description: getUseLocalizations2(),image: #imageLiteral(resourceName: "notch"))
        sectionsCode4.append(useLocal2)
        
        let useText1 = SectionCode(description: getUseTextFields1(),image: #imageLiteral(resourceName: "notch"))
                  sectionsCode5.append(useText1)
        let useText2 = SectionCode(description: getUseTextFields2(),image: #imageLiteral(resourceName: "notch"))
        sectionsCode5.append(useText2)
      }
      
      private func getDesignMetaphor1() -> String {
          return """
          We noticed that Wire is pretty much the same in both platforms, Android and iOS. Although the apps follow some of the elements of Flat Design in iOS, the app doesn't feel made only for this platform. Is recommended to use system icons for iOS and more iOS-like features. We found that the use of icons isn’t consistent throughout the app, which can be confusing when navigating through Wire.
          """
      }
    private func getDesignMetaphor2() -> String {
        return """
        We noticed that Wire is pretty much the same in both platforms, Android and iOS. Although the apps follow some of the elements of Flat Design in iOS, the app doesn't feel made only for this platform. Is recommended to use system icons for iOS and more iOS-like features. We found that the use of icons isn’t consistent throughout the app, which can be confusing when navigating through Wire.
        """
    }
      private func getUIDevelopment1() -> String {
          return """
          As the Wire's UI was made programatically, it makes it easier to mantain through the time. Also, making the UI programatically allows Wire to have more control over the layout of different sizes of phones. That is important to have in mind to elevate the user experience. One important thing is that Wire takes into account the notch and allows landscape mode. In the image above we can see the code for the notch in one of the featurs Wire provides.
          """
      }
    private func getUIDevelopment2() -> String {
        return """
        As the Wire's UI was made programatically, it makes it easier to mantain through the time. Also, making the UI programatically allows Wire to have more control over the layout of different sizes of phones. That is important to have in mind to elevate the user experience. One important thing is that Wire takes into account the notch and allows landscape mode. In the image above we can see the code for the notch in one of the featurs Wire provides.
        """
    }
    
      private func getUseColors1() -> String {
          return """
          Wire uses has a color palette that consist of three colors, white, black and an accent color chosen by the user. Something that we noticed is when the user changes the accent color, the background color also gets to be of the color of choice. This makes the app distracting because the colors are too vibrant and, because the accent color is the same, it cannot be distinguished. We found that is not possible to get back to the original white and black colors, which should be if the user wants to. Dark mode is allowed in the app which is important right now having in mind the new iOS updates.

          """
      }
    private func getUseColors2() -> String {
             return """
             Wire uses has a color palette that consist of three colors, white, black and an accent color chosen by the user. Something that we noticed is when the user changes the accent color, the background color also gets to be of the color of choice. This makes the app distracting because the colors are too vibrant and, because the accent color is the same, it cannot be distinguished. We found that is not possible to get back to the original white and black colors, which should be if the user wants to. Dark mode is allowed in the app which is important right now having in mind the new iOS updates.

             """
         }
      private func getUseLocalizations1() -> String {
          return """
          Wire uses localizations to allow the user navigate through the app in the prefer, which is usually the phone language. The iPhone has spanish as the device language. We can see that some of the labels that are shown are in spanish and some are in english, which is confusing for the user. We changed some parts of the code to add this new text in Spanish. At some point, this changes can be done in the whole app to make the user experience better. To see the changes, press button.

          """
      }
    private func getUseLocalizations2() -> String {
        return """
        Wire uses localizations to allow the user navigate through the app in the prefer, which is usually the phone language. The iPhone has spanish as the device language. We can see that some of the labels that are shown are in spanish and some are in english, which is confusing for the user. We changed some parts of the code to add this new text in Spanish. At some point, this changes can be done in the whole app to make the user experience better. To see the changes, press button.

        """
    }
      private func getUseTextFields1() -> String {
          return """
          Wire allows the user to change personal information whenever they like. Although, this capability isn’t visible to the user. With that in mind, is important to show with an icon that these text fields can be editable.

          On the other hand, the text field that corresponds to the userName doesn’t have restrictions with the type of characters the users can put. As recommendation it’s important to restrict this input only to alphanumeric numbers, because having special characters doesn’t make much sense.

          """
      }
    private func getUseTextFields2() -> String {
        return """
        Wire allows the user to change personal information whenever they like. Although, this capability isn’t visible to the user. With that in mind, is important to show with an icon that these text fields can be editable.

        On the other hand, the text field that corresponds to the userName doesn’t have restrictions with the type of characters the users can put. As recommendation it’s important to restrict this input only to alphanumeric numbers, because having special characters doesn’t make much sense.

        """
    }
}
extension UIDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: codeView.frame.width+60, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Revisar
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as! UICustomCell
        cell.backgroundColor = UIColor(red: CGFloat(231)/255.0, green: CGFloat(231)/255.0, blue: CGFloat(231)/255.0, alpha: 1.0)
    
        cell.layer.cornerRadius = 5
        
        //Revisar
        if indexPath.row == 0 {
        cell.imageView.image = sectionsCode1[indexPath.row].image
        cell.descriptionLabel.text = sectionsCode1[indexPath.row].description
        }
        else if indexPath.row == 1 {
            cell.imageView.image = sectionsCode1[indexPath.row].image
            cell.descriptionLabel.text = sectionsCode1[indexPath.row].description
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
          img.backgroundColor = .white
          img.layer.cornerRadius = 8.0
          img.clipsToBounds = true
        return img
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let lbl = UILabel()
        
            lbl.textAlignment = .justified
           lbl.font = UIFont.systemFont(ofSize: 11)
           lbl.numberOfLines = 0
           lbl.minimumScaleFactor = 0.9
        return lbl
    }()
    
    lazy var verticalStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [self.imageView, self.descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2.0
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verticalStackView)
        
        verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
      
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

