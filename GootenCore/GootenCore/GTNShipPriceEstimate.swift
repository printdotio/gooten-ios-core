//
//  GTNShipPriceEstimate.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/15/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNShipPriceEstimate: NSObject {

    open var minPrice: GTNPriceInfo = GTNPriceInfo();
    open var maxPrice: GTNPriceInfo = GTNPriceInfo();
    open var vendorCountryCode: String = "";
    open var canShipExpedited: Bool = false;
    open var estShipDays: Int = 0;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject) {
        if let minPriceObj = jsonObj["MinPrice"]{
            self.minPrice = GTNPriceInfo(minPriceObj as AnyObject);
        }
        
        if let maxPriceObj = jsonObj["MaxPrice"]{
            self.maxPrice = GTNPriceInfo(maxPriceObj as AnyObject);
        }
        
        if let vendorCountryCodeS = jsonObj["VendorCountryCode"] as? String { self.vendorCountryCode = vendorCountryCodeS };
        if let canShipExpeditedS = jsonObj["CanShipExpedited"] as? Bool { self.canShipExpedited = canShipExpeditedS };
        if let estShipDaysS = jsonObj["EstShipDays"] as? Int { self.estShipDays = estShipDaysS };
    }
}


