//
//  GoogleServices.swift
//  PlanA
//
//  Created by Satya Suravaram on 2/28/23.
//

import Foundation
import GooglePlaces
import Alamofire

let nearbySearchURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

// Returns Place Details given Google Place ID
public func getPlaceByID(
    placeID:String,
    completion: @escaping (Result<[String], Error>) -> Void
) {
    // harcoded
    let placeID = "ChIJEZ7agoK1RIYRIZlMB_YtUc8"

    // Specify the place data types to return.
    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                              UInt(GMSPlaceField.placeID.rawValue) |
                                              UInt(GMSPlaceField.openingHours.rawValue) |
                                              UInt(GMSPlaceField.priceLevel.rawValue) |
                                              UInt(GMSPlaceField.rating.rawValue))

    GMSPlacesClient.shared().fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
      (place: GMSPlace?, error: Error?) in
      if let error = error {
        print("An error occurred: \(error.localizedDescription)")
        return
      }
      if let place = place {
          print("The selected place is: \(place.name ?? "None")")
          print(place.placeID!)
          print(place.openingHours!)
          print(place.priceLevel)
          print(place.rating)
      }
    })
}

// Returns list of nearby places given search query/category
public func getNearbyPlaces(
    query:String,
    location:CLLocation,
    completion: @escaping (Result<[String], Error>) -> Void
) {
    let lat = location.coordinate.latitude
    let lng = location.coordinate.longitude
    let radius = 5000; // in meters
    let keyword = "restaurant"
    print(lat, lng)
    
    var params : [String : Any]
            
    params = [
        "key" : AppDelegate.apiKey,
        "keyword": keyword,
        "radius" : radius,
        "location" : "\(lat),\(lng)",
    ]
    
    // need to pass headers, otherwise google api throws a restricted error
    let headers:HTTPHeaders = ["Content-Type": "application/json", "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier!]
    
    AF.request(nearbySearchURL, parameters: params, encoding: URLEncoding(destination: .queryString), headers: headers).responseJSON { response in

//        let response = QNearbyPlacesResponse.init(dic: response.result.value as? [String: Any])
//        completion(response)
        print(response)
    }
    
}

struct PlacesResponse {
    
}
