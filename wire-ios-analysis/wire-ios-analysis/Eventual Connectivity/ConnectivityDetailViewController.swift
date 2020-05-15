//
//  ConnectivityDetailViewController.swift
//  wire-ios-analysis
//
//  Created by Diana Cepeda on 14/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class ConnectivityDetailViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDescription: UITextView!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var labelCode: UILabel!
    
    var sectionConnectivity:SectionConnectivity?
    
    var sectionsCode1 = [SectionCode]()
    var sectionsCode2 = [SectionCode]()
    var sectionsCode3 = [SectionCode]()
    
    
    fileprivate let collectionView: UICollectionView = {
              let layout = UICollectionViewFlowLayout()
              layout.scrollDirection = .horizontal
              let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
              cv.showsHorizontalScrollIndicator = false
              cv.translatesAutoresizingMaskIntoConstraints = false
              cv.register(ConnectivityCustomCell.self, forCellWithReuseIdentifier: "codeCell")
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
        
        
        labelTitle.text = sectionConnectivity?.title
        labelDescription.text = sectionConnectivity?.description
        imageView.image = sectionConnectivity?.image
        
        setupInformation()
    }
    
     func setupInformation(){
              let stuckProgress1 = SectionCode(description: getStuckProgress1(),image: #imageLiteral(resourceName: "clientRegistration"))
              sectionsCode1.append(stuckProgress1)
              let stuckProgress2 = SectionCode(description: getStuckProgress2(),image: #imageLiteral(resourceName: "unwindState"))
              sectionsCode1.append(stuckProgress2)
        
        let genericMessage1 = SectionCode(description: getGenericMessage1(),image: #imageLiteral(resourceName: "inviteSource"))
        sectionsCode2.append(genericMessage1)
        
        
        let inconsistentMessage1 = SectionCode(description: getInconsistentMessage1(),image: #imageLiteral(resourceName: "UpdateContent"))
                     sectionsCode3.append(inconsistentMessage1)
         let inconsistentMessage2 = SectionCode(description: getInconsistentMessage2(),image: #imageLiteral(resourceName: "opcionesResend"))
         sectionsCode3.append(inconsistentMessage2)
                    
        
    }
          
          private func getStuckProgress1() -> String {
              return """
                This picture corresponds to the handleEvent method done in class ClientRegistrationErrorEventHandler.swift. This method is the one that takes care of errors when trying to register a user by email, as the case explained and shown above. The two final lines we assume that are the ones that create the activity loading and never get finished. We have doubts with the .unwindState because it isn't explained in the code and it's functionality isn't intuitive.
              """
          }
    private func getStuckProgress2() -> String {
        return """
            This snippet of code is the unwindMethod we saw on the first picture. It shows that a popoverView would appear when unwindState method is called. So, what should be done is finishing the popoverView at some moment, maybe after a certain timeout, and allow the user to navigate again through the app. Because, right now, Wire is blocking the app in this scenario.
        """
    }
    private func getGenericMessage1() -> String {
              return """
                This snippet of code can be seen in the class InviteError.swift. As we can see, they are only evaluating certain cases and for these cases they have a message for the user. But, for the rest of errors, the error message is taken by case .default which is the generic message we got above. The solution would be to add more cases, like case .unreachable, by calling network.status.
              """
          }
    private func getInconsistentMessage1() -> String {
              return """
                When the user tries to send a message, no matter their network status, they do this portion of code. The snippet shows only some of the steps that are made to updateContent which means to change the state of certain elements in the messageToolBox. At first, a timestamp is created and only after almost 5 steps are completed, the timestamp ends and after that the messages that make more sense are shown in the messageToolBox.
              """
          }
    private func getInconsistentMessage2() -> String {
        return """
            This resend or delete buttons should be shown in the first place, without showing the "sending" message which is incorrect when there's absence of internet connection. As it was explained in the snippet picture, after a series of steps a timestamp triggers the "resend or delete options. To fix this, if the 'failed to send' is triggered, then it should show this two options. That way there wouldn't be an inconsistent message.
        """
    }
          
    }
    extension ConnectivityDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: codeView.frame.width+60, height: 370)
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if labelTitle.text == "Generic Message"
            {
                return 1
            } else if labelTitle.text == "Blocked App"{
                
                return 0
            }
            else {
            return 2
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as! ConnectivityCustomCell
            cell.backgroundColor = UIColor(red: CGFloat(231)/255.0, green: CGFloat(231)/255.0, blue: CGFloat(231)/255.0, alpha: 1.0)
        
            cell.layer.cornerRadius = 5
            
            if labelTitle.text == "Stuck progress notification"{
                
            cell.imageView.image = sectionsCode1[indexPath.row].image
            cell.descriptionLabel.text = sectionsCode1[indexPath.row].description
            }
            else if labelTitle.text == "Generic Message" {
                 
                cell.imageView.image = sectionsCode2[indexPath.row].image
                cell.descriptionLabel.text = sectionsCode2[indexPath.row].description
            }
            else if labelTitle.text == "Inconsistent Message" {
                 
               cell.imageView.image = sectionsCode3[indexPath.row].image
               cell.descriptionLabel.text = sectionsCode3[indexPath.row].description
           }
            else if labelTitle.text == "BlockedApp" {
                
            }
            return cell
        }
        
    }

    class ConnectivityCustomCell: UICollectionViewCell {
        
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

