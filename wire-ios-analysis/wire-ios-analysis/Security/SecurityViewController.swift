//
//  SecurityViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 14/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

struct PermissionImage {
    let image: UIImage
}

class SecurityViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var permissionTitleLabel: UILabel!
    @IBOutlet weak var permissionView: UIView!
    
    @IBOutlet weak var statisticsBarChart: BasicBarChart!
    @IBOutlet weak var objectsBarChart: BeautifulBarChart!
    @IBOutlet weak var importsBarChart: BasicBarChart!
    
    @IBOutlet weak var folderLabel: UILabel!
    @IBOutlet weak var genericHashLabel: UILabel!
    @IBOutlet weak var chaChaLabel: UILabel!
    @IBOutlet weak var fingerprintLabel: UILabel!
    
    @IBOutlet weak var prosTable: UITableView!
    @IBOutlet weak var consTable: UITableView!
    
    let prosReuseIdentifier = "proCellSec"
    let consReuseIdentifier = "conCellSec"
    
    var scanStats: Stats?
    var objects: Objects?
    var imports = [Import]()
    
    
    let images = [PermissionImage(image: #imageLiteral(resourceName: "mic")), PermissionImage(image: #imageLiteral(resourceName: "location")), PermissionImage(image: #imageLiteral(resourceName: "photos")), PermissionImage(image: #imageLiteral(resourceName: "camera")), PermissionImage(image: #imageLiteral(resourceName: "contacts"))]
    
    let pros = ["""
    The framework is really well made.
    """,
    """
    Easy to examine.
    """,
    """
    Core business of Wire, needs to be perfect.
    """,
    """
    Performance optimizations, without sacrificing security.
    """,
    """
    Takes into account eventual connectivity.
    """]
    
    let cons = ["""
    A single bug could jeopardize the companies reputation.
    """,
    """
    Point of Failure: If the framework fails, the app cannnot operate.
    """]
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PermissionCell.self, forCellWithReuseIdentifier: "permissionCell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        permissionView.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: permissionTitleLabel.bottomAnchor, constant: 4).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: permissionView.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: permissionView.trailingAnchor, constant: 0).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        introLabel.text = getIntroText()
        introLabel.textAlignment = .justified
        introLabel.adjustsFontSizeToFitWidth = true
        introLabel.numberOfLines = 0
        
        folderLabel.text = getFolderText()
        folderLabel.adjustsFontSizeToFitWidth = true
        folderLabel.numberOfLines = 0
        
        genericHashLabel.text = getHashText()
        genericHashLabel.adjustsFontSizeToFitWidth = true
        genericHashLabel.numberOfLines = 0
        
        chaChaLabel.text = getChaChaText()
        chaChaLabel.adjustsFontSizeToFitWidth = true
        chaChaLabel.numberOfLines = 0
        
        fingerprintLabel.text = getFingerprintText()
        fingerprintLabel.adjustsFontSizeToFitWidth = true
        fingerprintLabel.numberOfLines = 0
        
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
        // Do any additional setup after loading the view.
        self.loadAnalysisData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emptyInstances()
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {[unowned self] (timer) in
            self.dataInstances()
        }
        timer.fire()
    }
    
    private func emptyInstances() {
        let statsEntries = generateEmptyDataEntries(count: 4)
        let objectEntries = generateEmptyDataEntries(count: 5)
        let importEntries = generateEmptyDataEntries(count: imports.count)
        
        statisticsBarChart.updateDataEntries(dataEntries: statsEntries, animated: false)
        objectsBarChart.updateDataEntries(dataEntries: objectEntries, animated: false)
        importsBarChart.updateDataEntries(dataEntries: importEntries, animated: false)
    }
    
    private func dataInstances() {
        let statsEntries = self.generateStatsDataEntries()
        let objectEntries = self.generateObjectDataEntries()
        let importEntries = self.generateImportsDataEntries(count: self.imports.count)

        statisticsBarChart.updateDataEntries(dataEntries: statsEntries, animated: true)
        objectsBarChart.updateDataEntries(dataEntries: objectEntries, animated: true)
        importsBarChart.updateDataEntries(dataEntries: importEntries, animated: true)
    }
    
    private func generateEmptyDataEntries(count: Int) -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<count).forEach {i in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    func generateStatsDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        var value = (scanStats?.scanStats.longestFile.value)!
        var height = Float(value) / 12450.0
        result.append(DataEntry(color: colors[0], height: height, textValue: "\(value)", title: "Longest File"))
        value = (scanStats?.scanStats.totalLinesOfCode)!
        height =  Float(value) / 12450.0
        result.append(DataEntry(color: colors[1], height: height, textValue: "\(value)", title: "Total Lines"))
        value = (scanStats?.scanStats.scannedFiles)!
        height =  Float(value) / 12450.0
        result.append(DataEntry(color: colors[2], height: height, textValue: "\(value)", title: "Files"))
        value = (scanStats?.scanStats.totalStrippedLinesOfCode)!
        height =  Float(value) / 12450.0
        result.append(DataEntry(color: colors[3], height: height, textValue: "\(value)", title: "Stripped Lines"))
        return result
    }
    
    func generateObjectDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        var value = (objects?.objects.classes)!
        var height = Float(value) / 110.0
        result.append(DataEntry(color: colors[0], height: height, textValue: "\(value)", title: "Classes"))
        value = (objects?.objects.protocols)!
        height = Float(value) / 110.0
        result.append(DataEntry(color: colors[1], height: height, textValue: "\(value)", title: "Protocols"))
        value = (objects?.objects.extensions)!
        height = Float(value) / 110.0
        result.append(DataEntry(color: colors[2], height: height, textValue: "\(value)", title: "Extensions"))
        value = (objects?.objects.structs)!
        height = Float(value) / 110.0
        result.append(DataEntry(color: colors[3], height: height, textValue: "\(value)", title: "Structs"))
        value = (objects?.objects.enums)!
        height = Float(value) / 110.0
        result.append(DataEntry(color: colors[4], height: height, textValue: "\(value)", title: "Enums"))
        return result
    }
    
    func generateImportsDataEntries(count: Int) -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<count {
            let value = imports[i].value //(arc4random() % 90) + 10
            let height: Float = Float(value) / 65.0
            
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: imports[i].name))
        }
        return result
    }
    
    private func getIntroText() -> String {
        return """
        In this section, we will discuss Wire's security for their iOS application. As mentioned in the About Wire section, one of the most important components of Wire's value proposition is their security. Therefore,  we will analyse the different permissions Wire asks their users.
        
        Additionally, Wire security is managed by the WireCryptobox framework (which is also described in the About Wire/Dependencies section). However in this section we will analyse this dependency in more detail.
        """
    }
    
    private func getFolderText() -> String {
        return """
        As mentioned in the About Wire -> Dependencies -> wire-ios-cryptobox section, this framework provides cross-compilation of cryptobox for iOS, in the form of satic libraries.
        
        This framework is in charged of all the security processes within the app. On the left image, we can observe the project overview.
        
        In particular, the framework is incharged of all the encryption and decryption functionalities, as well as hashing.
        """
    }
    
    private func getHashText() -> String {
        return """
        (Lines 37-87) This particular file handles all the basic hashing in the app. The lines on the right, show some of the functions that generate a hash given a particular input data. It is important to mention that, the input data can be of any kind
        """
    }
    
    private func getChaChaText() -> String {
        return """
        This particular files handles the generation of keys and the encryption/decryption of data with the particular key.
        
        The 2 images above show the core of the file. The first image (Lines 211 - 252), shows some of the code for the encrypt funcntion, whilst the second image (Lines 306 - 247) shows some of the code for the decrypt function.
        
        As the filename says, Wire uses the ChaCha20 cipher protocol.
        """
    }
    
    private func getFingerprintText() -> String {
        return """
        This file is the core of the whole framework. Here, the framework caches encryption sessions, and manages the lifecycle of these encrypted sessions. On the first image (Lines 112-147), show different functions used to handle the session. In particular, it is interesting to see the encryptHashing and purgeEncryptPayloadCache functions. These handle the lifecicle of the sessions, based on the capacity and usage of the Cache.
        
        Whenever there's a cahce miss, the framework purges the cache of encrypted payloads. One innteresting thing, is that the app doesn't load, decrypt, save, unloads everytime. Instead it saves pending sessions at the end, which improves performance and works with eventual connectivity.
        
        Finally, the second image (Lines 319-357), shows cache handling as mentioned before (all the pending sessions and micro-optimizations done by the app). However, onn lines 351-356, we can observe the "fingerprint" function, which creates a "finngerptint" of the device in order to verify the identity of the sender. Not only that, but the framework can also "see" the fingerprints of other devices and other users.
        """
    }
    
    private func loadAnalysisData() {
        if let path = Bundle.main.path(forResource: "cryptobox_analysis", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                if let jsonStats = try? decoder.decode(Stats.self, from: data) {
                    scanStats = jsonStats
                }
                if let jsonObjects = try? decoder.decode(Objects.self, from: data) {
                    objects = jsonObjects
                }
                if let jsonImports = try? decoder.decode(Imports.self, from: data) {
                    imports = jsonImports.imports
                }
            } catch {
                onError()
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

class PermissionCell: UICollectionViewCell {
    
    var image: PermissionImage? {
        didSet {
            guard let image = image else { return }
            permissionImage.image = image.image
        }
    }
    
    fileprivate let permissionImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(permissionImage)
        permissionImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        permissionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        permissionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        permissionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SecurityViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/1.25, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "permissionCell", for: indexPath) as! PermissionCell
        //cell.backgroundColor = UIColor(red: CGFloat(231)/255.0, green: CGFloat(231)/255.0, blue: CGFloat(231)/255.0, alpha: 1.0)
        cell.image = self.images[indexPath.row]
        return cell
    }
}

extension SecurityViewController: RequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ups", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension SecurityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedRepo = dependencyRepoName[indexPath.row]
        ///TODO: performSegue(withIdentifier: "pointToInfo", sender: self)
    }
}

extension SecurityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == prosTable {
            return pros.count
        } else {
            return cons.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == prosTable, let cell = tableView.dequeueReusableCell(withIdentifier: prosReuseIdentifier, for: indexPath) as? ProsSecTableViewCell {
            let pro = pros[indexPath.row]
            cell.proLabel.text = pro
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: consReuseIdentifier, for: indexPath) as? ConsSecTableViewCell else {
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
