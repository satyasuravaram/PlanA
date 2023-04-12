//
//  PlanViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

// Stores category names for activities
public var categories = [""]
public var durations = [""]

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
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
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
        durations.insert("", at: index)
        self.tableView.reloadData()
        DispatchQueue.main.async {
            var rowTo = categories.count
            if (categories.count > 9) {
                rowTo -= 1
            }
            let indexPath = IndexPath(row: rowTo, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func generateButtonPressed(_ sender: Any) {
        // no activites
        generateButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        if (categories.count == 0) {
            // alert there are no activities in plan
            let alert = UIAlertController(title: "You have no activities in your plan.", message: "Add activities to generate a plan.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
        // empty activities
        for category in categories {
            if category == "" {
                let alert = UIAlertController(title: "An activity in your plan is empty.", message: "Select it to add an activity or swipe left to delete it.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }
        }
//        print("Categories: ", categories.description)
//        print("Durations: ", durations.description)
    }
    
    @objc func boxTapped(_ sender:TapGesture!) {
        print("box tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let asvc = storyboard.instantiateViewController(withIdentifier: "activitysearch_vc") as! ActivitySearchViewController
        asvc.currentIndex = sender.index
        self.navigationController?.pushViewController(asvc, animated: true)
    }
    
    @IBAction func pressedDown() {
        generateButton.backgroundColor = UIColor(red: 50/255, green: 100/255, blue: 255/255, alpha: 1)
    }
    
    @IBAction func pressCancelled() {
        generateButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
    }
}

public class TapGesture: UITapGestureRecognizer {
    var index = Int()
}

extension PlanViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(categories.count < 10) {
            return categories.count + 1 // plus button cell beneath each category cell
        } else {
            return categories.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if (row + 1 != tableView.numberOfRows(inSection: 0) || categories.count == 10) {
            let cell = tableView.dequeueReusableCell(withIdentifier: BoxCellIdentifier, for: indexPath as IndexPath) as! CustomActivityCategoryTableViewCell
            cell.cellBackground.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
            cell.cellBackground.image = nil
            cell.selectActivity.backgroundColor = .none
            cell.cellBackground.layer.borderColor = UIColor.lightGray.cgColor
            cell.cellBackground.layer.borderWidth = 2
            cell.headerBackground.backgroundColor = UIColor(red: 0.21, green: 0.65, blue: 1.00, alpha: 1.00)
            let activityNumber = row + 1
            cell.activityNumber.text = "Activity #\(activityNumber)"
            cell.activityNumber.font = UIFont(name: "Poppins-SemiBold", size: 17)
            cell.activityNumber.textColor = .white
            cell.cellBackground.layer.cornerRadius = 10
            cell.selectActivity.font = UIFont(name: "Poppins", size: 17)
            cell.selectActivity.textColor = .black
            if categories[activityNumber-1] == "" {
                cell.selectActivity.text = "Press here to select an activity"
            } else {

                if(UIImage(named: categories[activityNumber-1]) == nil) {
                    cell.cellBackground.image = UIImage(named: "Map Background")
                } else {
                    cell.cellBackground.image = UIImage(named: categories[activityNumber-1])
                }
                
                cell.cellBackground.contentMode = .scaleAspectFill
                cell.cellBackground.layer.borderColor = UIColor.lightGray.cgColor
                cell.cellBackground.layer.borderWidth = 2
                var text = ""//String(categories[activityNumber-1] + "\nDuration: ")
                let durationArr = durations[activityNumber-1].split(separator: ":")
                if(Int(durationArr[0]) == 1) {
                    text = text + durationArr[0] + " hr "
                } else if(Int(durationArr[0]) != 0) {
                    text = text + durationArr[0] + " hrs "
                }
                if(Int(durationArr[1]) != 0) {
                    text = text + durationArr[1] + " mins"
                }
                cell.activityNumber.text = "\(activityNumber). " + categories[activityNumber-1] + " - " + text
                cell.selectActivity.text = ""
            }
          
//            let path = UIBezierPath(roundedRect:cell.headerBackground.bounds,
//                                    byRoundingCorners:[.topLeft, .topRight],
//                                    cornerRadii: CGSize(width: 10, height:  10))
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = path.cgPath
//            cell.headerBackground.layer.mask = maskLayer
            
            cell.headerBackground.clipsToBounds = true
            cell.headerBackground.layer.cornerRadius = 8
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
            cell.index = row
            cell.insertBox = { index in
                self.addCategoryBox(index: index)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath)
        if(cell is CustomActivityCategoryTableViewCell) {
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                
                categories.remove(at: indexPath.row)
                durations.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            return UISwipeActionsConfiguration(actions: [action])
        }
        return nil
    }
    
    // allows reordering of cells
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (tableView.cellForRow(at: indexPath) is CustomActivityCategoryTableViewCell)
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var destinationRow = destinationIndexPath.row
        if(destinationIndexPath.row == tableView.numberOfRows(inSection: 0)-1 && tableView.cellForRow(at: destinationIndexPath) is CustomAddActivityBoxTableViewCell) {
            destinationRow -= 1
        }
        let activity = categories[sourceIndexPath.row]
        categories.remove(at: sourceIndexPath.row)
        categories.insert(activity, at: destinationRow)
        
        let actDuration = durations[sourceIndexPath.row]
        durations.remove(at: sourceIndexPath.row)
        durations.insert(actDuration, at: destinationRow)
        
        self.tableView.reloadData()
    }
}

// UITableViewDragDelegate
extension PlanViewController:UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if (tableView.cellForRow(at: indexPath) is CustomAddActivityBoxTableViewCell) {
            return []
        }
        return [UIDragItem(itemProvider: NSItemProvider(object: categories[indexPath.row] as NSItemProviderWriting))]
    }
}
