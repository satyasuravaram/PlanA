//
//  GoogleServices.swift
//  PlanA
//
//  Created by Satya Suravaram on 2/28/23.
//

import Foundation
import GooglePlaces

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
