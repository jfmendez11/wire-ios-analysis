//
//  DependencyDetailViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 14/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

struct Languages: Codable {
    let languages: [String:Int]
}

class DependencyDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var latestReleaseDateLabel: UILabel!
    @IBOutlet weak var numberOfVersionsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentsContainerView: UIView!
    @IBOutlet weak var languagesBarChart: BasicBarChart!
    
    var repoName: String?
    var descriptionText: String?
    
    var releases = [Release]()
    var languages = [String:Int]()
    
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
        nameLabel.text = repoName
        descriptionLabel.text = descriptionText
        
        commentsContainerView.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: commentsContainerView.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: commentsContainerView.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: commentsContainerView.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: commentsContainerView.bottomAnchor, constant: 8).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        self.getGithubInfo()
        self.getLanguages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let langaugesEntries = generateEmptyDataEntries(count: languages.count)
        languagesBarChart.updateDataEntries(dataEntries: langaugesEntries, animated: false)
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {[unowned self] (timer) in
            let langaugesEntries = self.generateLanguageDataEntries()
            self.languagesBarChart.updateDataEntries(dataEntries: langaugesEntries, animated: true)
        }
        timer.fire()
    }
    
    private func getGithubInfo() {
        Request<[Release]>.get(self, path: "", url: "https://api.github.com/repos/wireapp/\(nameLabel.text ?? "")/releases") { (releases) in
               DispatchQueue.main.async() {
                   self.currentVersionLabel.text = releases[0].tag_name
                   let formatter = DateFormatter()
                   formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                   formatter.locale = Locale(identifier: "en")
                   let input = releases[0].published_at
                   if let date = formatter.date(from: input) {
                       let formatter2 = DateFormatter()
                       formatter2.dateFormat = "MMM dd yyyy"
                       formatter2.locale = Locale(identifier: "en")
                       self.latestReleaseDateLabel.text = formatter2.string(from: date)
                   }
                   self.numberOfVersionsLabel.text = "\(releases.count)"
                   self.releases = releases
                   self.collectionView.reloadData()
               }
           }
       }
    
    private func getLanguages() {
        Request<[String:Int]>.get(self, path: "", url: "https://api.github.com/repos/wireapp/\(nameLabel.text ?? "")/languages") { (languages) in
            DispatchQueue.main.async() {
                self.languages = languages
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
    
    func generateLanguageDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        let baseHeight = [Int](languages.values).max()
        var i = 0
        for (key,value) in languages {
            //(arc4random() % 90) + 10
            let height: Float = Float(value) / Float(baseHeight!)
            
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: key))
            i += 1
        }
        return result
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

extension DependencyDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: commentsContainerView.frame.width/1.25, height: commentsContainerView.frame.height - 8)
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

extension DependencyDetailViewController: RequestDelegate {
    func onError() {
        DispatchQueue.main.async() {
            let alert = UIAlertController(title: "Ups", message: "An error has occurred...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
