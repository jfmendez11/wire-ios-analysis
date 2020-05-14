//
//  DependenciesViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 13/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//
import UIKit

class DependenciesViewController: UIViewController {
    @IBOutlet weak var overviewTextLabel: UILabel!
    @IBOutlet weak var frequencyBarChart: BeautifulBarChart!
    @IBOutlet weak var dependenciesTable: UITableView!
    
    let cellReuseIdentifier = "dependencyCell"
    var selectedRepo: String?
    
    var imports = [Import]()
    
    let dependencies = ["WireSyncEngine", "WireDataModel", "WireRequestStrategy", "WireTransport", "WireMockTransport", "WireShareEngine", "WireSystem", "WireUtilities", "WireCanvas", "WireTesting", "WireCryptobox", "WireImages", "WireLinkPreview", "WireProtos", "Ziphy", "avs"]
    
    let dependencyRepoName = ["wire-ios-sync-engine", "wire-ios-data-model", "wire-ios-request-strategy", "wire-ios-transport", "wire-ios-mock-transport", "wire-ios-share-engine", "wire-ios-system", "wire-ios-utilities", "wire-ios-canvas", "wire-ios-testing", "wire-ios-cryptobox", "wire-ios-images", "wire-ios-link-preview", "wire-ios-protos", "wire-ios-ziphy", "avs-ios-binaries"]
    
    let repoDescription = ["wire-ios-sync-engine", "wire-ios-data-model", "wire-ios-request-strategy", "wire-ios-transport", "wire-ios-mock-transport", "wire-ios-share-engine", "wire-ios-system", "wire-ios-utilities", "wire-ios-canvas", "wire-ios-testing", "wire-ios-cryptobox", "wire-ios-images", "wire-ios-link-preview", "wire-ios-protos", "wire-ios-ziphy", "avs-ios-binaries"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overviewTextLabel.numberOfLines = 0
        overviewTextLabel.textAlignment = .justified
        overviewTextLabel.text = getOverviewText()
        // Do any additional setup after loading the view.
        dependenciesTable.delegate = self
        dependenciesTable.dataSource = self
        dependenciesTable.reloadData()
        
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
        According to Wire's wiki the app for iOS has some dependencies that are available from Cartage. This dependencies are from Wire and provides different services to the main app. The main dependencies are described below.
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
        return dependencyRepoName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? DependciesTableViewCell else {
             fatalError("The dequeued cell is not an instance of RouteTableViewCell.")
        }
        let name = dependencyRepoName[indexPath.row]
        cell.dependencyNameLabel.text = name
        return cell
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
