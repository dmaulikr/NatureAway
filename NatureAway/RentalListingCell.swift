//
//  RentalListingCell.swift
//  NatureAway
//
//  Created by Elaine Mao on 5/19/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class RentalListingCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var numBedroomsLabel: UILabel!
    @IBOutlet weak var numBathroomsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rentalImage: UIImageView!
    
    var listing: RentalListing? {
        didSet {
            if let listing = listing {
                headingLabel.text = listing.heading
                numBedroomsLabel.text = "\(String(listing.numBedrooms)) Bedroom(s)"
                numBathroomsLabel.text = "\(String(listing.numBathrooms)) Bathroom(s)"
                priceLabel.text = "$\(String(listing.nightlyPrice)) Per Night"
                if let smallUrls = listing.smallUrlStrings {
                    rentalImage.setImageWithURL(NSURL(string: smallUrls[0]))
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
