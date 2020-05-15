//
//  EventualConnectivityViewController.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 14/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class EventualConnectivityViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cardCellReuseIdentifier"
    let cellSpacingHeight: CGFloat = 10
    
    var sectionsConnectivity = [SectionConnectivity]()
    var sectionsCode = [SectionCode]()
    
    var selectedIndexPath: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
               tableView.register(UINib(nibName: "ConnectivityTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
               tableView.rowHeight = self.view.frame.width
               tableView.backgroundColor = .clear
               
               tableView.dataSource = self
               tableView.delegate = self
               setupInformationConnectivity()
        // Do any additional setup after loading the view.
    }
    func setupInformationConnectivity(){
        
        
        let stuckProgress = SectionConnectivity(title: "Stuck progress notification",description: getStuckProgress(),image: #imageLiteral(resourceName: "stuckProgress"))
        sectionsConnectivity.append(stuckProgress)
        let genericMessage = SectionConnectivity(title: "Generic Message",description: getGenericMessage(),image: #imageLiteral(resourceName: "genericMessage"))
        sectionsConnectivity.append(genericMessage)
        let inconsistentMessage = SectionConnectivity(title: "Inconsistent Message",description: getInconsistentMessage(),image: #imageLiteral(resourceName: "enviandoNoWifi"))
        sectionsConnectivity.append(inconsistentMessage)
        let blockedApp = SectionConnectivity(title: "Blocked App",description: getBlockedApp(),image: #imageLiteral(resourceName: "wire"))
        sectionsConnectivity.append(blockedApp)
    }
    
    private func getStuckProgress() -> String {
        return """
        A stuck progress notification antipattern is found when trying to create an account. As the request cannot be done, they show a spinner that never goes away. This is frustrating for the user because it doesn't send any message to understand the problem, or it lets the user leave this view. The section of code is found in class ClientRegistrationErrorEventHandler.swift as it can be seen in the picture below. The solution to this is to end the animation after certain time or, instead of showing this spinner, the app should give a message which tells the user to check internet connection.
        """
    }
    private func getGenericMessage() -> String {
        return """
        The generic message can be found when trying to add an email and a password to an existing account, when there's no internet connection. This type of messages aren't the way to go because the user might not know what's the reason for the message. This message is displayed in differente occassions but, in this case, we are focusing on the one found in class "".  It's recommended to give a more informative message. This can be done by simply changing some lines of code like the image bellow. Then, we get the result seen bellow.
        """
    }
    private func getInconsistentMessage() -> String {
        return """
        Wire has inconsistent messages after trying to send a message when no internet connection. As when can see in the picture above, after sending the message we get this notification that the message is being sent. Although, when it reaches a timeout, the app tells the user that he/she should try to resend or delete the message. The first case is the one that is confusing because, in reality, the message is not being sent. What happens is that Wire waits until the observer gets the notification of message send failure, which triggers the buttons of resend or delete. This happens in class MessageToolboxViewDelegate which observes events happening in the conversation view, more specifically in the message toolbox. It's recommended to show the resend or delete options without showing the "sending message".

        """
    }
    private func getBlockedApp() -> String {
        return """
        Wire has a problem when trying to search messages in a conversation when there's no internet connection. Whenever we are in a conversation without internet connection and the search bar is selected, the app completely shuts. It doesn't give any message but the app simply closes abruptly. This happens in class "". This is a bug that leads to problems in the user experience and should be taken into account.

        """
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ConnectivityDetailViewController{
            destination.sectionConnectivity = sectionsConnectivity[selectedIndexPath]
        }
        
    }
    
    
}

extension EventualConnectivityViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsConnectivity.count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        //headerView.backgroundColor = UIColor.lightGray
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ConnectivityTableViewCell
        
        cell.layer.borderWidth = 5
        cell.layer.borderColor =  UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        cell.cardImageView.image = sectionsConnectivity[indexPath.row].image
        cell.cardLabel.text = sectionsConnectivity[indexPath.row].title
        
        
        
        return cell
    }
   
    
}

extension EventualConnectivityViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "toDetail", sender: self)
    }
}



