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
    @IBOutlet var planName: UITextField!
    @IBOutlet var pencilEditImage: UIImageView!
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var hStack: UIStackView!
    @IBOutlet var vStack: UIStackView!
    @IBOutlet var totalTLabel: UILabel!
    @IBOutlet var totalSLabel: UILabel!
    
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
            saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            //saveButton.backgroundColor = .lightGray
            pageTitle.isUserInteractionEnabled = false
            pencilEditImage.isUserInteractionEnabled = false
            pencilEditImage.isHidden = true
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
            
//            saveButton.backgroundColor = UIColor(red: 53/255, green: 167/255, blue: 255/255, alpha: 1)
            saveButton.setImage(UIImage(systemName: "star"), for: .normal)
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
        
        // set up save button
//        saveButton.layer.cornerRadius = 10
//        saveButton.setTitleColor(.white, for: .normal)
        
        // set up labels
//        timeLabel.textColor = .white
//        stopsLabel.textColor = .white
        
        // table view
        tableView.separatorStyle = .none
//        tableView.dragInteractionEnabled = true
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.contentInset.bottom = 100
        self.view.sendSubviewToBack(tableView)
        
        // set up button bar
        hStack.layer.cornerRadius = 5
        self.view.insertSubview(tableView, belowSubview: hStack)
        self.view.insertSubview(tableView, belowSubview: vStack)
        
        // catch if user exits app
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(leaveGenPlan)
        )
        
        infoButton.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
    }
    
    func generatePlan(catCount:[String:Int]) {
        print("CatCount: ", catCount.description)
        // TODO: catCount.keys is randomly ordered. Fix to match ordering from Your Plan page.
        for cat in catCount.keys {
            // Call API for each category, store results
            getNearbyPlaces(query: cat, radius: plan.radius, location: locMan.location!, completion: { places in
                let count = catCount[cat]!
                
                let result = activities.filter { act in
                    act.categoryName == cat
                }
                
                if (places.count == 0) {
                    for index in 0..<count {
                        result[index].name = "No results found for \(cat)"
                        result[index].actDescription = ""
                        result[index].businessHours = ""
                        result[index].location = "No location found"
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    return
                }
                
                // Get random indices
                var randSet = Set<Int>()
                print("count: \(count)")
                print("places count: \(places.count)")
                while randSet.count < count {
                    print(randSet)
                    print(places.count)
                    let rand = Int.random(in: 0..<places.count)
                    if randSet.count >= places.count {
                        break
                        
                    } else if randSet.contains(rand) {
                        continue
                    }
                    randSet.insert(rand)
                }
                
                var tempSet = randSet
                
                for index in 0..<count {
                    if tempSet.count == 0 {
                        tempSet = randSet
                    }
                    let i = tempSet.popFirst()!
                    print(i)
                    let place = places[i]
                    let placeID = place["placeID"] as! String
                    result[index].name = place["name"] as? String
                    //result[index].location = "(\(place["placeLat"]!),\(place["placeLng"]!))"
                    // get business hours
                    DispatchQueue.main.async {
                        getPlaceByID(placeID: placeID, completion: { place in
                            print("The selected place is: \(place.name ?? "None")")
                            print(place.placeID!)
                            // get location
                            result[index].location = place.formattedAddress!
                            if place.openingHours == nil || place.openingHours?.weekdayText == nil {
                                result[index].businessHours = ""
                                self.tableView.reloadData()
                                return
                            }
                            print(place.openingHours!.weekdayText!)
                            var day = Calendar.current.component(.weekday, from: plan.startDateTime!) - 2
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
    
    @IBAction func infoButtonPressed() {
        if(infoButton.currentImage == UIImage(systemName: "info.circle.fill")) {
            timeLabel.isHidden = true
            totalTLabel.isHidden = true
            stopsLabel.isHidden = true
            totalSLabel.isHidden = true
            infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        } else {
            timeLabel.isHidden = false
            totalTLabel.isHidden = false
            stopsLabel.isHidden = false
            totalSLabel.isHidden = false
            infoButton.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
        }
    }
    
    // create export pop over view
    @IBAction func exportButtonPressed() {
        // action items
        let shareText = "Share your plan.\n"
        let planText = (didSelectPlan) ? selectedSavedPlan.getPlanActivties() : plan.getPlanActivties()
        let sharePlan = UIActivityViewController(
            activityItems: [
                shareText,
                planText
            ],
            applicationActivities: nil
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
                    self.saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
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
    
    @objc func leaveGenPlan() {
        if(!didSelectPlan) {
            let alert = UIAlertController(title: "Are you sure you want to leave this generated plan.", message: nil, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Yes", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okButton)
            let cancelButton = UIAlertAction(title: "No", style: .default)
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
            saveButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
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
        vStack.backgroundColor = tableView.backgroundColor
        if(planDidChange) {
            tableView.reloadData()
        }
        stopsLabel.text = String(activities.count)
        var totalTime = 0
        for act in activities {
            totalTime += Int(act.duration)
        }
        let hours = totalTime / 3600
        let minutes = totalTime / 60 % 60
        var text = ""
        if(hours > 1) {
            text.append(String(hours) + " hrs ")
        } else if (hours == 1) {
            text.append("1 hr ")
        }
        if(minutes > 0) {
            text.append(String(minutes) + " mins")
        }
        timeLabel.text = text
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
            cell.businessHours.textColor = .black
            if (cell.businessHours.text != nil && cell.businessHours.text!.contains("Closed")) {
                cell.businessHours.textColor = .red
            }
            
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
            activities[row].timeSpan = text
            
            //cell.durationLabel.textColor = .black
            cell.durationLabel.text = text
            
            // TODO: Check if shop is open during time slot
            if cell.businessHours.text != nil {
                var withinHours = false
                print("Check time slot")
                print(cell.businessHours.text)
                let index = cell.businessHours.text?.firstIndex(of: ":")
                print(index)
                print(cell.businessHours.text![(index!)...])
                
                // do checking here
                // set withinHours
                
                if withinHours {
                    cell.businessHours.textColor = .black
                } else {
                    cell.businessHours.textColor = .red
                }
            }
            
            if(activities[row].actDescription == "Added Activity" || UIImage(named: activities[row].categoryName!) == nil) {
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
                self.tableView.reloadData()
                self.viewWillAppear(false)
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
