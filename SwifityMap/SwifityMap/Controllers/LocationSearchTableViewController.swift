//
//  LocationSearchTableViewController.swift
//  SwifityMap
//
//  Created by Felicien RENAUD on 4/5/19.
//  Copyright © 2019 Felicien RENAUD. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController, UISearchResultsUpdating{

    var matchingItems : [MKMapItem] = []
    var mapView : MKMapView?
    var handleMapSearchDelegate : HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: { ( response, _) in
            guard let response = response else { return }
            print("Got response : \(response)")
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let selectedItem = matchingItems[indexPath.row].placemark
        cell?.textLabel?.text = selectedItem.name
        cell?.detailTextLabel?.text = ""
        return cell!
    }
  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}
