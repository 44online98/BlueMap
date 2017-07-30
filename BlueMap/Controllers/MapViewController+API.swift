//
//  MapViewController+API.swift
//  BlueMap
//
//  Created by Vinh on 7/27/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import Foundation

// MARK: - Request API
extension MapViewController{
    
    func initializeDataSourceListCharities() -> ZServiceDataSource {
        let dataSource: ZServiceDataSource = ZServiceDataSource()
        dataSource.url = API.BASE_URL + "api/getListCharities"
        dataSource.method = .GET
        dataSource.headers = [ TEXT.API_KEY: API.KEY ]
        return dataSource
    }
    
    func initializeDataSourceListCategories() -> ZServiceDataSource {
        let dataSource: ZServiceDataSource = ZServiceDataSource()
        dataSource.url = API.BASE_URL + "api/getListCategories"
        dataSource.method = .GET
        dataSource.headers = [ TEXT.API_KEY: API.KEY ]
        return dataSource
    }
    
    func requestAPIGetListCharities(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ZServiceManager.request(self.initializeDataSourceListCharities()) { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let _response = response.response as? Array<Any> else { return }
            for data in _response   {
                guard let _data = data as? [String : Any] else { return  }
                let place = PlaceModel(JSON: _data  )
                self.listPlace.append(place!)
            }
            self.updateLayout(listPlace: self.listPlace)
        }
    }
    
    func requestAPIGetListCategories (){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ZServiceManager.request(self.initializeDataSourceListCategories()) { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let _response = response.response as? Array<Any> else { return }
            for data in _response   {
                guard let _data = data as? [String : Any] else { return  }
                let place = CategoryModel(JSON: _data  )
                self.listCategory.append(place!)
            }
        }
    }
}
