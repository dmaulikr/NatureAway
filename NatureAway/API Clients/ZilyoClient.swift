//
//  ZilyoClient.swift
//  NatureAway
//
//  Created by Elaine Mao on 5/16/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation

class ZilyoClient: AFHTTPRequestOperationManager {
    let mashapeKey = "yourkeyhere"
    static let zilyoBaseURL = "https://zilyo.p.mashape.com"
    
    static let sharedInstance = ZilyoClient(baseURL: NSURL(string: zilyoBaseURL))

    func getListings(isinstantbook: Bool, latitude: Double, longitude: Double, count: Int = 20, completion: ([RentalListing]?, NSError?) -> Void) {
        
        let params = NSMutableDictionary()
        params["isinstantbook"] = isinstantbook
        params["latitude"] = latitude
        params["longitude"] = longitude
        params["provider"] = "airbnb"
        params["maxdistance"] = 200.0
        params["resultsperpage"] = count
        
        self.requestSerializer.setValue(mashapeKey, forHTTPHeaderField: "X-Mashape-Key")
        self.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        self.responseSerializer.acceptableContentTypes = ["application/json", "application/javascript"]

        
        self.GET("search", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            if let array = response["result"] as? [NSDictionary] {
                let observations = RentalListing.listingsWithArray(array)
                completion(observations, nil)
            }
            completion(nil, nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in completion(nil, error)
                print(error)
        })
    }
}
