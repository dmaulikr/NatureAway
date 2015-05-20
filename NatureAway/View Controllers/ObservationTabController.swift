//
//  ObservationTabController.swift
//  NatureAway
//
//  Created by Chris Beale on 5/18/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit
import MapKit

protocol ObservationTab : class {
    var observations: [Observation]? { get set }
    var currentLocation: CLLocationCoordinate2D? { get set }
}

class ObservationTabController: UITabBarController, MapViewControllerDelegate, CLLocationManagerDelegate {

    var species: Species?
    var observations: [Observation]?
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()

        // Do any additional setup after loading the view.
        if let controllers = self.viewControllers {
            for controller in controllers {
                if let controller = controller as? MapViewController {
                    controller.delegate = self
                }
            }
        }
        
        loadObservations()
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if locations.count > 0 {
            if let controllers = self.viewControllers, location = locations[0] as? CLLocation {
                for controller in controllers {
                    if let controller = controller as? ObservationTab {
                        controller.currentLocation = location.coordinate
                    }
                }
            }
        }
        locationManager?.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadObservations() {
        if let species = species, taxonId = species.id {
            INaturalistClient.sharedInstance.getObservations(taxonId, completion: { (observations: [Observation]?, error: NSError?) -> Void in
                if let observations = observations {
                    self.observations = observations
                    if let controllers = self.viewControllers {
                        for controller in controllers {
                            if let controller = controller as? ObservationTab {
                                controller.observations = observations
                            }
                        }
                    }
                }
            })
        }
    }
    
    func searchAreaUpdated(center: CLLocationCoordinate2D, radius: Double) {
        if let species = species, taxonId = species.id {
            INaturalistClient.sharedInstance.getObservationsAtLocation(taxonId, center: center, radius: radius, completion: { (observations: [Observation]?, error: NSError?) -> Void in
                if let observations = observations {
                    self.observations = observations
                    if let controllers = self.viewControllers {
                        for controller in controllers {
                            if let controller = controller as? ObservationTab {
                                controller.observations = observations
                            }
                        }
                    }
                }
            })
        }

    }
    
    
    func onLocationUpdated(notification: NSNotification) {
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
