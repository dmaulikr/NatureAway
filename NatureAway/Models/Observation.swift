//
//  Observation.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/14/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation

class Observation: NSObject {
    
    var latitudeString: String?
    var longitudeString: String?
    var commonNameString: String?
    var largeUrlStrings: [String]?
    var smallUrlStrings: [String]?
    
    init(dictionary: NSDictionary) {

        latitudeString = dictionary["latitude"] as? String
        longitudeString = dictionary["longitude"] as? String
        
        if let taxon = dictionary["taxon"] as? NSDictionary, commonName = taxon["common_name"] as? NSDictionary {
            commonNameString = commonName["name"] as? String
        }
        
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