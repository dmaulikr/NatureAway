//
//  ListingsDetailViewController.swift
//  NatureAway
//
//  Created by Elaine Mao on 5/19/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class ListingsDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var listingHeadingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var listing: RentalListing?
    
    var pageImageViews = [UIImageView?]()
    var pageUrlStrings = [String]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        if let listing = listing {
            initPageControl()
            
            listingHeadingLabel.text = listing.heading
            descriptionLabel.text = listing.listingDescription

        }
    }
    
    func initPageControl() {
        if let listing = listing, largeUrlStrings = listing.largeUrlStrings where largeUrlStrings.count > 0 {
            
            pageUrlStrings = largeUrlStrings
            
            let pageCount = largeUrlStrings.count
            pageControl.currentPage = 0
            pageControl.numberOfPages = pageCount
            
            for _ in 0...pageCount-1 {
                let imageView = UIImageView()
                pageImageViews.append(imageView)
                scrollView.addSubview(imageView)
            }
            loadImages()
        }
    }
    
    func updatePageControl() {
        // Determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
    }
    
    func loadImages() {
        for (index, imageView) in enumerate(pageImageViews) {
            if let imageView = imageView {
                imageView.contentMode = .ScaleAspectFit
                imageView.clipsToBounds = true
                
                let url = NSURL(string: pageUrlStrings[index])!
                imageView.asyncLoadWithUrl(url)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        // Have to do this here so we know the true size of the scroll view
        for (index, imageView) in enumerate(pageImageViews) {
            if let imageView = imageView {
                var frame = scrollView.frame
                frame.origin.x = frame.size.width * CGFloat(index)
                frame.origin.y = 0.0
                imageView.frame = frame
            }
        }
        
        let pageCount = pageImageViews.count
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageCount), height: pagesScrollViewSize.height)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updatePageControl()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}