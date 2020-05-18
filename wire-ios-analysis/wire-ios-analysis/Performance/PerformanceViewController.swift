//
//  PerformanceViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 15/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class PerformanceViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let cardCellReuseIdentifier = "cardCellReuseIdentifier"
        let cellSpacingHeight: CGFloat = 10
        
        var sections = [Section]()
        
        var selectedIndexPath: Int = 0;
        
        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "PerformanceTableViewCell", bundle: nil), forCellReuseIdentifier: cardCellReuseIdentifier)
            tableView.rowHeight = self.view.frame.width
            tableView.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
            
            tableView.dataSource = self
            tableView.delegate = self
            setupInformation()
            // Do any additional setup after loading the view.
        }
        
        func setupInformation(){
            let leaks = Section(title: "Leaks",description: getLeaks(),image: UIImage(named:"leak1")!)
            sections.append(leaks)
            
            let cpu = Section(title: "CPU",description: getCPU(),image: UIImage(named: "cpu1")!)
            sections.append(cpu)
            
            let memory = Section(title: "Memory",description: getMemory(),image:  UIImage(named: "memory1")!)
            sections.append(memory)
            
            let disk = Section(title: "Disk",description: getDisk(),image:  UIImage(named: "disk1")!)
            sections.append(disk)
            
            let network = Section(title: "Network",description: getNetwork(),image: UIImage(named: "network1")!)
            sections.append(network)
            
            let threads = Section(title: "Threads",description: getThreads(),image: UIImage(named: "thread1")!)
            sections.append(threads)
            
            let storage = Section(title: "Storage",description: getStorage(),image:  UIImage(named: "storage1")!)
            sections.append(storage)
            
            let insights = Section(title: "Insights",description: getInsights(),image: #imageLiteral(resourceName: "wire"))
            sections.append(insights)
        }
        
        private func getLeaks() -> String {
            return """
                For the performance case, we are focusing on the views Conversations to evaluate how Wire manages its use of CPU, memory usage and energy management. In this section, we used instruments when using the MessageToolBox ( send text, image, gif, among others). The peak of the memory usage is when the user tries to send an image. For a further analysis, we are going to focus principally in the case were a user is trying to send a picture in the conversation.
            
                At this point, no leaks appear but, before and after the raise of memory usage, the leaks are 9 and 19. This can be seen in the picture above.
            
            There's 19 leaks before trying to look for a picture to send, and 9 leaks after. What we found is that all the leaks are Malloc 384 Bytes ase we can see in the image below. The Stack Trace can be seen below too.

            """
        }
        private func getCPU() -> String {
            return """
            To analyze the CPU, Memory and Network performance we used xcode’s instruments and we ran the app in the simulator. In this first part, we are going to talk about CPU. The scenario of the user trying to send an image in a conversation is the one that we’ll be focusing on and the one that would be analyzed. The results gotten when doing the analysis for the can be seen in the picture above.

            The highest value of the CPU usage when trying to send a picture is at 227% percent. We assume it could be related with the simulator capabilities because it doesn’t get the same processor speed when compared with a physical phone. The peak is from selecting the image and trying to send it, but then it gets to 96% when the image is already sent. What made us curious is the fact that the other movement of the graph corresponds to trying to send a new picture. As we can see, Wire manages better the CPU usage as this action was already performed, and the difference between the first and second graph movement is pretty much noticeable.

            Another thing is that Wire has over 20 threads, and the one used for this task is Thread 1. Wire has the other threads not doing anything which isn’t really affecting CPU usage. Even though, as a good practice its recommended to deactivate those threads that are in background because they aren’t doing any task at this moment.

            """
        }
        private func getMemory() -> String {
            return """
                Here we are going to analyze memory usage. At first memory usage is low and stable when we are in the Conversation View. When trying to pick a picture to send it has a peak at 92MB, then it decreases when the picture is already picked and the send button has been tapped. When the picture is sending and then is sent, memory usage stays at its peak which is 108MB. That's why we get 107MB as the average memory usage. We thought that when the message had already been sent, then the memory usage would decreased but it didn’t. Only after trying to send another image, memory use got lower.

                It’s recommended to maintain the memory usage at 80% or lower, so we think that some changes are needed. Even when iPhones nowadays (since iPhone 6) has a crash at 645MB of memory usage, Wire can improve performance to generate an overall better experience


            """
        }
        private func getDisk() -> String {
            return """
                For the disk usage analysis, we found that the highest reading rate was 22,5 MB, while the highest rate in the writing rate is 25,7 MB. The highest reading rate happens when the user is picking the image to send, and when the message is sending and then is sent with 5,9 MB / s, it lowers substantially to about 2,3 MB / s. The writing rate is stable throughout the process of sending a message.
            """
        }
        private func getNetwork() -> String {
            return """
            For the Network analysis, Wire uses TCP as their transportation protocol which is more reliable in general. Wire-ios-transportation library is the one that is in charge of handles authentication of requests, network failures and retries transparently. Also, this library is in charge of the abstraction of network communication with its backend.


            """
        }
        private func getThreads() -> String {
               return """
               As seen in the CPU analysis, Wire uses different threads to run the processes for each action that is needed. We found that they rely on DispatchQueue to manage their available threads in the iOS App. In class ImageResource.swift, we found that for each message type that the user can send, like images, audio, location, etc, fetching is done. This can be seen in the snippet above. We can see that the fetch is done in the main thread. For more complex fetching, as this main thread manages the UI, it could lead to the application not responding which is something we would like to avoid. What we think that could help to do this fetching in a background threat to avoid further problems.


               """
       }
       private func getStorage() -> String {
           return """
           Wire relies on Core Data as their way to save information in the user’s iOS device. The library wire-ios-data-model is the one that has to manage Core Data storage and implements the data model and status observation. It’s important to notice that this library is the most used one, taking into account that Core Data is used throughout the application. Also, Wire uses in some cases User Defaults like the one shown in the picture below in class CallQualityController.swift. Here they use user defaults to save the last time the when a survey was shown. As it is not sensible data, it makes sense to use user defaults to track intervals of time.

           """
       }
       private func getInsights() -> String {
           return """
           With the analysis we have done in UI/UX, Eventual Connectivity, Security and Performance, some questions arose. Like, is it ok to have so many dependencies and rely heavily on them? Other question we got is, having their own icons its fine but, should the icons be drawn every time a view is launched?

           Well, for the first question we are going to focus on the most used dependency. We found that the main dependency that is used is the WireDataModel which is in charge of managing Core Data. Even when Wire relies so much in this depency, we found that, maybe half of the leaks in the scenario that was analyzed, were due to bugs in this dependency. With  that in mind, this leaks are affecting performance. On the other hand, we think that in the case of Wire, that has dependencies that are all their own, is good as it doesn’t rely on third party libraries. But one thing that should be taken into account is that, as they are Wire dependencies, maintainability is something that could be trouble.

           For the second question, drawing Wire Icons all the time and managing their style and more, could be a bad practice because of the way Wire uses threads. Wire manages the GUI in the main thread so, whenever something in the UI is done, the thread is using CPU. So if the main thread is used to do another process and also manages the GUI, performance could be influenced. Maybe if the icons are managed and drawn once it could save the problem.


           """
       }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? PerformanceSmallDetailViewController{
                
                destination.section = sections[selectedIndexPath]
                
            }
            
            if let destination = segue.destination as? PerfomanceDetailViewController {
                destination.section = sections[selectedIndexPath]
            }
            
        }
    }
    extension PerformanceViewController : UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return sections.count
        }
        
        // Set the spacing between sections
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 4
        }
        // Make the background color show through
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
            return headerView
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 260
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cardCellReuseIdentifier, for: indexPath) as! PerformanceTableViewCell
            
            cell.layer.borderWidth = 4
            cell.layer.borderColor =  #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            
            cell.cardImageView.image = sections[indexPath.row].image
            cell.cardLabel.text = sections[indexPath.row].title
            
            
            
            return cell
        }
        
    }

    extension PerformanceViewController : UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            
            
            selectedIndexPath = indexPath.row
            print("selectedIndexPath en UIUX\(selectedIndexPath)")
            
            
            if selectedIndexPath == 7 {
                    performSegue(withIdentifier: "pSmallDetail", sender: self)
            }
            else {
                    performSegue(withIdentifier: "pDetail", sender: self)
            }
        }
    }
