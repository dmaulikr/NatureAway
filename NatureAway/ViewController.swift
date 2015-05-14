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
        INaturalistClient.sharedInstance.getObservations { (response, error) -> Void in
            println(response)
            if let response = response, photos = response["photos"] as? [NSDictionary] {
                if photos.count > 0 {
                    for (index, photo) in enumerate(photos) {
                        var imageView = UIImageView(frame: CGRect(x: 0, y:index*200, width: 200, height: 200))
                        imageView.backgroundColor = UIColor.blackColor()
                        self.view.addSubview(imageView)
                        if let urlString = photo["large_url"] as? String {
                            imageView.setImageWithURL(NSURL(string: urlString))
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

