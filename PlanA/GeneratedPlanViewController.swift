//
//  GeneratedPlanViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

class GeneratedPlanViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var exportButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var pageTitle: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var stopsLabel: UILabel!
    @IBOutlet var vStack: UIStackView!
    @IBOutlet var planName: UITextField!
    @IBOutlet var pencilEditImage: UIImageView!
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var saved = false
    
    // selected plan from saved plans
    var selectedSavedPlan: Plan!
    var didSelectPlan: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activities = []
        
        // How many activities per category
        var catCount:[String:Int] = [:]
        for cat in categories {
            if catCount.keys.contains(cat) {
                catCount[cat]! += 1
            } else {
                catCount[cat] = 1
            }
        }
        
        // TODO: can't regenerate plan if coming from saved plans, should just display
//        if(didSelectPlan) {
//
//        } else {
//
//        }
        
        // set up activities
        for (index, element) in categories.enumerated() {
            let activity:Activity = Activity(context: self.context)
            activity.categoryName = element
            let durationArr = durations[index].split(separator: ":")
            let hours = Int(durationArr[0])! * 60 * 60
            let minutes = Int(durationArr[1])! * 60
            activity.duration = Double(hours + minutes)
            activities.append(activity)
        }
        
        // Generate plan
//        generatePlan(catCount: catCount)
        
        // Do any additional setup after loading the view.
        // set background and title color
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        pageTitle.textColor = .white
        planName.isHidden = true
        pencilEditImage.isHidden = false
        
        // edit plan name
        pageTitle.isUserInteractionEnabled = true
        let titleSelected : Selector = #selector(self.titleClicked)
        let tapGesture = UITapGestureRecognizer(target: self, action: titleSelected)
        tapGesture.numberOfTapsRequired = 1
        pageTitle.addGestureRecognizer(tapGesture)
        
        pencilEditImage.isUserInteractionEnabled = true
        let titleSelect : Selector = #selector(self.pencilClicked)
        let tapped = UITapGestureRecognizer(target: self, action: titleSelect)
        tapped.numberOfTapsRequired = 1
        pencilEditImage.addGestureRecognizer(tapped)
        
        // set up route button
        saveButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(.white, for: .normal)
        if self.traitCollection.userInterfaceStyle == .dark {
            vStack.backgroundColor = .black
        } else {
            vStack.backgroundColor = .white
        }
        let width = vStack.bounds.size.width
        saveButton.frame = CGRectMake(0, 0, width-10, 100)
        
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
        
        // catch if user enters app
        let notificationC = NotificationCenter.default
        notificationC.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToForeground() {
        vStack.backgroundColor = tableView.backgroundColor
    }
    
    func generatePlan(catCount:[String:Int]) {
        
        // populate plan object
        plan.name = "Your Plan"
        plan.numOfActivties = Int64(activities.count)
        
        // TODO: catCount.keys is randomly ordered. Fix to match ordering from Your Plan page.
        for cat in catCount.keys {
            // Call API for each category, store results
            getNearbyPlaces(query: cat, radius: plan.radius, location: locMan.location!, completion: { places in
                let count = catCount[cat]!
                
                let result = activities.filter { act in
                    act.categoryName == cat
                }
                
                // TODO: need to refine list by business hours to chekc if activity is available
                // TODO: randomly select activities instead of choosing from beginning of array
                for index in 0..<count {
                    let place = places[index]
//                    // Populate activities
//                    let activity:Activity = Activity(context: self.context)
                    // TODO: populate other activity fields here (business hours, description, etc)
//                    activity.name = place["name"] as? String
//                    activity.location = "(\(place["placeLat"]!),\(place["placeLng"]!))"
//                    activities.append(activity)
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
                    
                    result[index].name = place["name"] as? String
                    result[index].location = "(\(place["placeLat"]!),\(place["placeLng"]!))"
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        plan.listActs = activities
    }
        
    // replace title label with text field
    @objc func titleClicked() {
        print("title pressed")
        pageTitle.isHidden = true
        planName.isHidden = false
        pencilEditImage.isHidden = true
        planName.text = pageTitle.text
        planName.becomeFirstResponder()
    }
    
    @objc func pencilClicked() {
        print("pencil pressed")
        pageTitle.isHidden = true
        planName.isHidden = false
        pencilEditImage.isHidden = true
        planName.text = pageTitle.text
        planName.becomeFirstResponder()
    }
    
    // display new plan name
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(planName.text == "") {
            planName.text = "Your Plan"
        }
        planName.resignFirstResponder()
        planName.isHidden = true
        pageTitle.text = planName.text
        pageTitle.isHidden = false
        pencilEditImage.isHidden = false
        plan.name = planName.text
        return true
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
                do {
                    try self.context.save()
                }
                catch {
                    print("Issue saving core data")
                }
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
                do {
                    try self.context.save()
                }
                catch {
                    print("Issue saving core data")
                }
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
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func plusButtonPressed() {
        print("Plus button was PRESSED")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let easvc = storyboard.instantiateViewController(withIdentifier: "editaddact_vc") as! EditAddActViewController
        easvc.editActivity = false
        self.navigationController?.pushViewController(easvc, animated: true)
    }
    
    @IBAction func saveButtonPressed() {
        saved = true
        do {
            try self.context.save()
            let alert = UIAlertController(title: "Plan saved.", message: "You can now revisit this plan in Saved Plans.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
        catch {
            print("Issue saving core data")
        }
    }
}

// table view
extension GeneratedPlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count * 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create alternating cells of activties and add buttons
        if(indexPath.row % 2 == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actCell", for: indexPath) as! CustomActivityTableViewCell
            cell.titleLabel.textColor = .black
            cell.titleLabel.text = activities[indexPath.row / 2].name
            var text = "For "
            let time = Int(activities[indexPath.row / 2].duration)
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            if(hours == 1) {
                text = text + String(hours) + " hour "
            } else if(hours != 0) {
                text = text + String(hours) + " hours "
            }
            if(minutes != 0) {
                text = text + String(minutes) + " minutes"
            }
            cell.durationLabel.textColor = .black
            cell.durationLabel.text = text
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
            tableView.deselectRow(at: indexPath, animated: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let easvc = storyboard.instantiateViewController(withIdentifier: "editaddact_vc") as! EditAddActViewController
            easvc.editActivity = true
            easvc.activityName = activities[indexPath.row/2].name!
            // set address
            easvc.address = activities[indexPath.row/2].location!
            // set proper duration
            let durationArr = durations[indexPath.row/2].split(separator: ":")
            let hours = Int(durationArr[0])! * 60 * 60
            let minutes = Int(durationArr[1])! * 60
            easvc.seconds = hours + minutes
            self.navigationController?.pushViewController(easvc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath)
        if(cell is CustomActivityTableViewCell) {
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                
                activities.remove(at: indexPath.row / 2)
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
        let item = activities[sourceIndexPath.row / 2]
        activities.remove(at: sourceIndexPath.row / 2)
        activities.insert(item, at: destinationIndexPath.row / 2)
        
        self.tableView.reloadData()
    }
}

// UITableViewDragDelegate
extension GeneratedPlanViewController:UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if (tableView.cellForRow(at: indexPath) is CustomAddTableViewCell) {
            return []
        }
        return [UIDragItem(itemProvider: NSItemProvider(object: activities[indexPath.row / 2].name! as NSItemProviderWriting))]
    }
}
