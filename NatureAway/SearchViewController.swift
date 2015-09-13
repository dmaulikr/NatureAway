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
    
    var species: [Species]?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        search("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let taxonName = searchBar.text {
         search(taxonName)
        }
    }
    
    func search(taxonName: String) {
        INaturalistClient.sharedInstance.getSpecies(taxonName, completion: { (species: [Species]?, error: NSError?) -> Void in
            self.activityIndicator.stopAnimating()
            if let species = species  {
                self.species = species
                self.collectionView.reloadData()
            }
        })
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let gridCell = collectionView.dequeueReusableCellWithReuseIdentifier("GridCell", forIndexPath: indexPath) as? GridCell {
            if let species = species {
                if species.count > indexPath.row {
                    let singleSpecies = species[indexPath.row]
                    gridCell.primaryLabel.text = singleSpecies.primaryName
                    
                    if let squareUrlString = singleSpecies.squareUrlString, let url = NSURL(string: squareUrlString) {
                        let imageRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 120)
                        gridCell.primaryImageView.asyncLoadWithUrlRequest(imageRequest)
                    }
                }
            }
            return gridCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let species = self.species {
            return species.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionHeaderView", forIndexPath: indexPath) as! CollectionHeaderView
            return headerView
        }
        return UICollectionReusableView()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UICollectionViewCell, indexPath = collectionView.indexPathForCell(cell), tabController = segue.destinationViewController as? ObservationTabController, species = species {
            let selectedSpecies = species[indexPath.row]
            tabController.species = selectedSpecies
        }
    }
}

