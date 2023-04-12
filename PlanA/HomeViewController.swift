//
//  ViewController.swift
//  PlanA
//
//  Created by Satya Suravaram on 2/3/23.
//

import UIKit
import CoreLocation

public var locMan:CLLocationManager!

class HomeViewController: UIViewController {
    
    var locationManager:CLLocationManager!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var startPlanButton: UIButton!
    @IBOutlet var savedPlansButton: UIButton!
    @IBOutlet var logo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set up home page background
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "home_screen")
        imageViewBackground.contentMode = .scaleAspectFill
        view.addSubview(imageViewBackground)
        view.sendSubviewToBack(imageViewBackground)
        
        // set up buttons
        startPlanButton.backgroundColor = .white
        startPlanButton.layer.cornerRadius = 10
            
        savedPlansButton.backgroundColor = .white
        savedPlansButton.layer.cornerRadius = 10
        
        // Request user location
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locMan = locationManager
        // test api call GooglePlaces
        //getPlaceByID(placeID: "", completion: {_ in })
        
//        getPlaceByID(placeID: "", completion: {_ in })
//        getNearbyPlaces(query: "", location: locationManager.location!, completion: {_ in })
    }

    // listen for rotation event and update image background, readjust frame of view to screen bounds
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        let imageViewBackgroundnew = UIImageView(frame: CGRectMake(0, 0, height, width))
        imageViewBackgroundnew.image = UIImage(named: "home_screen")
        imageViewBackgroundnew.contentMode = .scaleAspectFill
        view.addSubview(imageViewBackgroundnew)
        view.insertSubview(imageViewBackgroundnew, aboveSubview: view.subviews[0])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!appDelegate.hasAlreadyLaunched){
            //set hasAlreadyLaunched to false
            appDelegate.sethasAlreadyLaunched()
            print("FIRST TIME LAUNCHING")
        } else {
            print("NOT FIRST TIME LAUNCHING")
        }
        do {
            try self.context.save()
        }
        catch {
            print("ERROR")
        }
    }
}

// User location authorization status
extension HomeViewController: CLLocationManagerDelegate {
    // deprecated - update later
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Authorized when in use")
            print("USER LOCATION: lat, lng = \(locationManager.location!.coordinate.latitude), \(locationManager.location!.coordinate.longitude )")
        case .authorizedAlways:
            print("Authorized always")
            // todo add notification
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not determined")
        case .restricted:
            print("Restricted")
        @unknown default:
            print("Unknown status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("USER CURRENT LOCATION: lat \(loc.latitude) lng \(loc.longitude)")
    }
}
