//
//  ViewController.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/13/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        INaturalistClient.sharedInstance.getObservations { (observations: [Observation]?, error: NSError?) -> Void in
            if let observations = observations {
                var photoCount = 0
                for observation in observations {
                    if let largeUrlStrings = observation.largeUrlStrings {
                        for urlString in largeUrlStrings {
                            var imageView = UIImageView(frame: CGRect(x: 0, y:photoCount*100, width: 100, height: 100))
                            imageView.backgroundColor = UIColor.blackColor()
                            self.view.addSubview(imageView)
                            imageView.setImageWithURL(NSURL(string: urlString))
                            photoCount++
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

