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
    
    // Data for table
    var items = ["one", "two", "three"]
    
    var saved = false
    
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
        tableView.dragInteractionEnabled = true
        tableView.dataSource = self
        tableView.dragDelegate = self
        
        // catch if user exits app
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(savePlan)
        )
    }
    
    // create export pop over view
    @IBAction func exportButtonPressed() {
        // action items
        let shareText = "Save or share your plan."
        let sharePlan = UIActivityViewController(
            activityItems: [
                shareText
            ],
            applicationActivities: [CustomShareActivity()]
        )
        
        // ipad support
        sharePlan.popoverPresentationController?.sourceView = exportButton
        sharePlan.popoverPresentationController?.sourceRect = exportButton.bounds
        
        // present
        present(sharePlan, animated: true)
    }

    @objc func appMovedToBackground() {
        if(!self.saved) {
            let alert = UIAlertController(title: "Do you want to save this plan before you exit.", message: "It can be revisted under Saved Plans", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Save", style: .default) { (action) in
                print("save")
                self.saved = true
            }
            alert.addAction(okButton)
            let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (action) in
                print("cancel")
                self.saved = false
            }
            alert.addAction(cancelButton)

            self.present(alert, animated: true)
        }
    }
    
    @objc func savePlan() {
        if(!self.saved) {
            let alert = UIAlertController(title: "Do you want to save this plan before you exit.", message: "It can be revisted under Saved Plans", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Save", style: .default) { (action) in
                print("save")
                self.saved = true
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okButton)
            let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (action) in
                print("cancel")
                self.saved = false
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelButton)

            self.present(alert, animated: true)
        }
    }
}

// table view
extension GeneratedPlanViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count * 2;
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create alternating cells of activties and add buttons
        if(indexPath.row % 2 == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actCell", for: indexPath) as! CustomActivityTableViewCell
            cell.titleLabel.text = items[indexPath.row / 2]
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
            let alert = UIAlertController(title: "Alert", message: items[indexPath.row / 2], preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default) { (action) in
                tableView.deselectRow(at: indexPath, animated: true)
            }
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath)
        if(cell is CustomActivityTableViewCell) {
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                
                self.items.remove(at: indexPath.row / 2)
                self.tableView.reloadData()
            }
            return UISwipeActionsConfiguration(actions: [action])
        }
        return nil
    }
    
    // allows reordering of cells
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (tableView.cellForRow(at: indexPath) is CustomActivityTableViewCell)
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = items[sourceIndexPath.row / 2]
        items.remove(at: sourceIndexPath.row / 2)
        items.insert(item, at: destinationIndexPath.row / 2)
        
        self.tableView.reloadData()
    }
}

// UITableViewDragDelegate
extension GeneratedPlanViewController:UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if (tableView.cellForRow(at: indexPath) is CustomAddTableViewCell) {
            return []
        }
        return [UIDragItem(itemProvider: NSItemProvider(object: items[indexPath.row / 2] as NSItemProviderWriting))]
    }
}
