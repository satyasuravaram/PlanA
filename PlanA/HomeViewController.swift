//
//  ViewController.swift
//  PlanA
//
//  Created by Satya Suravaram on 2/3/23.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet var savedPlanButton: UIButton!
    
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Home page")
        
        // Request user location
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // test api call GooglePlaces
        getPlaceByID(placeID: "", completion: {_ in })
    }
    
//    @IBAction func buttonPressed() {
//        print("Button pressed")
//        let vc = storyboard?.instantiateViewController(identifier: "savedplans_vc") as! SavedPlanViewController
//        present(vc, animated: false)
//    }

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
