//
//  ViewController.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/13/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    
    var observations: [Observation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self

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
                self.observations = observations
                self.collectionView.reloadData()
            }
        })
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let gridCell = collectionView.dequeueReusableCellWithReuseIdentifier("GridCell", forIndexPath: indexPath) as? GridCell {
            if let observations = observations {
                if observations.count > indexPath.row {
                    let observation = observations[indexPath.row]
                    gridCell.primaryLabel.text = observation.commonNameString
                    
                    // TODO: Make Observation.firstSmallUrlString or something like that
                    if let smallUrlStrings = observation.smallUrlStrings {
                        if smallUrlStrings.count > 0 {
                            let smallUrlString = smallUrlStrings[0]
                            let url = NSURL(string: smallUrlString)
                            gridCell.primaryImageView.setImageWithURL(url)
                        }
                    }
                }
            }
            return gridCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let observations = self.observations {
            return observations.count
        }
        return 0
    }
}

