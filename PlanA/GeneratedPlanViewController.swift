//
//  GeneratedPlanViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 2/24/23.
//

import UIKit

public var planDidChange = false

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
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var refreshButton: UIButton!
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var saved = false
    
    // selected plan from saved plans
    var selectedSavedPlan: Plan!
    var didSelectPlan: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activities = []
        
        // TODO: can't regenerate plan if coming from saved plans, should just display
        if(didSelectPlan) {
            // view a saved plan
            print("SAVED PLAN IN MOTION")
            activities = selectedSavedPlan.listActivities?.array as! [Activity]
            print(activities.description)
            pageTitle.text = selectedSavedPlan.name
            saveButton.isEnabled = false
            saveButton.backgroundColor = .lightGray
            pageTitle.isUserInteractionEnabled = false
            pencilEditImage.isUserInteractionEnabled = false
            pencilEditImage.isHidden = true
            refreshButton.isEnabled = false
            tableView.dragInteractionEnabled = false
            saved = true
            tableView.reloadData()
        } else {
            // How many activities per category
            var catCount:[String:Int] = [:]
            for cat in categories {
                if catCount.keys.contains(cat) {
                    catCount[cat]! += 1
                } else {
                    catCount[cat] = 1
                }
            }
            
            // set up activities
            for (index, element) in categories.enumerated() {
                let activity:Activity = Activity(context: self.context)
                activity.categoryName = element
                let durationArr = durations[index].split(separator: ":")
                let hours = Int(durationArr[0])! * 60 * 60
                let minutes = Int(durationArr[1])! * 60
                activity.duration = Double(hours + minutes)
                activity.actDescription = ""
                activities.append(activity)
            }
            
            // populate plan object
            plan.name = "Your Plan"
            plan.numOfActivties = Int64(activities.count)
            
            // Generate plan
            generatePlan(catCount: catCount)
            
            pageTitle.isUserInteractionEnabled = true
            pencilEditImage.isUserInteractionEnabled = true
            pencilEditImage.isHidden = false
            tableView.dragInteractionEnabled = true
            refreshButton.isEnabled = planDidChange
            
            saveButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
        }
        
        // Do any additional setup after loading the view.
        // set background and title color
        view.backgroundColor = UIColor(red: 68/255, green: 20/255, blue: 152/255, alpha: 1)
        pageTitle.textColor = .white
        planName.isHidden = true
//        pencilEditImage.isHidden = false
        
        // edit plan name
        //pageTitle.isUserInteractionEnabled = true
        let titleSelected : Selector = #selector(self.titleClicked)
        let tapGesture = UITapGestureRecognizer(target: self, action: titleSelected)
        tapGesture.numberOfTapsRequired = 1
        pageTitle.addGestureRecognizer(tapGesture)
        
//        pencilEditImage.isUserInteractionEnabled = true
        let titleSelect : Selector = #selector(self.pencilClicked)
        let tapped = UITapGestureRecognizer(target: self, action: titleSelect)
        tapped.numberOfTapsRequired = 1
        pencilEditImage.addGestureRecognizer(tapped)
        
        // set up route button
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(.white, for: .normal)
        if self.traitCollection.userInterfaceStyle == .dark {
            vStack.backgroundColor = .black
        } else {
            vStack.backgroundColor = .white
        }
        let width = vStack.bounds.size.width
        saveButton.frame = CGRectMake(0, 0, width-10, 100)
        
//        refreshButton.isEnabled = planDidChange
        
        // set up labels
        timeLabel.textColor = .white
        stopsLabel.textColor = .white
        
        // table view
        tableView.separatorStyle = .none
