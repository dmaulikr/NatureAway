//
//  ObservationDetailViewController.swift
//  NatureAway
//
//  Created by Raul Agrait on 5/18/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit

class ObservationDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var observation: Observation?

    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var speciesNameLabel: UILabel!
    
    @IBOutlet weak var observedOnLabel: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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

        if let observation = observation {
            initPageControl()
            
            commonNameLabel.text = observation.commonNameString
            speciesNameLabel.text = observation.nameString
            
            if let observedOnString = observation.observedOnString {
                observedOnLabel.text = "Observed on: " + observedOnString
            }
        }
    }
    
    func initPageControl() {
        if let observation = observation, largeUrlStrings = observation.largeUrlStrings where largeUrlStrings.count > 0 {
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
