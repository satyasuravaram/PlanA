//
//  ActivitySearchViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

public let allCategories:[String:[String]] = [
    "Food": ["Fast Food", "Fine Dining", "Coffee", "Bakery", "Cafe"],
    "Nightlife": ["Bars", "Clubs", "Casino"],
    "Outdoor": ["Parks", "Lakes", "Hiking", "Biking", "Sightseeing", "Beaches", "Picnic"],
    "Shopping": ["Department Store", "Furniture", "Bookstore", "Jewelry", "Pet Store", "Shoe Store", "Shopping Mall", "Gas Station", "Convenience Store"],
    "Sports": ["Gym", "Outdoor facilities", "Running trails"],
    "Attractions": ["Amusement Park", "Art Gallery", "Museum", "Zoo", "Aquarium"],
    "Leisure": ["Bowling alley", "Mini golf", "Spa", "Library", "Movie Theater"],
    "Other": ["Study Spot", "Hospital"]
]

public let bigCategories = ["Food", "Nightlife", "Outdoor", "Shopping", "Sports", "Attractions", "Leisure", "Other"]

public var currCatList:[String] = []

class ActivitySearchViewController: UIViewController {

    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var currentIndex:Int!
    let CatCellIdentifier = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currCatList = bigCategories
        tableView.delegate = self
        tableView.dataSource = self
        pageTitle.textColor = .white
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
    }
}

extension ActivitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currCatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: CatCellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = currCatList[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let cat = currCatList[row]
        // If need to show sub categories
        if bigCategories.contains(cat) {
            currCatList = allCategories[cat]!
            tableView.reloadData()
        } else {
            categories[currentIndex-1] = cat
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
