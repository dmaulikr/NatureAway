//
//  RentalListingCell.swift
//  NatureAway
//
//  Created by Elaine Mao on 5/19/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit
import CoreLocation

class RentalListingCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var numBedroomsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rentalImage: UIImageView!
    
    var observationCoordinate: CLLocationCoordinate2D?
    
    var listing: RentalListing? {
        didSet {
            if let listing = listing {
                headingLabel.text = listing.heading
                numBedroomsLabel.text = "\(String(listing.numBedrooms)) Beds, \(String(listing.numBathrooms)) Baths"
                priceLabel.text = "$\(String(listing.nightlyPrice)) Per Night"
                if let smallUrls = listing.smallUrlStrings {
                    rentalImage.setImageWithURL(NSURL(string: smallUrls[0]))
                }
                if let  observationCoordinate = observationCoordinate {
                    var location = CLLocation(latitude: listing.coordinate!.latitude, longitude: listing.coordinate!.longitude)
                    var distance = location.distanceFromLocation(CLLocation(latitude: observationCoordinate.latitude, longitude: observationCoordinate.longitude))
                    distanceLabel.text = NSString(format: "%.1f mi", distance/1600) as String
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        headingLabel.preferredMaxLayoutWidth = headingLabel.frame.size.width
        let tapGesture = UITapGestureRecognizer(target: self, action: "onImageTapped")
        rentalImage.addGestureRecognizer(tapGesture)
        rentalImage.userInteractionEnabled = true
        
        var selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.nature_Green
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        headingLabel.preferredMaxLayoutWidth = headingLabel.frame.size.width
    }
    
    func onImageTapped() {
        var userInfo = [NSObject: AnyObject]()
        userInfo["index"] = tag
        NSNotificationCenter.defaultCenter().postNotificationName(listingImageTappedNotification, object: self, userInfo: userInfo)
    }
}
