//
//  ObservationsViewController.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/15/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation
import MapKit

let observationImageTappedNotification = "observationImageTappedNotification"

class ObservationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ObservationTab {

    
    private var observations: [Observation]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onObservationImageTapped:", name: observationImageTappedNotification, object: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ObservationCell", forIndexPath: indexPath) as? ObservationCell {
            if let observations = observations {
                var observation = observations[indexPath.row]
                cell.nameLabel.text = observation.primaryName
                
                if let urlString = observation.firstSmallUrlString, url = NSURL(string: urlString) {
                    let imageRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 120)
                    cell.observationImageView.asyncLoadWithUrlRequest(imageRequest)
                }
                
                if let currentLocation = self.currentLocation {
                    var location = CLLocation(latitude: observation.coordinate.latitude, longitude: observation.coordinate.longitude)
                    var distance = location.distanceFromLocation(CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
                    cell.distanceLabel.text = NSString(format: "%.1f mi", distance/1600) as String
                }
            }

            cell.tag = indexPath.row
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let observations = observations {
            return observations.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let observations = observations where observations.count > indexPath.row {
            let observation = observations[indexPath.row]
            let detailViewController = ObservationDetailViewController(nibName: "ObservationDetailViewController", bundle: nil)
            detailViewController.observation = observation
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is UIButton {
            let indexPath = sender!.tag
            let observation = observations![indexPath]            
            let listingsViewController = segue.destinationViewController as! ListingsViewController

            listingsViewController.coordinate = observation.coordinate
        } else {
            return
        }
    }
    
    func onObservationImageTapped(notification: NSNotification) {
        if let userInfo = notification.userInfo, index = userInfo["index"] as? Int,
               observations = observations where observations.count > index {
            let observation = observations[index]
            let viewController = ObservationDetailViewController(nibName: "ObservationDetailViewController", bundle: nil)
            viewController.observation = observation
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func addObservations(observations: [Observation]) {
        self.observations = sortObservations(observations)
    }
    
    private func sortObservations(observations: [Observation]) -> [Observation] {
        if let currentLocation = currentLocation {
        
        let location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        var sortedObservations = observations.sorted({ (a: Observation, b: Observation) -> Bool in
        let distanceA = location.distanceFromLocation(CLLocation(latitude: a.coordinate.latitude, longitude: a.coordinate.longitude))
        let distanceB = location.distanceFromLocation(CLLocation(latitude: b.coordinate.latitude, longitude: b.coordinate.longitude))
        return distanceA < distanceB
        })
        return sortedObservations
        }
        return observations
    }
    
}