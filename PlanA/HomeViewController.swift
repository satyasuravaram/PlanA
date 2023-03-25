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
