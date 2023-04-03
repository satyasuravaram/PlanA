//
//  SavedPlanViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

class SavedPlanViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var popUpButton: UIButton!
    @IBOutlet var pageTitle: UILabel!
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data for table
    var items: [Plan]?
    
    // search plans
    var searchPlans: [Plan]?
    var searching = false
    
    // sorting order: true -> sort by name, false -> sort by date created
    var sortBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // set background and title color
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        pageTitle.textColor = .white
       
        // set search bar color
        let image = UIImage()
        searchBar.backgroundImage = image
        searchBar.searchTextField.backgroundColor = .white
        
        // set up 'sort by' button
        setUpPopUpButton()
        
        // get items from core data
        fetchPlans(sortOrder: true)
    }
    
    // Creates the options and sets the title for the 'Sort by' button
    func setUpPopUpButton() {
        let optionCloser = {(action : UIAction) in print(action.title); self.popUpButton.setTitle("Sort by", for: .normal); self.sortBool = (action.title == "Name"); self.fetchPlans(sortOrder: self.sortBool)}
        
        popUpButton.menu = UIMenu(children: [
            UIAction(title: "Name", state : .on, handler: optionCloser),
            UIAction(title: "Date created", handler: optionCloser)])
        
        popUpButton.showsMenuAsPrimaryAction = true
        popUpButton.changesSelectionAsPrimaryAction = true
        popUpButton.setTitle("Sort by", for: .normal)
    }
    
    // get plans from core data
    func fetchPlans(sortOrder: Bool) {
        let sort = (sortOrder) ? NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare)) : NSSortDescriptor(key: "dateCreated", ascending: true)
        
        do {
            let request = Plan.fetchRequest()
            request.sortDescriptors = [sort]
            self.items = try context.fetch(request)
            
            // refresh table
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("Error in fetchPlans()")
        }
    }

}

// table view
extension SavedPlanViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchPlans?.count ?? 0
        } else {
            return self.items?.count ?? 0
        }
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // get plan from array and set labels
        cell.textLabel?.textColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        cell.textLabel?.font = UIFont(name: "Poppins-Regular", size: 22.0)
        cell.detailTextLabel?.font = UIFont(name: "Poppins-Italic", size: 12.0)
        if searching {
            cell.textLabel?.text = self.searchPlans![indexPath.row].name
            cell.detailTextLabel?.text = self.searchPlans![indexPath.row].dateCreated?.formatted(date: .long, time: .omitted)
        } else {
            cell.textLabel?.text = self.items![indexPath.row].name
            cell.detailTextLabel?.text = self.items![indexPath.row].dateCreated?.formatted(date: .long, time: .omitted)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // create alert
        let currentArray = (searching) ? searchPlans : items
//        let alert = UIAlertController(title: "Alert", message: currentArray![indexPath.row].name, preferredStyle: .alert)
//        let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
//            tableView.deselectRow(at: indexPath, animated: true)
//        }
//        alert.addAction(okButton)
//        self.present(alert, animated: true)
        
        // get selected plan
        let selectedPlan = currentArray![indexPath.row]
        print("startDateTime: ", selectedPlan.startDateTime!)
        // update generated plan view variables
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gpvc = storyboard.instantiateViewController(withIdentifier: "generatedplan_vc") as! GeneratedPlanViewController
        gpvc.selectedSavedPlan = selectedPlan
        gpvc.didSelectPlan = true
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(gpvc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // delete plan
            let currentArray = (self.searching) ? self.searchPlans : self.items
            let planToRemove = currentArray![indexPath.row]
            self.context.delete(planToRemove)
            do {
                try self.context.save()
            }
            catch {
                print("Issue deleting core data")
            }
            
            self.fetchPlans(sortOrder: self.sortBool)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// search bar
extension SavedPlanViewController: UISearchBarDelegate {
     
    func searchBar(_ searchbar: UISearchBar, textDidChange searchText: String) {
        // search for plan
        if(searchText == "") {
            searching = false
        } else {
            searchPlans = self.items?.filter({ (plan) -> Bool in
                plan.name!.lowercased().contains(searchText.lowercased())
            })
            searching = true
        }
        tableView.reloadData()
    }
}
