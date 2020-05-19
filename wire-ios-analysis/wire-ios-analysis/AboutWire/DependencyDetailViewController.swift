//
//  DependencyDetailViewController.swift
//  wire-ios-analysis
//
//  Created by Juan Felipe Méndez on 14/05/20.
//  Copyright © 2020 Juan Felipe Méndez. All rights reserved.
//

import UIKit

class DependencyDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentVersionLabel: UILabel!
    @IBOutlet weak var latestReleaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentsContainerView: UIView!
    @IBOutlet weak var languagesBarChart: BeautifulBarChart!
    
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
        
        nameLabel.adjustsFontSizeToFitWidth = true
        
        descriptionLabel.numberOfLines = 0
        //descriptionLabel.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1)
        descriptionLabel.layer.cornerRadius = 10
        descriptionLabel.adjustsFontSizeToFitWidth = true
        // Do any additional setup after loading the view.
        self.getGithubInfo()
        self.getLanguages()
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
                   self.releases = releases
                   self.collectionView.reloadData()
               }
           }
       }
    
    private func getLanguages() {
        Request<[String:Int]>.get(self, path: "", url: "https://api.github.com/repos/wireapp/\(nameLabel.text ?? "")/languages") { (languages) in
            self.languages = languages
            DispatchQueue.main.async() {
                let langaugesEntries = self.generateEmptyDataEntries(count: languages.count)
                self.languagesBarChart.updateDataEntries(dataEntries: langaugesEntries, animated: false)
                let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {[unowned self] (timer) in
                    let langaugesEntries = self.generateLanguageDataEntries()
                    self.languagesBarChart.updateDataEntries(dataEntries: langaugesEntries, animated: true)
                }
                timer.fire()
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
        var colors = [String:UIColor]()
        colors["Swift"] = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.2705882353, alpha: 1)
        colors["Objective-C"] = #colorLiteral(red: 0.262745098, green: 0.5568627451, blue: 1, alpha: 1)
        colors["C"] = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        colors["Shell"] = #colorLiteral(red: 0.537254902, green: 0.8784313725, blue: 0.3176470588, alpha: 1)
        colors["Makefile"] = #colorLiteral(red: 0.2588235294, green: 0.4705882353, blue: 0.09803921569, alpha: 1)
        colors["C++"] = #colorLiteral(red: 0.9529411765, green: 0.2941176471, blue: 0.4901960784, alpha: 1)
        var result: [DataEntry] = []
        let denominator = languages.values.reduce(0, +)
        for (key,value) in languages {
            let valuePercentage = (Float(value) / Float(denominator))*100
            let height = valuePercentage/100
            result.append(DataEntry(color: colors[key]!, height: height, textValue: "\(String(format: "%.2f", valuePercentage))%", title: key))
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
