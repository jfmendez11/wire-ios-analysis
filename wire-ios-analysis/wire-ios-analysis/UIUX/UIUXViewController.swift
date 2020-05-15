//
//  UIUXViewController.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 14/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class UIUXViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cardCellReuseIdentifier = "cardCellReuseIdentifier"
    let cellSpacingHeight: CGFloat = 10
    
    var sections = [Section]()
    
    var selectedIndexPath: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: cardCellReuseIdentifier)
        tableView.rowHeight = self.view.frame.width
        tableView.backgroundColor = .clear
        
        tableView.dataSource = self
        tableView.delegate = self
        setupInformation()
        // Do any additional setup after loading the view.
    }
    
    func setupInformation(){
        let designMetaphor = Section(title: "Design Metaphor",description: getDesignMetaphor(),image: #imageLiteral(resourceName: "icons"))
        sections.append(designMetaphor)
        let uiDevelopment = Section(title: "UI development",description: getUIDevelopment(),image: #imageLiteral(resourceName: "notch"))
        sections.append(uiDevelopment)
        let useColors = Section(title: "Use of colors",description: getUseColors(),image: #imageLiteral(resourceName: "colors"))
        sections.append(useColors)
        let useLocalizations = Section(title: "Use of localizations",description: getUseLocalizations(),image: #imageLiteral(resourceName: "localization"))
        sections.append(useLocalizations)
        let useTextFields = Section(title: "Use of text fields",description: getUseTextFields(),image: #imageLiteral(resourceName: "textField"))
        sections.append(useTextFields)
    }
    
    private func getDesignMetaphor() -> String {
        return """
        We noticed that Wire is pretty much the same in both platforms, Android and iOS. Although the apps follow some of the elements of Flat Design in iOS, the app doesn't feel made only for this platform. Is recommended to use system icons for iOS and more iOS-like features. We found that the use of icons isn’t consistent throughout the app, which can be confusing when navigating through Wire.
        """
    }
    private func getUIDevelopment() -> String {
        return """
        As the Wire's UI was made programatically, it makes it easier to mantain through the time. Also, making the UI programatically allows Wire to have more control over the layout of different sizes of phones. That is important to have in mind to elevate the user experience. One important thing is that Wire takes into account the notch and allows landscape mode. In the image above we can see the code for the notch in one of the featurs Wire provides.
        """
    }
    private func getUseColors() -> String {
        return """
        Wire uses has a color palette that consist of three colors, white, black and an accent color chosen by the user. Something that we noticed is when the user changes the accent color, the background color also gets to be of the color of choice. This makes the app distracting because the colors are too vibrant and, because the accent color is the same, it cannot be distinguished. We found that is not possible to get back to the original white and black colors, which should be if the user wants to. Dark mode is allowed in the app which is important right now having in mind the new iOS updates.

        """
    }
    private func getUseLocalizations() -> String {
        return """
        Wire uses localizations to allow the user navigate through the app in the prefer, which is usually the phone language. The iPhone has spanish as the device language. We can see that some of the labels that are shown are in spanish and some are in english, which is confusing for the user. We changed some parts of the code to add this new text in Spanish. At some point, this changes can be done in the whole app to make the user experience better. To see the changes, press button.

        """
    }
    private func getUseTextFields() -> String {
        return """
        Wire allows the user to change personal information whenever they like. Although, this capability isn’t visible to the user. With that in mind, is important to show with an icon that these text fields can be editable.

        On the other hand, the text field that corresponds to the userName doesn’t have restrictions with the type of characters the users can put. As recommendation it’s important to restrict this input only to alphanumeric numbers, because having special characters doesn’t make much sense.

        """
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UIDetailViewController{
            
            destination.section = sections[selectedIndexPath]
            
        }
        
    }
}
extension UIUXViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cardCellReuseIdentifier, for: indexPath) as! CardTableViewCell
        
        cell.layer.borderWidth = 5
        cell.layer.borderColor =  UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        cell.cardImageView.image = sections[indexPath.row].image
        cell.cardLabel.text = sections[indexPath.row].title
        
        
        
        return cell
    }
    
}

extension UIUXViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        selectedIndexPath = indexPath.row
        print("selectedIndexPath en UIUX\(selectedIndexPath)")
        performSegue(withIdentifier: "uiDetail", sender: self)
    }
}

