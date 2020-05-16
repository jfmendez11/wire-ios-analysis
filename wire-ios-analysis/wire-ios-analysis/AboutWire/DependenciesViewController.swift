//
//  DependenciesViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 13/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//
import UIKit

class DependenciesViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var overviewTextLabel: UILabel!
    @IBOutlet weak var frequencyBarChart: BasicBarChart!
    @IBOutlet weak var dependenciesTable: UITableView!
    @IBOutlet weak var prosTable: UITableView!
    @IBOutlet weak var consTable: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    
    let cellReuseIdentifier = "dependencyCell"
    let prosReuseIdentifier = "proCell"
    let consReuseIdentifier = "conCell"
    
    var selectedRepo: String?
    
    var imports = [Import]()
    
    let dependencies = ["WireSyncEngine", "WireDataModel", "WireRequestStrategy", "WireTransport", "WireMockTransport", "WireShareEngine", "WireSystem", "WireUtilities", "WireCanvas", "WireTesting", "WireCryptobox", "WireImages", "WireLinkPreview", "WireProtos", "Ziphy", "avs"]
    
    let dependencyRepoName = ["wire-ios-sync-engine", "wire-ios-data-model", "wire-ios-request-strategy", "wire-ios-transport", "wire-ios-mocktransport", "wire-ios-share-engine", "wire-ios-system", "wire-ios-utilities", "wire-ios-canvas", "wire-ios-testing", "wire-ios-cryptobox", "wire-ios-images", "wire-ios-link-preview", "wire-ios-protos", "wire-ios-ziphy", "avs-ios-binaries"]
    
    let repoDescription = ["""
    The wire-ios-sync-engine framework is used as part of the Wire iOS client and is the top-most layer of the underlying sync engine. It is using a number of lower-level frameworks. It is the entrt point of the app and integrates functions with other frameworks. Responsable for integrations of other frameworks with the UI, integrations of AVS, push notifications, high-level sync logic and handles event processing.

    The Wire iOS sync engine is developed in a mix of Objective-C and Swift (and just a handful of classes in Objective-C++). It is a result of a long development process that was started in Objective-C when Swift was not yet available. In the past years, parts of it have been written or rewritten in Swift. Going forward, expect new functionalities to be developed almost exclusively in Swift.
    """,
    """
    Wire data model dependency is a CoreData-based storage library which function is to implement the application data model and status observation, and mannage local storage. This framework is part of Wire iOS SyncEngine.
    """,
    """
    This is another framework that is part of the Wire iOS stack. It is the iOS synchronization base interface for Wire, and connects the sync-engine and share-engine with the data-model.
    """,
    """
    Abstracts the network communication with Wire backend. It handles authentication of requests, network failures and retries transparently. This framework is part of Wire iOS.
    """,
    """
    Helps developers mock the requests to the Wire backend during integration tests.
    """,
    """
    The library for sending the content from iOS Share extension. This framework is part of Wire iOS.
    """,
    """
    Covers the interaction with ASL (Apple System Log), profiling and provides wrappers of some Foundation classes. This framework is part of Wire iOS.
    """,
    """
    Implements common data structures, algorithms (such as symmetric encryption) and application environment detection. This framework is part of Wire iOS.
    """,
    """
    Canvas is a component for painting and composing pictures. This framework is part of Wire iOS SyncEngine.
    """,
    """
    The wire-ios-testing framwork compiles some utilities to help with unit / integration tests. This framework is part of Wire iOS SyncEngine.
    """,
    """
    This project provides for cross-compilation of cryptobox for iOS, currently only in the form of static libraries. Cryptobox provides a high-level API with persistent storage for the proteus implementation of the axolotl protocol. This framework is part of Wire iOS.
    """,
    """
    Framework to perform rotation and scaling of images. This framework is part of Wire iOS SyncEngine.
    """,
    """
    WireLinkPreview is a Swift framework that can be used to fetch and parse Open Graph data that is present on most webpages to generate link previews. This framework is part of Wire iOS.
    """,
    """
    The wire-ios-protos framework contains precompiled protocol buffer definitions for Swift. Protobuf support for message encoding/decoding. This framework is part of Wire iOS SyncEngine.
    """,
    """
    Ziphy is a helper framework for interacting with Giphy. This framework is part of Wire iOS.
    """,
    """
    Audio-Video-Signaling library, integration of WebRTC.
    """]
    
    let pros = ["""
    High cohesion
    """,
    """
    Low level of attatchment (acoplamiento)
    """,
    """
    Easy to find points of failure
    """,
    """
    Easy to maintain
    """,
    """
    Reduced bottlenecks
    """,
    """
    Reusable code
    """,
    """
    Not dependant on third parties
    """,
    """
    Easier transition from Objective-C to Swift
    """]
    
    let cons = ["""
    High maintainance
    """,
    """
    Difficult to debug (too many dependencies)
    """,
    """
    Lost work (wire-ios-message-strategy not longer used)
    """,
    """
    Increased work (all frameworks belong to Wire)
    """,
    """
    Some are not used frequently but still require maintaince
    """]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overviewTextLabel.numberOfLines = 0
        overviewTextLabel.textAlignment = .justified
        overviewTextLabel.text = getOverviewText()
        // Do any additional setup after loading the view.
        dependenciesTable.delegate = self
        dependenciesTable.dataSource = self
        dependenciesTable.isScrollEnabled = false
        dependenciesTable.reloadData()
        
        prosTable.delegate = self
        prosTable.dataSource = self
        prosTable.isScrollEnabled = false
        prosTable.separatorColor = .white
        prosTable.reloadData()
        
        consTable.delegate = self
        consTable.dataSource = self
        consTable.isScrollEnabled = false
        consTable.separatorColor = .white
        consTable.reloadData()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        self.loadFrequencyData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let importEntries = generateEmptyDataEntries(count: imports.count)
        frequencyBarChart.updateDataEntries(dataEntries: importEntries, animated: false)
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {[unowned self] (timer) in
            let importEntries = self.generateImportsDataEntries(count: self.imports.count)
            self.frequencyBarChart.updateDataEntries(dataEntries: importEntries, animated: true)
        }
        timer.fire()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    private func generateEmptyDataEntries(count: Int) -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<count).forEach {i in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    func generateImportsDataEntries(count: Int) -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<count {
            let value = imports[i].value //(arc4random() % 90) + 10
            let height: Float = Float(value) / 550.0
            
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: imports[i].name))
        }
        return result
    }

    private func getOverviewText() -> String {
        return """
        According to Wire's wiki the app for iOS has some dependencies that are installed with Carthage. This dependencies are all developed in-house and provide different services to the main app. The main dependencies and their connections are displayed in the image below. The frequency graph describes the ammount of times each dependency is imported. Afterwards, each dependency is explained briefly and finally the pros and cons of thier usage are evaluated.
        """
    }
    
    private func loadFrequencyData() {
        if let path = Bundle.main.path(forResource: "code_analysis", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                if let jsonImports = try? decoder.decode(Imports.self, from: data) {
                    imports = jsonImports.imports
                    imports = imports.filter { imp in
                        dependencies.contains(imp.name)
                    }
                }
            } catch {
                onError()
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
            case "dependencyToDetail":
                guard let detailVC = segue.destination as? DependencyDetailViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                guard let selectedCell = sender as? DependciesTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                guard let indexPath = dependenciesTable.indexPath(for: selectedCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                detailVC.repoName = dependencyRepoName[indexPath.row]
                detailVC.descriptionText = repoDescription[indexPath.row]
            default:
            fatalError("Unexpected segue identifier; \(String(describing: segue.identifier))")
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension DependenciesViewController: RequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ups", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension DependenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedRepo = dependencyRepoName[indexPath.row]
        ///TODO: performSegue(withIdentifier: "pointToInfo", sender: self)
    }
}

extension DependenciesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dependenciesTable {
            return dependencyRepoName.count
        } else if tableView == prosTable {
            return pros.count
        } else {
            return cons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dependenciesTable, let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? DependciesTableViewCell {
            let name = dependencyRepoName[indexPath.row]
            cell.dependencyNameLabel.text = name
            return cell
        } else if tableView == prosTable, let cell = tableView.dequeueReusableCell(withIdentifier: prosReuseIdentifier, for: indexPath) as? ProsTableViewCell {
            let pro = pros[indexPath.row]
            cell.proLabel.text = pro
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: consReuseIdentifier, for: indexPath) as? ConsTableViewCell else {
                fatalError("Algo malo pasó")
            }
            let con = cons[indexPath.row]
            cell.conLabel.text = con
            return cell
        }
    }
    
    /*func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            pointsOfInterest.remove(at: indexPath.row)
            routeTableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41
    }
}
