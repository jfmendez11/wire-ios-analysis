//
//  AboutWireViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 11/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class AboutWireViewController: UIViewController, UIScrollViewDelegate {
    
    var models = [RatingAndReviewModel]()
    @IBOutlet weak var ratingAndReviewView: UIView!
    @IBOutlet weak var totalRatingLabel: UILabel!
    @IBOutlet weak var totalRatingCountLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var featuresTextLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    
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
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        self.getRatingsAndReviews()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
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
        Wire is communication and collaboration app developed by Wire Swiss. It offers a high variety of services within a collabration suite featuring messaging, voice calls, video calls, conference calls. file-sharing and external collaborations. All protected by a secure end-to-end-encryption developed by themeselves (Cryptobox). The app offers 4 solutions all built on its secure technology:
        
        1. Wire Pro: Offers Wire's collaboration feature for businesses.
        2. Wire Enterprise: Wire Pro with added features for large-scale and regulated organizations.
        3. Wire Red: On-demand crisis collaboration suite
        4. Wire Personal: secure messaginng app for personal use (available as mobile solution for iOS and Android devices)
        
        This analysis refers to the iOS app. According to the App Store's desctiption, the latest version of the app is 3.58 (93 total versions) with a total rating of 3.6 out of 5 based on 314 ratings. The above rating, refers to the last 50 reviews. It is available for devices running on iOS 10.0 or later and is compatible with iPhone, iPad and iPod Touch. It supports over 20 languages and has a size of 118.7 MB.
        """
    }
    
    private func getFeaturesText() -> String {
        return """
        Wire provides the basic messanging features:
        
        •  Create a chat with another user.
        •  Send text messages, voice messages, images, videos, GIFs, location and other attachments.
        •  Audio and video calls.
        •  Create groups.
        •  Mute chats.
        •  Tag someone else with “@”.
        •  Notifies the user if the message was sent, received or read.
        •  Delete messages.
        
        Besides, Wire has other features that differentiates them from others:

        •  Guest rooms: Wire’s secure guest rooms feature extends end-to-end encryption to conversations with external parties without requiring them to register, or even download the app.
        •  Like messages.
        •  Send drawing made inside the app.
        •  Define a time for a message to disappear.
        •  Send “Pings”.
        •  Add sound filters and distort to voice messages.
        •  Unique “Fingerprints” in the devices to ensure identity of the message sender.
        •  Change the style of the text to Bold and Italic
        •  Create lists of bullets
        
        Premium Wire Solutions
        
        “Wire is the most secure and user-friendly collaboration solution that helps avoid shadow-IT and minimize the risk of cyber attacks”. This is aimed to be the value proposition of the app. The product is made, primarily, for organizations and its main purpose is to "increase the productivity in your team while keeping your information private." With this in mind, it can be affirmed that the segment target of Wire are the organizations that have a lot of teams and want to communicate efficiently and safely. Organization communication includes files, conference calls and private conversations. For this reason “Wire connects colleagues, partners, consultants and customers in one intuitive and secure platform.” In summary, the problem that they want to solve is the lack of security and easy ways to communicate between the differennt stake-holders of an organization. They created a multiplatform (mobile, web and desktop) solution where organizations can communicate easily and safely. The main characteristics of Wire are:

        •  End-to-end encryption.
        •  Independently audited.
        •  Multi-device messaging.
        •  Trusted conversations.
        •  Forward and backward secrecy.

        Wire Pro extra features:

        •  End-to-end encrypted chats, calls and files.
        •  Secure guest rooms for external parties.
        •  Video and audio conference calls with just a click.
        •  Full administrative controls.
        •  GDPR-compliant and ISO, CCPA, SOX-ready.
        
        Wire Enterprise extra features:

        •  Productive and seamless internal collaboration.
        •  Protect your data with unrivalled security.
        •  Steer clear of costly cyber-attacks.
        •  Secure guest rooms for external parties.
        •  GDPR-compliant and ISO, CCPA, SOX-ready.
        
        Wire Red extra features: provide a “Secure way to communicate in a crisis”. Wire Red is a pre-provisioned secure communication solution to ensure business readiness and recovery.
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
