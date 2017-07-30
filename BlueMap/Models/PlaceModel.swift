//
//  PlaceModel.swift
//  BlueMap
//
//  Created by Vinh on 7/1/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import Foundation
import ObjectMapper

class PlaceModel: RESTResponse {

    var id          = 0
    var type_id     = ""
    var address     = ""
    var icon        = ""
    var lat         = ""
    var lng         = ""
    var phone       = ""
    var slug        = ""
    var thumb       = ""
    var title       = ""
    var create_at   = CreateAtModel()
    var description = ""
    var summary     = ""
    var viewed      = ""
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    required override init() {} // require init super class  Mappable

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.id             <- map["id"]
        self.type_id        <- map["type_id"]
        self.address        <- map["address"]
        self.icon           <- map["icon"]
        self.lat            <- map["lat"]
        self.lng            <- map["lng"]
        self.phone          <- map["phone"]
        self.slug           <- map["slug"]
        self.thumb          <- map["thumb"]
        self.title          <- map["title"]
        self.create_at      <- map["create_at"]
        self.description    <- map["description"]
        self.summary        <- map["summary"]
        self.viewed         <- map["viewed"]
    }
}

class CreateAtModel: RESTResponse {
    
    var date            = ""
    var timezone        = ""
    var timezone_type   = ""
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    required override init() {} // require init super class  Mappable
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.date               <- map["date"]
        self.timezone           <- map["timezone"]
        self.timezone_type      <- map["timezone_type"]
    }
}
