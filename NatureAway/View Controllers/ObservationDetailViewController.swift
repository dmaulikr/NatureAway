//
//  ObservationDetailViewController.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/18/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class ObservationDetailViewController: UIViewController {
    
    var observation: Observation?

    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var speciesNameLabel: UILabel!
    
    @IBOutlet weak var observedOnLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerImageView.clipsToBounds = true
        
        if let observation = observation {
            if let urlString = observation.firstLargeUrlString, url = NSURL(string: urlString) {
                let imageRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 120)
                headerImageView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: nil, failure: nil)
            }
            
            commonNameLabel.text = observation.commonNameString
            speciesNameLabel.text = observation.nameString
            
            if let observedOnString = observation.observedOnString {
                observedOnLabel.text = "Observed on: " + observedOnString
            }
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
