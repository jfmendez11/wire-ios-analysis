//
//  CodeAnalysisTableViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 12/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

struct Release: Codable {
    let tag_name: String
    let published_at: String
    let name: String
    let body: String
    let author: Author
}

struct Author: Codable {
    let login: String
}

struct Inheritances: Codable {
    var inheritances: [Inheritance]
}

struct Inheritance: Codable {
    var name: String
    var value: Int
}

struct Stats: Codable {
    var scanStats: Stat
}

struct Stat: Codable {
    var totalLinesOfCode: Int
    var scannedFiles: Int
    var totalStrippedLinesOfCode: Int
    var longestFile: LongestFile
}

struct LongestFile: Codable {
    var name: String
    var value: Int
}

struct Objects: Codable {
    var objects: Object
}

struct Object: Codable {
    var classes: Int
    var protocols: Int
    var extensions: Int
    var structs: Int
    var enums: Int
}

struct Imports: Codable {
    var imports: [Import]
}

struct Import: Codable {
    var name: String
    var value: Int
}

class CodeAnalysisTableViewController: UITableViewController {
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var lastReleaseDateLabel: UILabel!
    @IBOutlet weak var numberOfVersionsLabel: UILabel!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var commentsHeaderLabel: UILabel!
    
    var releases = [Release]()
    
    @IBOutlet weak var inheritancesBarChart: BeautifulBarChart!
    @IBOutlet weak var statsBarChart: BasicBarChart!
    @IBOutlet weak var objectsBarChart: BeautifulBarChart!
    @IBOutlet weak var importsBarChart: BasicBarChart!
    
    var inheritances = [Inheritance]()
    var scanStats: Stats?
    var objects: Objects?
    var imports = [Import]()
    
    fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCommentCell.self, forCellWithReuseIdentifier: "commentsCell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsView.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: commentsHeaderLabel.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: commentsView.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: commentsView.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: commentsView.bottomAnchor, constant: 8).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.getGithubInfo()
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
        let inheritanceEntries = generateEmptyDataEntries(count: inheritances.count)
        let statsEntries = generateEmptyDataEntries(count: 4)
        let objectEntries = generateEmptyDataEntries(count: 5)
        let importEntries = generateEmptyDataEntries(count: imports.count)
        
