//
//  INaturalistClient.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/13/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation
import MapKit


class INaturalistClient: BDBOAuth1RequestOperationManager {
    
    static let iNaturalistConsumerKey = "9da2feb4595aaf011739ccd2a1f488777da0ce17fbf723689913ee724e0bdfd6"
    static let iNaturalistConsumerSecret = "f5e0a02518f54eb5a3da54d6642f1160a0cccb49464c9c5d3a5d3046a23e6497"
    static let iNaturalistBaseUrlString = "https://www.inaturalist.org"
 
    static let sharedInstance = INaturalistClient(baseURL: NSURL(string: iNaturalistBaseUrlString), consumerKey: iNaturalistConsumerKey, consumerSecret: iNaturalistConsumerSecret)
    
    func getObservations(taxonId: Int64, completion: ([Observation]?, NSError?) -> Void) {
        var params = NSMutableDictionary()
        params["taxon_id"] = String(taxonId)
        self.fetchObservations(params, completion: completion)
    }
    
    func getObservationsAtLocation(taxonId: Int64, center: CLLocationCoordinate2D, radius: Double, completion: ([Observation]?, NSError?) -> Void) {
        
        // calculate bounding area from center and radius
        var neBound = locationWithBearing(M_PI_4, distanceMeters: radius, origin: center)
        var swBound = locationWithBearing(M_PI_4 + M_PI, distanceMeters: radius, origin: center)
        
        var params = NSMutableDictionary()
        params["taxon_id"] = String(taxonId)
        params["nelat"] = neBound.latitude
        params["nelon"] = neBound.longitude
        params["swlat"] = swBound.latitude
        params["swlon"] = swBound.longitude

        self.fetchObservations(params, completion: {
            (response: [Observation]?, error: NSError?) -> Void in
                if let response = response {
                    
                    // The API unfortunately doesn't respect the bounds of the search query correctly so we need to do some extra filtering
                    // Filter out any observations that fall outside the search boundary
                    println("Observations: \(response.count)")
                    let filteredObservations = self.filterObservations(response, swBound: swBound, neBound: neBound)
                    println("Filtered Observations: \(filteredObservations.count)")
                    completion(filteredObservations, nil)
                } else {
                    completion(response, error)
            }
        })
    }
    
    private func filterObservations(observations: [Observation], swBound: CLLocationCoordinate2D, neBound: CLLocationCoordinate2D) -> [Observation] {
        let swPoint = MKMapPointForCoordinate(swBound)
        let nePoint = MKMapPointForCoordinate(neBound)
        let mapRect = MKMapRectMake(min(swPoint.x,nePoint.x), min(swPoint.y,nePoint.y), abs(swPoint.x-nePoint.x), abs(swPoint.y-nePoint.y))
        return observations.filter { o in
            let obsPoint = MKMapPointForCoordinate(o.coordinate)
            return MKMapRectContainsPoint(mapRect, obsPoint)
        }
    }
    
    // Stolen from the internet
    private func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters
        
        let lat1 = origin.latitude * M_PI / 180
        let lon1 = origin.longitude * M_PI / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
    }
    
    private func fetchObservations(params: NSDictionary,completion: ([Observation]?, NSError?) -> Void) {
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