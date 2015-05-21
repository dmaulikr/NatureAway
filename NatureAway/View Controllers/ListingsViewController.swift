//
//  ListingsViewController.swift
//  NatureAway
//
//  Created by Elaine Mao on 5/19/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

let listingImageTappedNotification = "listingImageTappedNotification"

class ListingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var latitude: Float!
    var longitude: Float!
    
    var listings: [RentalListing]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        ZilyoClient.sharedInstance.getListings(false, latitude: latitude, longitude: longitude) { (listings: [RentalListing]?, error: NSError?) -> Void in
            if let listings = listings {
                self.listings = listings
            } else {
                if let error = error {
                    println(error)
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onListingImageTapped:", name: listingImageTappedNotification, object: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(listings)
        if let cell = tableView.dequeueReusableCellWithIdentifier("RentalListingCell", forIndexPath: indexPath) as? RentalListingCell {
            if let listings = listings {
                var listing = listings[indexPath.row]
                cell.headingLabel.text = listing.heading
                cell.numBedroomsLabel.text = "\(String(listing.numBedrooms)) Bedroom(s)"
                cell.numBathroomsLabel.text = "\(String(listing.numBathrooms)) Bathroom(s)"
                cell.priceLabel.text = "$\(String(listing.nightlyPrice)) Per Night"
                if let smallUrls = listing.smallUrlStrings {
                    cell.rentalImage.setImageWithURL(NSURL(string: smallUrls[0]))
                }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func onListingImageTapped(notification: NSNotification) {
        if let userInfo = notification.userInfo, index = userInfo["index"] as? Int,
            listings = listings where listings.count > index {
                let listing = listings[index]
                let viewController = ListingsDetailViewController(nibName: "ListingsDetailViewController", bundle: nil)
                viewController.listing = listing
                navigationController?.pushViewController(viewController, animated: true)
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
