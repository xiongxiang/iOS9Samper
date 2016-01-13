//
//  MapCustomizationsViewController.swift
//  iOS9Sampler
//
//  Created by Shuichi Tsutsumi on 8/26/15.
//  Copyright © 2015 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapCustomizationsViewController: UIViewController,
        MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {


    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var compassBtn: UIButton!

    let locationManager = CLLocationManager()

    var searchController: UISearchController!
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    /*
    // Program add segmented controller
    override func loadView() {
        super.loadView()

        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybird", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)

        //: Manual constrain to the segmentedControl
        let topConstrain = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        let matgins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(matgins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(matgins.trailingAnchor)

        topConstrain.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        let chengduRegion = MKCoordinateRegionMake(
            CLLocationCoordinate2DMake(30.548858,104.0709858),
            MKCoordinateSpanMake(0.176615416273734, 0.153035815736018))
        mapView.setRegion(chengduRegion, animated: true)

        self.setupMapCamera()
        self.updateCompassBtn()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .Plain, target: self, action: "showSearchBar:")

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingHeading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }

    // MAKR: UISearchBar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)

        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }

        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler {
            (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)


            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }

    // MAKR: cllocation delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)

        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))

        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }

    // MARK: segmented callback
    func mapTypeChanged(segmentControl: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }

    private func setupMapCamera() {
        
        mapView.camera.altitude = 14000
        mapView.camera.pitch = 50
        mapView.camera.heading = 180
    }

    private func updateCompassBtn() {
        
        // shown
        if mapView.showsCompass {
            compassBtn.setTitle("Hide Compass", forState: UIControlState.Normal)
        }
        // hidden
        else {
            compassBtn.setTitle("Show Compass", forState: UIControlState.Normal)
        }
    }

    
    // =========================================================================
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print(__FUNCTION__+"\n")
    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
    }
    
    
    
    // =========================================================================
    // MARK: - Actions
    
    @IBAction func trafficBtnTapped(sender: UIButton) {

        mapView.showsTraffic = !mapView.showsTraffic

        // shown
        if mapView.showsTraffic {
            sender.setTitle("Hide Traffic", forState: UIControlState.Normal)
        }
        // hidden
        else {
            sender.setTitle("Show Traffic", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func scaleBtnTapped(sender: UIButton) {

        mapView.showsScale = !mapView.showsScale

        // shown
        if mapView.showsScale {
            sender.setTitle("Hide Scale", forState: UIControlState.Normal)
        }
        // hidden
        else {
            sender.setTitle("Show Scale", forState: UIControlState.Normal)
        }
    }

    @IBAction func compassBtnTapped(sender: UIButton) {
        
        mapView.showsCompass = !mapView.showsCompass
        
        self.updateCompassBtn()
    }

    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            mapView.mapType = MKMapType.SatelliteFlyover
        case 2:
            mapView.mapType = MKMapType.HybridFlyover
        default:
            mapView.mapType = MKMapType.Standard
        }
        
        self.setupMapCamera()
    }
}
