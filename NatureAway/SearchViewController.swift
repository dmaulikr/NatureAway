//
//  ViewController.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/13/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var observations: [Observation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        var taxonName = searchBar.text
        search(taxonName)
    }
    
    func search(taxonName: String) {
        INaturalistClient.sharedInstance.getObservations(taxonName, completion: { (observations: [Observation]?, error: NSError?) -> Void in
            if let observations = observations {
                var photoCount = 0
                var initialY = self.searchBar.frame.maxY
                for observation in observations {
                    if let urlStrings = observation.smallUrlStrings {
                        for urlString in urlStrings {
                            var imageY = CGFloat(photoCount) * 100.0 + initialY
                            var imageView = UIImageView(frame: CGRect(x: 0, y: imageY, width: 100, height: 100))
                            imageView.backgroundColor = UIColor.blackColor()
                            self.view.addSubview(imageView)
                            imageView.setImageWithURL(NSURL(string: urlString))
                            photoCount++
                        }
                    }
                }
            }
        })
    }
}

