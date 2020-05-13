//
//  AboutWireViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 11/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class AboutWireViewController: UIViewController {
    
    var models = [RatingAndReviewModel]()
    @IBOutlet weak var ratingAndReviewView: UIView!
    @IBOutlet weak var totalRatingLabel: UILabel!
    @IBOutlet weak var totalRatingCountLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var featuresTextLabel: UILabel!
    
    @IBOutlet weak var appImage: UIImageView!
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "reviewsCell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingAndReviewView.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: totalRatingCountLabel.bottomAnchor, constant: 4).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: ratingAndReviewView.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: ratingAndReviewView.trailingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        descriptionTextLabel.text = getDescriptionText()
        descriptionTextLabel.textAlignment = .justified
        descriptionTextLabel.numberOfLines = 0
        
        featuresTextLabel.text = getFeaturesText()
        featuresTextLabel.textAlignment = .justified
        featuresTextLabel.numberOfLines = 0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        appImage.addGestureRecognizer(tapGestureRecognizer)
        appImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        self.getRatingsAndReviews()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let url = URL(string: "https://apps.apple.com/app/id930944768"), UIApplication.shared.canOpenURL(url) { //"https://apps.apple.com/app/id930944768" https://itunes.apple.com/app/id930944768
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func getRating() -> Double {
        var rating = 0.0
        for model in models {
            rating += Double(model.rating.label)!
        }
        return rating/Double(exactly: models.count)!
    }
    
    private func getDescriptionText() -> String {
        return """
        Wire is an encrypted communication and collaboration app created by Wire Swiss. Wire offers a collaboration suite featuring messenger, voice calls, video calls, conference calls, file-sharing, and external collaboration –all protected by a secure end-to-end-encryption. Wire offers three solutions built on its security technology: Wire Pro –which offers Wire's collaboration feature for businesses, Wire Enterprise –includes Wire Pro capabilities with added features for large-scale or regulated organizations, and Wire Red –the on-demand crisis collaboration suite. They also offer Wire Personal, which is a secure messaging app for personal use. For the last one they offer mobile solutions for iOS and Android devices. This is the official website.
        
        This analysis is going to be over the iOS and Android apps. Acording to the App store's description the version of the app is 3.45 and has a rating of 3.7 out of 5 based on 268 ratings. Also, requires iOS 10.0 or later and it's compatible with iPhone, iPad, and iPod touch. Also, acording to the Play store's description the version of the app is 3.41.848, has a rating of 3.7 of 5 based on 31.050 ratings and has more than a million of dowloads. Also, requires Android 5.0 or later In this analysis we are using the open source code available here. This version has nearly 85% of the code made in Swift.
        """
    }
    
    private func getFeaturesText() -> String {
        return """
        Wire has a base functionalities like other messaging apps:

        •  Create a chat with a contact.
        •  Send text messages, voice messages, images, videos, GIFs, location and other attachments like files.
        •  Audio and video calls.
        •  Create group chats.
        •  Mute chats.
        •  Tag someone else with “@”.
        •  Tells the user if the message was sent, received and read.
        •  Delete messages.
        
        Besides these functionalities Wire has other functionalities that make it different from the other:

        •  Guest rooms: Wire’s secure guest rooms feature extends end-to-end encryption to conversations with external parties without requiring them to register, or even download anything.
        •  Like messages.
        •  Send draws made in the app.
        •  Define a time for the message to disappear.
        •  Send “Pings”.
        •  Add sound filters and voice changers to voice messages.
        •  Unique “Fingerprints” in the devices to ensure the sender of the message.
        •  Change the style of the text to Bold and Italic
        •  Create list of bullets
        
        Premium Wire Solutions
        
        Wire states that “Wire is the most secure and user-friendly collaboration solution that helps avoid shadow-IT and minimize the risk of cyber attacks”. This is aimed to be the main feature of the app and core business. The product is made, primarily, for organizations and its main purpose is to "increase the productivity in your team while keeping your information private." With this in mind, it can be affirmed that the segment target of Wire is the organizations that have a lot of teams and want to communicate in an easy and safe way. Communicate just doesn’t include messages, it also includes files, conference calls or private conversations. For this reason “Wire connects colleagues, partners, consultants and customers in one intuitive and secure platform.” In summary, the problem that they want to solve is the lack of security and easy ways to communicate between members of organizations. For this, they created a multiplatform (Mobile, browser, and desktop) solution where organizations can communicate easily and safely. The main characteristics of Wire are:

        •  End-to-end encrypted.
        •  Independently audited.
        •  Multi-device messaging.
        •  Trusted conversations.
        •  Forward and backward secrecy.
        
        In Wire’s page, they include some “Personas”, but they are differentiated from their role in the organization. This may be because with this information they want to show how Wire is useful in all roles in an organization and why it is a complete solution. Also, for this reason, they don’t include the “casual” or “normal” user that is not involved in an organization.

        However, they have 3 different “packages” besides the normal one. The first one is called “Wire Pro” and according to Wire’s page this combines “secure group messaging, voice and video calls, and file sharing, Wire Pro is built for organizations that need to protect their documents, and secure their communications across teams, and with clients and partners.” For this package, they offer these extra functionalities:

        •  End-to-end encrypted chats, calls and files.
        •  Secure guest rooms for external parties.
        •  Video and audio conference calls with just a click.
        •  Full administrative controls.
        •  GDPR-compliant and ISO, CCPA, SOX-ready.
        
        The second one is called “Wire Enterprise” and it’s pretty similar to the first one. The main difference is the integrations with differents apps (e.g. calendars, CRM) and premium support. For this package, they offer these extra functionalities:

        •  Productive and seamless internal collaboration.
        •  Protect your data with unrivalled security.
        •  Steer clear of costly cyber-attacks.
        •  Secure guest rooms for external parties.
        •  GDPR-compliant and ISO, CCPA, SOX-ready.
        
        The last one is called “Wire Red” and its main function is to provide a “Secure way to communicate in a crisis”. They affirm that “Wire Red is a pre-provisioned secure communication solution to ensure business readiness and recovery.”

        In all the different premium packages Wire provides a free trial. Also, Wire provides a communication whit them to know in a better way how Wire works and all the processes to acquire the product.
        """
    }
    
    private func getRatingsAndReviews() {
        Request<[RatingAndReviewModel]>.get(self, path: "feed.entry", url: "https://itunes.apple.com/us/rss/customerreviews/id=930944768/sortBy=mostRecent/json") { (posts) in
            self.models = posts
            DispatchQueue.main.async() {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let formattedNumber = numberFormatter.string(from: NSNumber(value:self.getRating()))
                self.totalRatingLabel.text = formattedNumber
                self.totalRatingCountLabel.text = "\(self.models.count) most recent ratings"
                self.collectionView.reloadData()
            }
        }
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

extension AboutWireViewController: RequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ups", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension AboutWireViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ratingAndReviewView.frame.width/1.25, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewsCell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor(red: CGFloat(231)/255.0, green: CGFloat(231)/255.0, blue: CGFloat(231)/255.0, alpha: 1.0)
        cell.review = self.models[indexPath.row]
        cell.layer.cornerRadius = 5
        return cell
    }
}

class CustomCell: UICollectionViewCell {
    
    var review: RatingAndReviewModel? {
        didSet {
            guard let review = review else { return }
            titleLabel.text = review.title.label
            authorLabel.text = review.author.name.label
            ratingLabel.text = "Rating: \(review.rating.label)/5"
            contentLabel.text = review.content.label
        }
    }
    
    fileprivate let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.contentMode = .scaleToFill
        lbl.adjustsFontSizeToFitWidth = true
        lbl.clipsToBounds = true
        return lbl
    }()
    
    fileprivate let authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .light)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.contentMode = .scaleToFill
        lbl.clipsToBounds = true
        return lbl
    }()
    
    fileprivate let ratingLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .light)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.contentMode = .scaleToFill
        lbl.clipsToBounds = true
        return lbl
    }()
    
    fileprivate let contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.textColor = .black
        lbl.textAlignment = .justified
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.contentMode = .scaleToFill
        lbl.clipsToBounds = true
        //lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.numberOfLines = 0 // or 1
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        contentView.addSubview(authorLabel)
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        contentView.addSubview(ratingLabel)
        ratingLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 0).isActive = true
        ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4).isActive = true
        ratingLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        contentView.addSubview(contentLabel)
        contentLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 0).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