        inheritancesBarChart.updateDataEntries(dataEntries: inheritanceEntries, animated: false)
        statsBarChart.updateDataEntries(dataEntries: statsEntries, animated: false)
        objectsBarChart.updateDataEntries(dataEntries: objectEntries, animated: false)
        importsBarChart.updateDataEntries(dataEntries: importEntries, animated: false)
    }
    
    private func dataInstances() {
        let inheritanceEntries = self.generateInheritanceDataEntries(count: self.inheritances.count)
        let statsEntries = self.generateStatsDataEntries()
        let objectEntries = self.generateObjectDataEntries()
        let importEntries = self.generateImportsDataEntries(count: self.imports.count)
        
        inheritancesBarChart.updateDataEntries(dataEntries: inheritanceEntries, animated: true)
        statsBarChart.updateDataEntries(dataEntries: statsEntries, animated: true)
        objectsBarChart.updateDataEntries(dataEntries: objectEntries, animated: true)
        importsBarChart.updateDataEntries(dataEntries: importEntries, animated: true)
    }
    
    private func getGithubInfo() {
        Request<[Release]>.get(self, path: "", url: "https://api.github.com/repos/wireapp/wire-ios/releases") { (releases) in
            DispatchQueue.main.async() {
                self.versionLabel.text = releases[0].tag_name
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                formatter.locale = Locale(identifier: "en")
                let input = releases[0].published_at
                if let date = formatter.date(from: input) {
                    let formatter2 = DateFormatter()
                    formatter2.dateFormat = "MMM dd yyyy"
                    formatter2.locale = Locale(identifier: "en")
                    self.lastReleaseDateLabel.text = formatter2.string(from: date)
                }
                self.numberOfVersionsLabel.text = "\(releases.count)"
                self.releases = releases
                self.collectionView.reloadData()
            }
        }
    }
    
    private func generateEmptyDataEntries(count: Int) -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<count).forEach {i in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    func generateInheritanceDataEntries(count: Int) -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<count {
            let value = inheritances[i].value //(arc4random() % 90) + 10
            let height: Float = Float(value) / 200.0
            
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: inheritances[i].name))
        }
        return result
    }
    
    func generateStatsDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        var value = (scanStats?.scanStats.longestFile.value)!
        var height = Float(value) / 785010.0
        result.append(DataEntry(color: colors[0], height: height, textValue: "\(value)", title: "Longest File"))
        value = (scanStats?.scanStats.totalLinesOfCode)!
        height =  Float(value) / 785010.0
        result.append(DataEntry(color: colors[1], height: height, textValue: "\(value)", title: "Total Lines"))
        value = (scanStats?.scanStats.scannedFiles)!
        height =  Float(value) / 785010.0
        result.append(DataEntry(color: colors[2], height: height, textValue: "\(value)", title: "Files"))
        value = (scanStats?.scanStats.totalStrippedLinesOfCode)!
        height =  Float(value) / 785010.0
        result.append(DataEntry(color: colors[3], height: height, textValue: "\(value)", title: "Stripped Lines"))
        return result
    }
    
    func generateObjectDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        var value = (objects?.objects.classes)!
        var height = Float(value) / 10600.0
        result.append(DataEntry(color: colors[0], height: height, textValue: "\(value)", title: "Classes"))
        value = (objects?.objects.protocols)!
        height = Float(value) / 10600.0
        result.append(DataEntry(color: colors[1], height: height, textValue: "\(value)", title: "Protocols"))
        value = (objects?.objects.extensions)!
        height = Float(value) / 10600.0
        result.append(DataEntry(color: colors[2], height: height, textValue: "\(value)", title: "Extensions"))
        value = (objects?.objects.structs)!
        height = Float(value) / 10600.0
        result.append(DataEntry(color: colors[3], height: height, textValue: "\(value)", title: "Structs"))
        value = (objects?.objects.enums)!
        height = Float(value) / 10600.0
        result.append(DataEntry(color: colors[4], height: height, textValue: "\(value)", title: "Enums"))
        return result
    }
    
    func generateImportsDataEntries(count: Int) -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<count {
            let value = imports[i].value //(arc4random() % 90) + 10
            let height: Float = Float(value) / 1900.0
            
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: imports[i].name))
        }
        return result
    }
    
    private func loadAnalysisData() {
        if let path = Bundle.main.path(forResource: "code_analysis", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                if let jsonInheritances = try? decoder.decode(Inheritances.self, from: data) {
                    inheritances = jsonInheritances.inheritances
                }
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

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CodeAnalysisTableViewController: RequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ups", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension CodeAnalysisTableViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: commentsView.frame.width/1.25, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return releases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentsCell", for: indexPath) as! CustomCommentCell
        cell.backgroundColor = UIColor(red: CGFloat(231)/255.0, green: CGFloat(231)/255.0, blue: CGFloat(231)/255.0, alpha: 1.0)
        cell.release = self.releases[indexPath.row]
        cell.layer.cornerRadius = 5
        return cell
    }
}

class CustomCommentCell: UICollectionViewCell {
    
    var release: Release? {
        didSet {
            guard let release = release else { return }
            titleLabel.text = release.name
            authorLabel.text = release.author.login
            versionLabel.text = "Version: \(release.tag_name)"
            dateLabel.text = formatDate(release: release)
            contentLabel.text = release.body
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
    
    fileprivate let versionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .light)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.contentMode = .scaleToFill
        lbl.clipsToBounds = true
        return lbl
    }()
    
    fileprivate let dateLabel: UILabel = {
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
        
        contentView.addSubview(versionLabel)
        versionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 0).isActive = true
        versionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        versionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        contentView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        contentView.addSubview(contentLabel)
        contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 0).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 4).isActive = true
        contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func formatDate(release: Release) -> String {
        var result = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en")
        let input = release.published_at
        if let date = formatter.date(from: input) {
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "MMM dd yyyy"
            formatter2.locale = Locale(identifier: "en")
            result = formatter2.string(from: date)
        }
        return result
    }
}
