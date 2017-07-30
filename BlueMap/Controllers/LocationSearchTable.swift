//
//  LocationSearchTable.swift
//  BlueMap
//
//  Created by Vinh on 7/26/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    
    weak var handleMapSearchDelegate: HandleMapSearch?
    var searchItems: [PlaceModel] = []
    var parentView: UIViewController?

    
    func initializeDataSource( key: String) -> ZServiceDataSource {
        let dataSource: ZServiceDataSource = ZServiceDataSource()
        var category   = UserDefaults.standard.string(forKey: "category")
        if (category == nil) {
           category = ""
        }
        var query : String! = ""
        query = "?q=" + key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "&category=" + category!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        dataSource.url = API.BASE_URL + "api/getSearch" + query
        dataSource.method = .GET
        dataSource.headers = [ TEXT.API_KEY: API.KEY ]
        return dataSource
    }
}

extension LocationSearchTable : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ZServiceManager.request(self.initializeDataSource(key: searchBarText)) { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let _response = response.response as? Array<Any> else { return }
            self.searchItems.removeAll()
            for data in _response   {
                guard let _data = data as? [String : Any] else { return  }
                let place = PlaceModel(JSON: _data  )
                self.searchItems.append(place!)
            }
            self.tableView.reloadData()
            
            // update listPlace at MapViewController
            guard let _mapView = self.parentView as? MapViewController else { return }
            _mapView.listPlace = self.searchItems            
        }
    }
}

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "identifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        let selectedItem = searchItems[indexPath.row]
        cell?.textLabel?.text = selectedItem.title
        cell?.detailTextLabel?.text = selectedItem.address
        return cell!
    }
}

extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = searchItems[indexPath.row]
        handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

