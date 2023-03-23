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
        tableView.separatorStyle = .none
        pageTitle.textColor = .white
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
    }
    
    @objc func categoryTapped(_ sender:TapGesture!) {
        let cat = currCatList[sender.index]
        print("category tapped \(cat)")
        // If need to show sub categories
        if bigCategories.contains(cat) {
            currCatList = allCategories[cat]!
            tableView.reloadData()

            // back button to big categories
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backToList)
            )
        } else {
            categories[currentIndex-1] = cat
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ActivitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currCatList.count + 1) / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: CatCellIdentifier, for: indexPath as IndexPath) as! CustomActivitySearchTableViewCell
        let catIndex = row * 2
        
        // Left category cell
        if catIndex < currCatList.count {
            cell.leftCategory.layer.cornerRadius = 10
            cell.leftCategory.layer.borderColor = UIColor.lightGray.cgColor
            cell.leftCategory.layer.borderWidth = 2
            
            cell.leftVStack.layer.cornerRadius = 10
            cell.leftVStack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            cell.leftCategoryLabel.text = currCatList[catIndex]
            let tg = TapGesture(target: self, action: #selector(categoryTapped(_:)))
            tg.index = catIndex
            tg.numberOfTapsRequired = 1
            tg.numberOfTouchesRequired = 1
            cell.leftCategory.addGestureRecognizer(tg)
            
            let tapped = TapGesture(target: self, action: #selector(categoryTapped(_:)))
            tapped.index = catIndex
            tapped.numberOfTapsRequired = 1
            tapped.numberOfTouchesRequired = 1
            cell.leftVStack.addGestureRecognizer(tapped)
        }
        
        // Right category cell
        if catIndex + 1 < currCatList.count {
            cell.rightCategory.isHidden = false
            cell.rightCategoryLabel.isHidden = false
            cell.rightCategory.layer.cornerRadius = 10
            cell.rightCategory.layer.borderColor = UIColor.lightGray.cgColor
            cell.rightCategory.layer.borderWidth = 2
            
            cell.rightVStack.layer.cornerRadius = 10
            cell.rightVStack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            cell.rightCategoryLabel.text = currCatList[catIndex+1]
            let tg = TapGesture(target: self, action: #selector(categoryTapped(_:)))
            tg.index = catIndex+1
            tg.numberOfTapsRequired = 1
            tg.numberOfTouchesRequired = 1
            cell.rightCategory.addGestureRecognizer(tg)
            
            let tapped = TapGesture(target: self, action: #selector(categoryTapped(_:)))
            tapped.index = catIndex+1
            tapped.numberOfTapsRequired = 1
            tapped.numberOfTouchesRequired = 1
            cell.rightCategory.addGestureRecognizer(tapped)
            
        } else {
            cell.rightCategory.isHidden = true
            cell.rightCategoryLabel.isHidden = true
        }

        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row = indexPath.row
//        let cat = currCatList[row]
//        // If need to show sub categories
//        if bigCategories.contains(cat) {
//            currCatList = allCategories[cat]!
//            tableView.reloadData()
//
//            // back button to big categories
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backToList)
//            )
//        } else {
//            categories[currentIndex-1] = cat
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
    
    // returns to big category list
    @objc func backToList() {
        currCatList = bigCategories
        tableView.reloadData()
        self.navigationItem.leftBarButtonItem = nil
    }
}
