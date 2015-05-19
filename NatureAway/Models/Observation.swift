//
//  Observation.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/14/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation
import MapKit

class Observation: NSObject, MKAnnotation {
    
    var latitudeString: String?
    var longitudeString: String?
    var commonNameString: String?
    var iconicTaxonName: String?
    var largeUrlStrings: [String]?
    var smallUrlStrings: [String]?
    
    // Required for MKAnnotation
    let coordinate: CLLocationCoordinate2D
    let title: String

    init(dictionary: NSDictionary) {

        latitudeString = dictionary["latitude"] as? String
        longitudeString = dictionary["longitude"] as? String
        
        var latitude = 0.0
        var longitude = 0.0
        if let latitudeString = latitudeString {
            if let longitudeString = longitudeString {
                latitude = (latitudeString as NSString).doubleValue
                longitude = (longitudeString as NSString).doubleValue
            }
        }

        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        if let taxon = dictionary["taxon"] as? NSDictionary, commonName = taxon["common_name"] as? NSDictionary {
            commonNameString = commonName["name"] as? String
            title = commonNameString!
        } else {
            title = "unknown"
        }
        
        iconicTaxonName = dictionary["iconic_taxon_name"] as? String

        if let photosArray = dictionary["photos"] as? [NSDictionary] {
            largeUrlStrings = [String]()
            smallUrlStrings = [String]()
            for photoDictionary in photosArray {
                if let smallUrlString = photoDictionary["small_url"] as? String {
                    smallUrlStrings?.append(smallUrlString)
                }
                if let largeUrlString = photoDictionary["large_url"] as? String {
                    largeUrlStrings?.append(largeUrlString)
                }
            }
        }

        super.init()
    }
    
    class func observationsWithArray(array: [NSDictionary]) -> [Observation] {
        var observations = [Observation]()
        for dictionary in array {
            let observation = Observation(dictionary: dictionary)
            observations.append(observation)
        }
        return observations
    }
    
}