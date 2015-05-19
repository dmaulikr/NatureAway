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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        search("")
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
        INaturalistClient.sharedInstance.getSpecies(taxonName, completion: { (species: [Species]?, error: NSError?) -> Void in
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
                    gridCell.primaryLabel.text = singleSpecies.commonName
                    
                    if let squareUrlString = singleSpecies.squareUrlString {
                        let url = NSURL(string: squareUrlString)
                        gridCell.primaryImageView.setImageWithURL(url)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? UICollectionViewCell, indexPath = collectionView.indexPathForCell(cell), tabController = segue.destinationViewController as? ObservationTabController, species = species {
            let selectedSpecies = species[indexPath.row]
            tabController.species = selectedSpecies
        }
    }
}
