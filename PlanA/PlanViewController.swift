//
//  PlanViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

// Stores category names for activities
public var categories = [""]

// Stores activities for generated plan
public var activities:[Activity] = []

class PlanViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let BoxCellIdentifier = "BoxCell"
    let PurplePlusCellIdentifier = "PurplePlusCell"
    let ActivitySearchSegueIdentifier = "ActivitySearchSegueIdentifier"
    
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categories = [""]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.layer.zPosition = 5
        view.layer.zPosition = 1
        generateButton.layer.zPosition = 10
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        pageTitle.textColor = .white
        generateButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        generateButton.layer.cornerRadius = 0.5 * generateButton.bounds.size.width
        generateButton.setTitleColor(.white, for: .normal)
        
        tableView.contentInset.bottom = 100
        self.view.insertSubview(tableView, belowSubview: generateButton)
        generateButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func addCategoryBox(index:Int) {
        categories.insert("", at: index)
        self.tableView.reloadData()
    }
    
    @IBAction func generateButtonPressed(_ sender: Any) {
        for category in categories {
            if category == "" {
                // TODO: alert user to select activity category
                return
            }
        }
    }
    
    @objc func boxTapped(_ sender:TapGesture!) {
        print("box tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let asvc = storyboard.instantiateViewController(withIdentifier: "activitysearch_vc") as! ActivitySearchViewController
        asvc.currentIndex = sender.index
        self.navigationController?.pushViewController(asvc, animated: true)
    }
}

public class TapGesture: UITapGestureRecognizer {
    var index = Int()
}

extension PlanViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count * 2 // plus button cell beneath each category cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: BoxCellIdentifier, for: indexPath as IndexPath) as! CustomActivityCategoryTableViewCell
            cell.cellBackground.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
            cell.headerBackground.backgroundColor = UIColor(red: 0.21, green: 0.65, blue: 1.00, alpha: 1.00)
            let activityNumber = row/2 + 1
            cell.activityNumber.text = "Activity #\(activityNumber)"
            cell.activityNumber.font = UIFont(name: "Poppins-SemiBold", size: 17)
            cell.activityNumber.textColor = .white
            cell.cellBackground.layer.cornerRadius = 10
            cell.selectActivity.font = UIFont(name: "Poppins", size: 17)
            cell.selectActivity.text = categories[activityNumber-1]
            if categories[activityNumber-1] == "" {
                cell.selectActivity.text = "Press here to select an activity"
            }
          
//            let path = UIBezierPath(roundedRect:cell.headerBackground.bounds,
//                                    byRoundingCorners:[.topLeft, .topRight],
//                                    cornerRadii: CGSize(width: 10, height:  10))
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = path.cgPath
//            cell.headerBackground.layer.mask = maskLayer
            
            cell.headerBackground.clipsToBounds = true
            cell.headerBackground.layer.cornerRadius = 10
            cell.headerBackground.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            cell.selectionStyle = .none
            let tg = TapGesture(target: self, action: #selector(boxTapped(_:)))
            tg.index = activityNumber
            tg.numberOfTapsRequired = 1
            tg.numberOfTouchesRequired = 1
            cell.cellBackground.tag = indexPath.row
            cell.cellBackground.addGestureRecognizer(tg)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PurplePlusCellIdentifier, for: indexPath as IndexPath) as! CustomAddActivityBoxTableViewCell
            cell.selectionStyle = .none
            cell.index = row/2+1
            cell.insertBox = { index in
                self.addCategoryBox(index: index)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
