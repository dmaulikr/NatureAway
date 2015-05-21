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
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "onImageTapped")
        observationImageView.addGestureRecognizer(tapGesture)
        observationImageView.userInteractionEnabled = true
        
        var selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.nature_Green
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onImageTapped() {
        var userInfo = [NSObject: AnyObject]()
        userInfo["index"] = tag
        NSNotificationCenter.defaultCenter().postNotificationName(observationImageTappedNotification, object: self, userInfo: userInfo)
    }

}
