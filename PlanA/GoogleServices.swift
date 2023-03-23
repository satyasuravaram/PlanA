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
    radius:Int64,
    location:CLLocation,
    completion: @escaping ([[String:Any]]) -> Void
) {
    let lat = location.coordinate.latitude
    let lng = location.coordinate.longitude
    let radius = radius // in meters
    let keyword = query

    var urlBuilder = URLComponents(string: nearbySearchURL)
    urlBuilder?.queryItems = [
        URLQueryItem(name: "key", value: AppDelegate.apiKey),
        URLQueryItem(name: "keyword", value: keyword),
        URLQueryItem(name: "radius", value: String(radius)),
        URLQueryItem(name: "location", value: "\(lat),\(lng)"),
    ]
    guard let url = urlBuilder?.url else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "X-Ios-Bundle-Identifier")

    URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.fragmentsAllowed])
            let result = json as! [String:Any]
            let places = result["results"] as! NSArray
            var placesRet:[[String:Any]] = []
            for place in places {
                var placeInfo:[String:Any] = [:]
                let placeObj = place as! [String:Any]
                let name = placeObj["name"] as! String
                let placeID = placeObj["place_id"] as! String
                let geometry = placeObj["geometry"] as! [String:Any]
                let location = geometry["location"] as! [String:Any]
                let placeLat = location["lat"] as! Double
                let placeLng = location["lng"] as! Double
                placeInfo["name"] = name
                placeInfo["placeID"] = placeID
                placeInfo["placeLat"] = placeLat
                placeInfo["placeLng"] = placeLng
                placesRet.append(placeInfo)
            }
            completion(placesRet)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }.resume()
}
