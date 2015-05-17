//
//  ObservationsViewController.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/15/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import Foundation

class ObservationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var species: Species?
    var observations: [Observation]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        loadObservations()
    }
    
    func loadObservations() {
        if let species = species, taxonId = species.id {
            INaturalistClient.sharedInstance.getObservations(taxonId, completion: { (observations: [Observation]?, error: NSError?) -> Void in
                if let observations = observations {
                    self.observations = observations
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("ObservationCell", forIndexPath: indexPath) as? ObservationCell {
            if let observations = observations {
                var observation = observations[indexPath.row]
                cell.nameLabel.text = observation.commonNameString
                
                if let smallUrlStrings = observation.smallUrlStrings {
                    if smallUrlStrings.count > 0 {
                        var urlString = smallUrlStrings[0]
                        var url = NSURL(string: urlString)
                        cell.observationImageView.setImageWithURL(url)
                    }
                }
            }
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
    
}