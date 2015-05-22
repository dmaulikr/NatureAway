//
//  MapViewController.swift
//  NatureAway
//
//  Created by Chris Beale on 5/18/15.
//  Copyright (c) 2015 rateva. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate : class {
    func searchAreaUpdated(center: CLLocationCoordinate2D, radius: Double)
}

class MapViewController: UIViewController, ObservationTab, MKMapViewDelegate, ObservationAnnotationViewDelegate, UISearchBarDelegate {

    var searchRadiusCircle: MKCircle?

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    private var geocoder: CLGeocoder?
    private var searchRadius: Double {
        get {
            // Convert slider miles to meters
            return Double(slider.value) * 1600
        }
    }
    var currentLocation: CLLocationCoordinate2D?
    
    weak var delegate: MapViewControllerDelegate?
    
    private var observations: [Observation]? {
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
        mapView.delegate = self
        mapView.showsUserLocation = true
        if let currentLocation = self.currentLocation {
            searchRadiusCircle = MKCircle(centerCoordinate: mapView.centerCoordinate, radius: searchRadius)
            mapView.addOverlay(searchRadiusCircle);
            let region = MKCoordinateRegionMakeWithDistance(currentLocation, searchRadius, 3 * searchRadius)
            self.mapView.setRegion(region, animated: true)
        }
        searchBar.delegate = self
        geocoder = CLGeocoder()
        setupMap()
    }

    func setupMap() {
        // Do any additional setup after loading the view.
        if let observations = observations, mapView = mapView {
            mapView.addAnnotations(observations)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(sender: AnyObject) {
        mapView.removeOverlay(searchRadiusCircle)
        searchRadiusCircle = MKCircle(centerCoordinate: mapView.centerCoordinate, radius: searchRadius)
        mapView.addOverlay(searchRadiusCircle)
    }
    
    @IBAction func searchClicked(sender: AnyObject) {
        updateSearchArea(mapView.centerCoordinate)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var location = searchBar.text
        geocoder?.geocodeAddressString(location
            , completionHandler: { (result: [AnyObject]!, error: NSError!) -> Void in
                if error != nil {
                    println("error geocoding addresss")
                    return
                }
                
                if result.count > 0 {
                    let placemark = result[0] as! CLPlacemark
                    self.updateSearchArea(placemark.location.coordinate)
                }
                
        })
    }
    
    private func updateSearchArea(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(center, searchRadius, 2 * searchRadius)
        self.mapView.setRegion(region, animated: true)
        mapView?.removeAnnotations(observations)
        self.delegate?.searchAreaUpdated(center, radius: searchRadius)
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        mapView.removeOverlay(searchRadiusCircle)
        searchRadiusCircle = MKCircle(centerCoordinate: mapView.centerCoordinate, radius: searchRadius)
        mapView.addOverlay(searchRadiusCircle)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay is MKCircle) {
            var pr = MKCircleRenderer(overlay: overlay);
            pr.fillColor = UIColor.nature_Green.colorWithAlphaComponent(0.1);
            return pr;
        }
        
        return nil
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
                if let observationView = annotationView as? ObservationAnnotationView {
                    observationView.setObservation(observation)
                }
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
    
    func addObservations(observations: [Observation]) {
        self.observations = observations
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
