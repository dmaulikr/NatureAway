//
//  ListingsViewController.swift
//  NatureAway
//
//  Created by Elaine Mao on 5/19/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit
import MapKit

let listingImageTappedNotification = "listingImageTappedNotification"

class ListingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var coordinate: CLLocationCoordinate2D?
    
    var listings: [RentalListing]? {
        didSet {
            sortListings();
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        if let latitude = coordinate?.latitude, longitude = coordinate?.longitude {
            ZilyoClient.sharedInstance.getListings(false, latitude: latitude, longitude: longitude) { (listings: [RentalListing]?, error: NSError?) -> Void in
                if let listings = listings {
                    self.listings = listings
                } else {
                    if let error = error {
                        print(error)
                    }
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onListingImageTapped:", name: listingImageTappedNotification, object: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(listings)
        if let cell = tableView.dequeueReusableCellWithIdentifier("RentalListingCell", forIndexPath: indexPath) as? RentalListingCell {
            if let listings = listings {
                cell.observationCoordinate = coordinate
                cell.listing = listings[indexPath.row]
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
        navigateToDetail(indexPath.row)
    }
    
    func onListingImageTapped(notification: NSNotification) {
        if let userInfo = notification.userInfo, index = userInfo["index"] as? Int {
            navigateToDetail(index)
        }
    }
    
    func navigateToDetail(index: Int) {
        if let listings = listings where listings.count > index {
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
    
    private func sortListings() -> [RentalListing]? {
        /*if let coordinate = coordinate, listings = listings {
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            var sortedListings = listings.sorted({ (a: RentalListing, b: RentalListing) -> Bool in
                let distanceA = location.distanceFromLocation(CLLocation(latitude: a.coordinate.latitude, longitude: a.coordinate.longitude))
                let distanceB = location.distanceFromLocation(CLLocation(latitude: b.coordinate.latitude, longitude: b.coordinate.longitude))
                return distanceA > distanceB
            })
            return sortedListings
        }*/
        return listings
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
