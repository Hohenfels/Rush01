//
//  ViewController.swift
//  SwifityMap
//
//  Created by Felicien RENAUD on 4/5/19.
//  Copyright © 2019 Felicien RENAUD. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, HandleMapSearch {

    @IBOutlet weak var mapView : MKMapView!
    let locationManager = CLLocationManager()
    var resultSearchController : UISearchController? = nil
    var selectedPin : MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        
        definesPresentationContext = true
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Rechercher une adresse"
        navigationItem.titleView = resultSearchController?.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /* Location manager protocol */
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Current location: \(location)")
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    /* Handle Map Search protocol */
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if  let city = placemark.locality,
            let state = placemark.administrativeArea {
            print("City: \(city), state: \(state)")
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}

