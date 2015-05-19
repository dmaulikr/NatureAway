//
//  ObservationsViewController.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/15/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation

let observationImageTappedNotification = "observationImageTappedNotification"

class ObservationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ObservationTab {

    var observations: [Observation]? {
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
                cell.nameLabel.text = observation.commonNameString
                
                
                if let urlString = observation.firstSmallUrlString {
                    var url = NSURL(string: urlString)
                    cell.observationImageView.setImageWithURL(url)
                }
                
                if let latitudeString = observation.latitudeString {
                    cell.latitudeLabel.text = latitudeString
                }
                
                
                if let longitudeString = observation.longitudeString {
                    cell.longitudeLabel.text = longitudeString
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let observation = observations![indexPath.row]
        
        println(observation)
        
        let listingViewController = segue.destinationViewController as! ListingViewController
        
        //listingViewController.observation = observation
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
    
}