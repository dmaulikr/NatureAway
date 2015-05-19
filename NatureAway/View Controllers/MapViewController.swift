//
//  MapViewController.swift
//  NatureAway
//
//  Created by Chris Beale on 5/18/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, ObservationTab, MKMapViewDelegate, ObservationAnnotationViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var observations: [Observation]? {
        willSet {
            mapView?.removeAnnotations(observations)
        }
        didSet {
            setupMap()
        }
    }
    var listings: [RentalListing]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }

    func setupMap() {
        // Do any additional setup after loading the view.
        if let observations = observations, mapView = mapView {
            mapView.delegate = self
            mapView.addAnnotations(observations)
            mapView.showsUserLocation = true
            if mapView.userLocation.location != nil {
                mapView.centerCoordinate = mapView.userLocation.location.coordinate
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation
        userLocation: MKUserLocation!) {
            mapView.centerCoordinate = userLocation.location.coordinate
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

        if let observation = annotation as? Observation {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("Observation")
            if annotationView == nil {
                annotationView = ObservationAnnotationView(annotation: annotation, reuseIdentifier: "Observation")
                (annotationView as! ObservationAnnotationView).delegate = self
                annotationView.canShowCallout = true
            } else {
                annotationView.annotation = annotation
            }
            return annotationView
        } else if let observation = annotation as? RentalListing {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("Listing")
            if annotationView == nil {
                annotationView = ListingAnnotationView(annotation: annotation, reuseIdentifier: "Listing")
                annotationView.canShowCallout = true
            } else {
                annotationView.annotation = annotation
            }
            return annotationView
        } else {
            return nil
        }
    }
    
    func annotationInfoSelected(observation: Observation) {

        var viewController = ObservationDetailViewController(nibName: "ObservationDetailViewController", bundle: nil)
        viewController.observation = observation
        self.navigationController?.pushViewController(viewController, animated: true)
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
