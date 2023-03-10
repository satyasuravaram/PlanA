//
//  ViewController.swift
//  PlanA
//
//  Created by Satya Suravaram on 2/3/23.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    
    var locationManager:CLLocationManager!
    
    // reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        
        print("Home page")
        
        // Request user location
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // test api call GooglePlaces
        //getPlaceByID(placeID: "", completion: {_ in })
        
//        let newPlan = Plan(context: self.context)
//        newPlan.name = "ctre"
//        newPlan.dateCreated = Date()
//
//        let newPlan1 = Plan(context: self.context)
//        newPlan1.name = "aadd"
//        newPlan1.dateCreated = Date()
//        
//        let newPlan2 = Plan(context: self.context)
//        newPlan2.name = "jkl"
//        newPlan2.dateCreated = Date()
//
//        do {
//            try self.context.save()
//        }
//        catch {
//            print("Issue saving core data")
//        }
    }

}

// User location authorization status
extension HomeViewController: CLLocationManagerDelegate {
    // deprecated - update later
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Authorized when in use")
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

}
