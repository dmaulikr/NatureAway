//
//  RentalListing.swift
//  NatureAway
//
//  Created by Elaine Mao on 5/16/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation
import CoreLocation

class RentalListing: NSObject {
    
    var numBedrooms: Int
    var numBathrooms: Int
    var listingDescription: String
    var heading: String
    var city: String
    var country: String
    var postalCode: String
    var smallUrlStrings: [String]?
    var largeUrlStrings: [String]?
    var nightlyPrice: Int
    var listingUrl: String
    var coordinate: CLLocationCoordinate2D?
    
    init(dictionary: NSDictionary) {
        
        numBedrooms = dictionary.valueForKeyPath("attr.bedrooms") as! Int
        numBathrooms = dictionary.valueForKeyPath("attr.bathrooms") as! Int
        listingDescription = dictionary.valueForKeyPath("attr.description") as! String
        heading = dictionary.valueForKeyPath("attr.heading") as! String
        city = dictionary.valueForKeyPath("location.city") as! String
        country = dictionary.valueForKeyPath("location.country") as! String
        postalCode = dictionary.valueForKeyPath("location.postalCode") as! String
        nightlyPrice = dictionary.valueForKeyPath("price.nightly") as! Int
        listingUrl = dictionary.valueForKeyPath("provider.url") as! String
        
        let latLng = dictionary.valueForKeyPath("latLng") as? NSArray
        coordinate = CLLocationCoordinate2D(latitude: (latLng?[0] as! Double), longitude: (latLng?[1] as! Double))
        
        if let photosArray = dictionary["photos"] as? [NSDictionary] {
            smallUrlStrings = [String]()
            largeUrlStrings = [String]()
            for photoDictionary in photosArray {
                if let largeUrlString = photoDictionary["xlarge"] as? String {
                     largeUrlStrings?.append(largeUrlString)
                }
                if let smallUrlString = photoDictionary["small"] as? String {
                    smallUrlStrings?.append(smallUrlString)
                }
            }
        }
    }
    
    class func listingsWithArray(array: [NSDictionary]) -> [RentalListing] {
        var listings = [RentalListing]()
        for dictionary in array {
            let listing = RentalListing(dictionary: dictionary)
            listings.append(listing)
        }
        return listings
    }
}