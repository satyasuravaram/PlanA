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
    }
    
    // Creates the options and sets the title for the 'Sort by' button
    func setUpPopUpButton() {
        let optionCloser = {(action : UIAction) in print(action.title); self.popUpButton.setTitle("Sort by", for: .normal)}
        
        popUpButton.menu = UIMenu(children: [
            UIAction(title: "Name", state : .on, handler: optionCloser),
            UIAction(title: "Date created", handler: optionCloser)])
        
        popUpButton.showsMenuAsPrimaryAction = true
        popUpButton.changesSelectionAsPrimaryAction = true
        popUpButton.setTitle("Sort by", for: .normal)
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

extension SavedPlanViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // return count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // get plan from array and set labels
        cell.textLabel?.text = "name"
        cell.detailTextLabel?.text = "date"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // delete plan
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension SavedPlanViewController: UISearchBarDelegate {
     
    func searchBar(_ searchbar: UISearchBar, textDidChange searchText: String) {
        // search for plan
    }
}
