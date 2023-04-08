//
//  ActivitySearchViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

public let allSearchableCategories = ["Accounting",  "Airport",  "Amusement park",  "Aquarium",  "Art gallery",  "Atm",  "Bakery",  "Bank",  "Bar",  "Beauty salon",  "Bicycle store",  "Book store",  "Bowling alley",  "Bus station",  "Cafe",  "Campground",  "Car dealer",  "Car rental",  "Car repair",  "Car wash",  "Casino",  "Cemetery",  "Church",  "City hall",  "Clothing store",  "Convenience store",  "Courthouse",  "Dentist",  "Department store",  "Doctor",  "Drugstore",  "Electrician",  "Electronics store",  "Embassy",  "Fire station",  "Florist",  "Funeral home",  "Furniture store",  "Gas station",  "Gym",  "Hair care",  "Hardware store",  "Hindu temple",  "Home goods store",  "Hospital",  "Insurance agency",  "Jewelry store",  "Laundry",  "Lawyer",  "Library",  "Light rail station",  "Liquor store",  "Local government office",  "Locksmith",  "Lodging",  "Meal delivery",  "Meal takeaway",  "Mosque",  "Movie rental",  "Movie theater",  "Moving company",  "Museum",  "Night club",  "Painter",  "Park",  "Parking",  "Pet store",  "Pharmacy",  "Physiotherapist",  "Plumber",  "Police",  "Post office",  "Primary school",  "Real estate agency",  "Restaurant",  "Roofing contractor",  "Rv park",  "School",  "Secondary school",  "Shoe store",  "Shopping mall",  "Spa",  "Stadium",  "Storage",  "Store",  "Subway station",  "Supermarket",  "Synagogue",  "Taxi stand",  "Tourist attraction",  "Train station",  "Transit station",  "Travel agency",  "University",  "Veterinary care",  "Zoo"]

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
    @IBOutlet weak var hStack: UIStackView!
    @IBOutlet weak var searchButton: UIButton!
    var currentIndex:Int!
    let CatCellIdentifier = "CategoryCell"
    
    lazy var addButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1), for: .normal)
        button.layer.cornerRadius = 35 / 2
        button.isHidden = true
        button.addTarget(
              self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
      }()
    
    let options = DropDown()
    
    lazy var expandedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.isHidden = true
        options.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        options.optionArray = allSearchableCategories
        stackView.addArrangedSubview(options)
        return stackView
      }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currCatList = bigCategories
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        pageTitle.textColor = .white
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        
        // search bar
        hStack.layer.cornerRadius = 35 / 2
        expandedStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.6).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.12).isActive = true
        hStack.addArrangedSubview(expandedStackView)
        hStack.addArrangedSubview(addButton)
    }
    
    @objc func textDidChange() {
        if(options.searchText != "") {
            options.dataArray = allSearchableCategories.filter({ word -> Bool in
                word.lowercased().contains(options.searchText.lowercased())
            })
            options.reloadAll()
        } else {
            options.dataArray = allSearchableCategories
            options.reloadAll()
        }
    }
    
    @objc func addButtonPressed() {
        print("ADDED")
        if (options.text != "") {
            if(allSearchableCategories.contains(options.text!)) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let divc = storyboard.instantiateViewController(withIdentifier: "durationinput_vc") as! DurationInputViewController
                divc.activityName = options.text!
                divc.currentPlanIndex = currentIndex
                self.navigationController?.pushViewController(divc, animated: true)
            } else {
                let alert = UIAlertController(title: "The activity you entered is not available.", message: "Please enter an activity from the drop down menu.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func searchButtonPressed() {
        options.text = ""
        options.tintColor = .clear
        let show = expandedStackView.isHidden
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            UIView.animate(withDuration: 1, delay: 0, options: .allowAnimatedContent, animations: {
                
                self.expandedStackView.isHidden = !show
            }, completion: nil)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
            self.addButton.isHidden = !show
//            if(show) {
//                UIView.animate(withDuration: 0.75, delay: 0, options: .beginFromCurrentState, animations: {
//                    self.addButton.isHidden = false
//                }, completion: nil)
//            } else {
//                self.addButton.isHidden = true
//            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.options.tintColor = (show) ? .black : .clear
            if(show) {
                self.options.becomeFirstResponder()
                self.options.dataArray = allSearchableCategories
                self.options.reloadAll()
            } else {
                self.options.resignFirstResponder()
            }
        })
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
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let divc = storyboard.instantiateViewController(withIdentifier: "durationinput_vc") as! DurationInputViewController
            divc.activityName = cat
            divc.currentPlanIndex = currentIndex
            self.navigationController?.pushViewController(divc, animated: true)
            
//            categories[currentIndex-1] = cat
//            self.navigationController?.popViewController(animated: true)
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
            
            cell.leftVStack.layer.cornerRadius = 8
            cell.leftVStack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            cell.leftCategoryLabel.text = currCatList[catIndex]
            cell.leftCategoryLabel.textColor = .black
            cell.leftCategory.image = UIImage(named: currCatList[catIndex])
            cell.leftCategory.contentMode = .scaleAspectFill
            
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
            cell.rightVStack.isHidden = false
            cell.rightCategory.layer.cornerRadius = 10
            cell.rightCategory.layer.borderColor = UIColor.lightGray.cgColor
            cell.rightCategory.layer.borderWidth = 2
            
            cell.rightVStack.layer.cornerRadius = 8
            cell.rightVStack.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            cell.rightCategoryLabel.text = currCatList[catIndex+1]
            cell.rightCategoryLabel.textColor = .black
            cell.rightCategory.image = UIImage(named: currCatList[catIndex+1])
            cell.rightCategory.contentMode = .scaleAspectFill
            
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
            cell.rightVStack.isHidden = true
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
