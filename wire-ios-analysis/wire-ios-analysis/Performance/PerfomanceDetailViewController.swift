//
//  PerfomanceDetailViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 15/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class PerfomanceDetailViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var labelCode: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UITextView!
    

    var section:Section?
        
        var sectionsCode1 = [SectionCode]()
        
        fileprivate let collectionView: UICollectionView = {
               let layout = UICollectionViewFlowLayout()
               layout.scrollDirection = .horizontal
               let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
               cv.showsHorizontalScrollIndicator = false
               cv.translatesAutoresizingMaskIntoConstraints = false
               cv.register(PerformanceCustomCell.self, forCellWithReuseIdentifier: "codeCell")
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
            return containerView
        }
        
        func setupInformation(){
             let leaks1 = SectionCode(description: getLeaks1(),image: UIImage(named: "leak2")!)
                           sectionsCode1.append(leaks1)
            let leaks2 = SectionCode(description: getLeaks2(),image: UIImage(named: "leak3")!)
               sectionsCode1.append(leaks2)
            
          }
          
          private func getLeaks1() -> String {
              return """
                Malloc leaks are very confusing because the trigger of the leak cannot be traced easily as not much information is given. So we used the stack trace to look for the problem. What we can see is that the leaks are mainly coming from clases that import the libraries: WireCryptobox and WireDataModel. This is important to take into account because the most used Wire library is the WireDataModel, as it was shown in the usage table in the depencies class.
              """
          }
        private func getLeaks2() -> String {
            return """
                 The highlighted trace, for example, corresponds to class NetworkStatus.swift, which uses this highlighted method as a listener object for the reachability status. On the other hand, from closure #1 in closure #1 in ZMGenericMessage … trace, all of the traces are from WireDataModel library but its not very clear where this is triggered from. Specially traces that are using WireDataModel should be fixed as they are being used the most and are being the ones generating the most trouble in performance overall.
            """
        }
    }
    extension PerfomanceDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: codeView.frame.width/1.25, height: codeView.frame.width/1.5)
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if labelTitle.text == "Use of localizations" {
                return 3
            } else{
            return 2
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as! PerformanceCustomCell
            cell.backgroundColor = UIColor(red: CGFloat(231)/255.0, green: CGFloat(231)/255.0, blue: CGFloat(231)/255.0, alpha: 1.0)
        
            cell.layer.cornerRadius = 5
            
          
             cell.imageView.image = sectionsCode1[indexPath.row].image
             cell.descriptionLabel.text = sectionsCode1[indexPath.row].description
           
             return cell
        }
        
    }

    class PerformanceCustomCell: UICollectionViewCell {
        
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
            lbl.translatesAutoresizingMaskIntoConstraints = false
                lbl.textAlignment = .natural
               lbl.font = UIFont.systemFont(ofSize: 11)
               lbl.numberOfLines = 0
            lbl.minimumScaleFactor = 0.75
            lbl.adjustsFontSizeToFitWidth = true
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
