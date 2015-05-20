//
//  ListingsViewController.swift
//  NatureAway
//
//  Created by Elaine Mao on 5/19/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class ListingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var latitude: Float!
    var longitude: Float!
    
    var listings: [RentalListing]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        ZilyoClient.sharedInstance.getListings(true, latitude: 52.5306438, longitude: 13.3830683) { (listings: [RentalListing]?, error: NSError?) -> Void in
            if let listings = listings {
                println(listings)
                self.listings = listings
            } else {
                if let error = error {
                    println(error)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("RentalListingCell", forIndexPath: indexPath) as? RentalListingCell {
            if let listings = listings {
                var listing = listings[indexPath.row]
                cell.headingLabel.text = listing.heading
                cell.numBedroomsLabel.text = String(listing.numBedrooms)
                cell.numBathroomsLabel.text = String(listing.numBathrooms)
                cell.priceLabel.text = String(listing.nightlyPrice)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listings = listings {
            return listings.count
        } else {
            return 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
