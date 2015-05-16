//
//  INaturalistClient.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/13/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation


class INaturalistClient: BDBOAuth1RequestOperationManager {
    
    static let iNaturalistConsumerKey = "9da2feb4595aaf011739ccd2a1f488777da0ce17fbf723689913ee724e0bdfd6"
    static let iNaturalistConsumerSecret = "f5e0a02518f54eb5a3da54d6642f1160a0cccb49464c9c5d3a5d3046a23e6497"
    static let iNaturalistBaseUrlString = "https://www.inaturalist.org"
 
    static let sharedInstance = INaturalistClient(baseURL: NSURL(string: iNaturalistBaseUrlString), consumerKey: iNaturalistConsumerKey, consumerSecret: iNaturalistConsumerSecret)
    
    func getObservations(taxonName: String, completion: ([Observation]?, NSError?) -> Void) {
        var params = NSMutableDictionary()
        params["q"] = taxonName
        self.GET("observations.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                if let array = response as? [NSDictionary] {
                    var observations = Observation.observationsWithArray(array)
                    completion(observations, nil)
                }
                completion(nil, nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                completion(nil, error)
        })
    }
    
    func getSpecies(taxonName: String, completion: ([Species]?, NSError?) -> Void) {
        var params = NSMutableDictionary()
        params["q"] = taxonName
        self.GET("/taxa/search.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                if let array = response as? [NSDictionary] {
                    var species = Species.speciesWithArray(array)
                    completion(species, nil)
                }
                completion(nil, nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
                completion(nil, error)
        })
    }
}