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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
