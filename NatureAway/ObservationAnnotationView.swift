//
//  ObservationAnnotationView.swift
//  NatureAway
//
//  Created by Chris Beale on 5/18/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit
import MapKit

protocol ObservationAnnotationViewDelegate : class {
    func annotationInfoSelected(observation: Observation)
}

class ObservationAnnotationView: MKAnnotationView {
    
    weak var delegate: ObservationAnnotationViewDelegate?

    // Required for MKAnnotationView
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Called when drawing the ObservationAnnotationView
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override init(annotation: MKAnnotation, reuseIdentifier: String) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let observation = self.annotation as! Observation
        if let taxonName = observation.iconicTaxonName {
            switch taxonName {
                case "Mammalia":
                    image = UIImage(named: "ic_mammals")
                case "Plantae":
                    image = UIImage(named: "ic_plants")
                case "Aves":
                    image = UIImage(named: "ic_birds")
                case "Reptilia":
                    image = UIImage(named: "ic_reptiles")
                case "Fungi":
                    image = UIImage(named: "ic_fungi")
                case "Arachnida":
                    image = UIImage(named: "ic_arachnids")
                case "Mollusca":
                    image = UIImage(named: "ic_mollusks")
                case "Amphibia":
                    image = UIImage(named: "ic_amphibians")
                default:
                    image = UIImage(named: "ic_insects")
            }
        }

        if let urlString = observation.firstSmallUrlString {
            var imageView = UIImageView(frame: CGRectMake(15, 0, 40, 40))
            if let url = NSURL(string: urlString) {
                imageView.asyncLoadWithUrl(url)
                imageView.contentMode = .ScaleAspectFit
                leftCalloutAccessoryView = imageView
            }
        }
        
        let infoButton = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIButton
        infoButton.addTarget(self, action: "infoButtonSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        rightCalloutAccessoryView = infoButton
    }
    
    func infoButtonSelected(sender: AnyObject) {
        // segue to detail view
        delegate?.annotationInfoSelected(self.annotation as! Observation)
    }
}
