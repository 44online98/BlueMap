//
//  CategoryModel.swift
//  BlueMap
//
//  Created by Vinh on 7/26/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import Foundation
import ObjectMapper

class CategoryModel: RESTResponse {
    
    var id     = ""
    var name   = ""
    var slug   = ""
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    required override init() {} // require init super class  Mappable
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.id          <- map["id"]
        self.name        <- map["name"]
        self.slug        <- map["slug"]
        
    }
}
