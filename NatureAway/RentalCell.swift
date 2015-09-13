//
//  RentalCell.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/20/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class RentalCell: UITableViewCell {

    @IBOutlet weak var rentalImageView: UIImageView!
    
    @IBOutlet weak var rentalTitleLabel: UILabel!
    @IBOutlet weak var rentalCostLabel: UILabel!
    @IBOutlet weak var rentalRoomsLabel: UILabel!
    
    var listing: RentalListing? {
        didSet {
            if let listing = listing {
                rentalTitleLabel.text = listing.heading
                rentalRoomsLabel.text = "\(String(listing.numBedrooms)) Beds, \(String(listing.numBathrooms)) Baths"
                
                rentalCostLabel.text = "$\(String(listing.nightlyPrice)) Per Night"
                if let smallUrls = listing.smallUrlStrings where smallUrls.count > 0 {
                    rentalImageView.asyncLoadWithUrl(NSURL(string: smallUrls[0])!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.nature_Green
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