//        tableView.dragInteractionEnabled = true
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
        print("CatCount: ", catCount.description)
        // TODO: catCount.keys is randomly ordered. Fix to match ordering from Your Plan page.
        for cat in catCount.keys {
            // Call API for each category, store results
            getNearbyPlaces(query: cat, radius: plan.radius, location: locMan.location!, completion: { places in
                let count = catCount[cat]!
                
                // TODO: Alert user that 0 (or not enough) places exist with given radius
                if (count > places.count) {
                    return
                }

                let result = activities.filter { act in
                    act.categoryName == cat
                }
                
                // Get random indices
                var randSet = Set<Int>()
                print("places count: \(places.count)")
                while randSet.count < count {
                    let rand = Int.random(in: 0..<places.count)
                    if randSet.contains(rand) {
                      continue
                    }
                    randSet.insert(rand)
                }
                print(randSet)
                
                // TODO: need to refine list by business hours to chekc if activity is available
                // TODO: randomly select activities instead of choosing from beginning of array
                for index in 0..<count {
                    let i = randSet.popFirst()!
                    print(i)
                    let place = places[i]
                    let placeID = place["placeID"] as! String
                    result[index].name = place["name"] as? String
                    result[index].location = "(\(place["placeLat"]!),\(place["placeLng"]!))"
                    // get business hours
                    DispatchQueue.main.async {
                        getPlaceByID(placeID: placeID, completion: { place in
                            print("The selected place is: \(place.name ?? "None")")
                            print(place.placeID!)
                            var day = Calendar.current.component(.weekday, from: Date.now) - 2
                            if day == -1 {
                                day = 6
                            }
                            let bHours = place.openingHours!.weekdayText![day]
                            result[index].businessHours = bHours
                            self.tableView.reloadData()
                        })
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        plan.listActivities = NSOrderedSet(array: activities)
        //plan.listActs = activities
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
            applicationActivities: (didSelectPlan || saved) ? nil : [CustomShareActivity()]
        )
        
        // ipad support
        sharePlan.popoverPresentationController?.sourceView = exportButton
        sharePlan.popoverPresentationController?.sourceRect = exportButton.bounds
        
        // present
        present(sharePlan, animated: true)
    }
    
    @objc func appMovedToBackground() {
        if(!self.saved) {
            let alert = UIAlertController(title: "Do you want to save this plan before you exit?", message: "It can be revisted under Saved Plans.", preferredStyle: .alert)
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
            let cancelButton = UIAlertAction(title: "No", style: .default) { (action) in
                print("cancel")
                self.saved = false
                //self.context.delete(plan)
            }
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true)
        }
    }
    
    @objc func savePlan() {
        if(!self.saved) {
            let alert = UIAlertController(title: "Do you want to save this plan before you exit?", message: "It can be revisted under Saved Plans.", preferredStyle: .alert)
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
            let cancelButton = UIAlertAction(title: "No", style: .default) { (action) in
                print("cancel")
                self.saved = false
                //self.context.delete(plan)
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func homeButtonPressed() {
        if(!self.saved) {
            let alert = UIAlertController(title: "Do you want to save this plan before you return to the home screen?", message: "It can be revisted under Saved Plans.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Save", style: .default) { (action) in
                print("save")
                self.saved = true
                do {
                    try self.context.save()
                }
                catch {
                    print("Issue saving core data")
                }
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(okButton)
            let cancelButton = UIAlertAction(title: "No", style: .default) { (action) in
                print("cancel")
                self.saved = false
                self.context.delete(plan)
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func refreshButtonPressed() {
        // TODO:
        print("REFRESH")
        planDidChange = false
        refreshButton.isEnabled = false
    }
    
    func plusButtonPressed(index:Int) {
        print("Plus button was PRESSED at index: ", index)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let easvc = storyboard.instantiateViewController(withIdentifier: "editaddact_vc") as! EditAddActViewController
        easvc.editActivity = false
        easvc.index = index
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
    
    override func viewWillAppear(_ animated: Bool) {
        refreshButton.isEnabled = planDidChange
        if(planDidChange) {
            tableView.reloadData()
        }
    }
}

// table view
extension GeneratedPlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (didSelectPlan) ? activities.count : activities.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create alternating cells of activties and add buttons
        if(indexPath.row % 2 == 0 || didSelectPlan) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "actCell", for: indexPath) as! CustomActivityTableViewCell
            //cell.titleLabel.textColor = .black
            
            let row = (didSelectPlan) ? indexPath.row : (indexPath.row/2)
            
            cell.titleLabel.text = activities[row].name
            
            cell.businessHours.text = activities[row].businessHours
//            var text = "For "
//            let time = Int(activities[indexPath.row / 2].duration)
//            let hours = Int(time) / 3600
//            let minutes = Int(time) / 60 % 60
//            if(hours == 1) {
//                text = text + String(hours) + " hour "
//            } else if(hours != 0) {
//                text = text + String(hours) + " hours "
//            }
//            if(minutes != 0) {
//                text = text + String(minutes) + " minutes"
//            }
            
            var text = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            var activityTime = (didSelectPlan) ? selectedSavedPlan.startDateTime : plan.startDateTime
            var i = 0
            while (i < (row)) {
                activityTime = activityTime?.addingTimeInterval(TimeInterval(activities[i].duration))
                i += 1
            }
            let result = dateFormatter.string(from: activityTime!)
            text.append(result + " - ")
            let after = activityTime?.addingTimeInterval(TimeInterval(activities[row].duration))
            text.append(dateFormatter.string(from: after!))
            
            //cell.durationLabel.textColor = .black
            cell.durationLabel.text = text
            if(activities[row].actDescription == "Added Activity") {
                cell.cellBackground.image = UIImage(named: "GrayBox")
            } else {
                cell.cellBackground.image = UIImage(named: activities[row].categoryName!)
            }
            cell.cellBackground.layer.opacity = 0.5
            cell.cellBackground.layer.borderColor = UIColor.lightGray.cgColor
            cell.cellBackground.layer.borderWidth = 2
            cell.cellBackground.contentMode = .scaleAspectFill
            cell.cellBackground.layer.cornerRadius = 20
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! CustomAddTableViewCell
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.insertBox = { index in
                self.plusButtonPressed(index: index)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell is CustomActivityTableViewCell) {
            tableView.deselectRow(at: indexPath, animated: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let easvc = storyboard.instantiateViewController(withIdentifier: "editaddact_vc") as! EditAddActViewController
            easvc.editActivity = true
            let row = (didSelectPlan) ? indexPath.row : (indexPath.row/2)
            easvc.activityName = activities[row].name!
            // set address
            easvc.address = activities[row].location!
            // set proper duration
            let time = Int(activities[row].duration)
//            let durationArr = durations[indexPath.row/2].split(separator: ":")
//            let hours = Int(durationArr[0])! * 60 * 60
//            let minutes = Int(durationArr[1])! * 60
            easvc.seconds = time//hours + minutes
            easvc.index = row
            easvc.actDesc = activities[row].actDescription!
            easvc.didSelectPlan = didSelectPlan
            self.navigationController?.pushViewController(easvc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath)
        if(cell is CustomActivityTableViewCell && !didSelectPlan) {
            let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                
                activities.remove(at: indexPath.row / 2)
                plan.numOfActivties -= 1
                plan.listActivities = NSOrderedSet(array: activities)
                //plan.listActs = activities
                planDidChange = true
                self.refreshButton.isEnabled = true
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
        plan.listActivities = NSOrderedSet(array: activities)
        planDidChange = true
        self.refreshButton.isEnabled = true
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
