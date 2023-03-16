//
//  GeneratedPlanViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

class GeneratedPlanViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var exportButton: UIButton!
    @IBOutlet var routeButton: UIButton!
    @IBOutlet var pageTitle: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var stopsLabel: UILabel!
    @IBOutlet var vStack: UIStackView!
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set background and title color
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        pageTitle.textColor = .white
       
        // set up route button
        routeButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        routeButton.layer.cornerRadius = 10
        routeButton.setTitleColor(.white, for: .normal)
        vStack.backgroundColor = .white
        let width = vStack.bounds.size.width
        routeButton.frame = CGRectMake(0, 0, width-10, 100)
        
        // set up labels
        timeLabel.textColor = .white
        stopsLabel.textColor = .white
        
        // table view
        tableView.separatorStyle = .none
    }
    
    // create export pop over view
    @IBAction func exportButtonPressed() {
        // action items
        let sharePlan = UIActivityViewController(
            activityItems: [
                "Save or share your plan."
            ],
            applicationActivities: nil
        )
        
        // ipad support
        sharePlan.popoverPresentationController?.sourceView = exportButton
        sharePlan.popoverPresentationController?.sourceRect = exportButton.bounds
        
        // present
        present(sharePlan, animated: true)
    }

}

// table view
extension GeneratedPlanViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 23;
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create alternating cells of activties and add buttons
        if(indexPath.row % 2 == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actCell", for: indexPath) as! CustomActivityTableViewCell
            cell.titleLabel.text = "Test 1"
            cell.durationLabel.text = "2 hours"
            cell.cellBackground.image = UIImage(named: "GrayBox")
            cell.cellBackground.layer.cornerRadius = 20
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! CustomAddTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // create alert
        let cell = tableView.cellForRow(at: indexPath)
        if(cell is CustomActivityTableViewCell) {
            let alert = UIAlertController(title: "Alert", message: "testing", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
                tableView.deselectRow(at: indexPath, animated: true)
            }
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
//        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
//            // delete plan
//            let currentArray = (self.searching) ? self.searchPlans : self.items
//            let planToRemove = currentArray![indexPath.row]
//            self.context.delete(planToRemove)
//            do {
//                try self.context.save()
//            }
//            catch {
//                print("Issue deleting core data")
//            }
//
//            self.fetchPlans(sortOrder: self.sortBool)
//        }
//
        return nil//UISwipeActionsConfiguration(actions: [action])
    }
    
    // TODO allow for cells to be reordered and for add cells to not be deleted and always exist between two activity cells
}
