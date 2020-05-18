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
        var sectionsCode2 = [SectionCode]()
        var sectionsCode3 = [SectionCode]()
        var sectionsCode4 = [SectionCode]()
        var sectionsCode5 = [SectionCode]()
        var sectionsCode6 = [SectionCode]()
    
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
            let leaks3 = SectionCode(description: getLeaks3(),image: UIImage(named: "leak4")!)
            sectionsCode1.append(leaks3)
            
            let cpu1 = SectionCode(description: getCPU1(),image: UIImage(named: "cpu2")!)
            sectionsCode2.append(cpu1)
            let cpu2 = SectionCode(description: getCPU2(),image: UIImage(named: "cpu3")!)
            sectionsCode2.append(cpu2)
            let cpu3 = SectionCode(description: getCPU3(),image: UIImage(named: "cpu4")!)
            sectionsCode2.append(cpu3)
            
            let memory1 = SectionCode(description: getMemory1(),image: UIImage(named: "memory2")!)
            sectionsCode3.append(memory1)
            let memory2 = SectionCode(description: getMemory2(),image: UIImage(named: "memory3")!)
            sectionsCode3.append(memory2)
            let memory3 = SectionCode(description: getMemory3(),image: UIImage(named: "memory4")!)
            sectionsCode3.append(memory3)
            
            let disk1 = SectionCode(description: getDisk1(),image: UIImage(named: "disk2")!)
            sectionsCode4.append(disk1)
            let disk2 = SectionCode(description: getDisk2(),image: UIImage(named: "disk3")!)
            sectionsCode4.append(disk2)
            
            let network1 = SectionCode(description: getNetwork1(),image: UIImage(named: "network2")!)
            sectionsCode5.append(network1)
            let network2 = SectionCode(description: getNetwork2(),image: UIImage(named: "network3")!)
            sectionsCode5.append(network2)
            
            let storage1 = SectionCode(description: getStorage1(),image: UIImage(named: "storage2")!)
            sectionsCode6.append(storage1)
            let storage2 = SectionCode(description: getStorage2(),image: UIImage(named: "storage3")!)
            sectionsCode6.append(storage2)
          }
          
          private func getLeaks1() -> String {
              return """
                Malloc leaks are very confusing because the trigger of the leak cannot be traced easily as not much information is given. So we used the stack trace to look for the problem. What we can see is that the leaks are mainly coming from clases that import the libraries: WireCryptobox and WireDataModel. This is important to take into account because the most used Wire library is the WireDataModel, as it was shown in the usage table in the depencies class.
              """
          }
        private func getLeaks2() -> String {
            return """
                 From closure #1 in closure #1 in ZMGenericMessage … trace, for example, all of the traces are from WireDataModel library but its not very clear where this is triggered from. Specially traces that are using WireDataModel should be fixed as they are being used the most and are being the ones generating the most trouble in performance overall.
            """
        }
    private func getLeaks3() -> String {
        return """
            On the other hand, we found that the highlighted trace correspond to UnsafeMutableRawBufferPointer  that was located in the extension Data from class NSData+ImageType.swift. In this case it is used as a view of the raw bytes of a portion of memory. The view of raw bytes is in UInt8 which is used as the type value of the var JPEGHeader. After comparing the arrays obtained, it’s posible to now if data corresponds to JPEG or not.
            """
    }
    private func getCPU1() -> String {
        return """
            When trying to send a new image, the results in the threads were different.  In this case, 9 threads out only by opening a conversation. We have not too much clarity in the reason why this inconsistency happens. We noticed that the deactivated threads are the ones that are related to sending a voice note, making a call or taking a video, like the thread AVAudiosesion. At the same time, some of the threads that aren’t activated  whenever a socket address is generated related to a NetworkReachability reference in class NetworkStatus, like com.apple.CFSocket.

            """
    }
    private func getCPU2() -> String {
        return """
            Wire uses GCD to manage their threads. For example, for assignRandomProfileImage function in class AuthenticationCoordinator.swift. What this function does it’s to look if the userSession exists, and if it does it sets a Dispatch Queue as a main thread to update the image to a random image. This is done asynchronously because it needs to complete the task which is finding in a webpage associate with Wire some random image. Until that happens, no image could be put.


            """
    }
    private func getCPU3() -> String {
        return """
            Another example we found is in class UIApplication+Permissions.swift when trying to give permission of microphone use. This manages asynchronicity when making requests about permissions. Is important to take into account the Wire uses principally main queues troughout the app, which means that the majority of activities are high priority and done in the main thread.
            """
    }
    private func getMemory1() -> String {
           return """
               Following the heaviest stack trace found when doing the memory analysis, we found this Memory call three. Those errors were traced to Wire Transport library specifically on classes ZMWebSocket and ZMPushChannelConnection.
               """
       }
       private func getMemory2() -> String {
           return """
               In the first case, we found that the function that might be causing this problem is sendFrame() which is in class ZMWebSocket. Maybe along this classes, a worker thread is being used but are having some problems. The classes in the libraries are written in objective C.
               """
       }
       private func getMemory3() -> String {
           return """
                The second case happens in class ZMPushChannelConnection in function sendPing. This can be causing the problem: dispatch_workloop_worker_thread. Again, classes from libraries are written in objective C.
               """
       }
    private func getDisk1() -> String {
        return """
            To have a more specific analysis in this section, we traced the events happening on the disk. We checked principally the Logical writes and reads and we got this filesystem events which can be seen above. Again, this was done when analyzed when trying to send a message.
            """
    }
    private func getDisk2() -> String {
        return """
             We traced the highlighted event from  the picture before to Wire Transport library. This event goes to the NetworkSocket.swift class and indicates that the first possible source of the problem is the function onBytesAvailable where UnsafeMutableRawBufferPointer funtion appears again. In this case it is used as a view of the raw bytes of a portion of memory. This is the principal possible reason of the dispatch_workloop_worker_thread. 
            """
    }
    private func getNetwork1() -> String {
        return """
            This snippet of code corresponds to the HTTP pipeling to start a voIP session or a background session, depending the case. This happens in the Wire Transport layer which manages the communication of Wire.
            """
    }
    private func getNetwork2() -> String {
        return """
            This is were the sessions are configured taking into account what was done in the last image. It uses NSURLSessionConfiguration to define the policies to download and upload data and this is called in the conversation process. When the configuration is setup, the download process in the conversation view can develop.
            """
    }
    
    private func getStorage1() -> String {
           return """
               In this snippet of code, we can see the extension NSManagedObjectContext of the class ZMCallState.swift on the WireData library. The NSManagedObjectContext lets Wire manage Core Data model objects and they are available across the threads of the application.
               """
       }
       private func getStorage2() -> String {
           return """
               Here Wire is creating the Core Data stack that is going to be used throughout the app. To load the model, the NSManagedObjectModel is used as the object of the data model of the app. The NSManagedObjectModel is useful as it loads the models that are in Wire, to know everything about the data models within the app.
               """
       }
    
    }
    extension PerfomanceDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: codeView.frame.width/1.25, height: codeView.frame.width/1.5)
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if labelTitle.text == "Storage"{
                return 2
            }
            else if labelTitle.text == "Disk"{
                return 2
            }
            else if labelTitle.text == "Network"{
                return 2
            }
            else {
            return 3
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "codeCell", for: indexPath) as! PerformanceCustomCell
            cell.backgroundColor = UIColor(red: CGFloat(231)/255.0, green: CGFloat(231)/255.0, blue: CGFloat(231)/255.0, alpha: 1.0)
        
            cell.layer.cornerRadius = 5
            
            if labelTitle.text == "Leaks" {
                cell.imageView.image = sectionsCode1[indexPath.row].image
                cell.descriptionLabel.text = sectionsCode1[indexPath.row].description
            }
            else if labelTitle.text == "CPU" {
                cell.imageView.image = sectionsCode2[indexPath.row].image
                cell.descriptionLabel.text = sectionsCode2[indexPath.row].description
            }
            else if labelTitle.text == "Memory" {
                cell.imageView.image = sectionsCode3[indexPath.row].image
                cell.descriptionLabel.text = sectionsCode3[indexPath.row].description
            }
            else if labelTitle.text == "Disk" {
                cell.imageView.image = sectionsCode4[indexPath.row].image
                cell.descriptionLabel.text = sectionsCode4[indexPath.row].description
            }
            else if labelTitle.text == "Network" {
                cell.imageView.image = sectionsCode5[indexPath.row].image
                cell.descriptionLabel.text = sectionsCode5[indexPath.row].description
            }
            else if labelTitle.text == "Storage" {
                cell.imageView.image = sectionsCode6[indexPath.row].image
                cell.descriptionLabel.text = sectionsCode6[indexPath.row].description
            }
             
           
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
