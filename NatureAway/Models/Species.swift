//
//  Species.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/15/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation

class Species: NSObject {
    
    var id: Int64?
    var commonName: String?
    
    var smallUrlString: String?
    var squareUrlString: String?
    var largeUrlString: String?
    
    init(dictionary: NSDictionary) {
        
        if let idNumber = dictionary["id"] as? NSNumber {
            id = idNumber.longLongValue
        }

        if let commonNameDictionary = dictionary["common_name"] as? NSDictionary {
            commonName = commonNameDictionary["name"] as? String
        }
        
        if let taxonPhotos = dictionary["taxon_photos"] as? [NSDictionary] {
            if taxonPhotos.count > 0 {
                if let photoDictionary = taxonPhotos[0]["photo"] as? NSDictionary {
                    smallUrlString = photoDictionary["small_url"] as? String
                    squareUrlString = photoDictionary["square_url"] as? String
                    largeUrlString = photoDictionary["large_url"] as? String
                }
            }
        }
    }
    
    class func speciesWithArray(array: [NSDictionary]) -> [Species] {
        var speciesArray = [Species]()
        for dictionary in array {
            let species = Species(dictionary: dictionary)
            speciesArray.append(species)
        }
        return speciesArray
    }
}