//
//  ObservationCell.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/15/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class ObservationCell: UITableViewCell {

    @IBOutlet weak var observationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
