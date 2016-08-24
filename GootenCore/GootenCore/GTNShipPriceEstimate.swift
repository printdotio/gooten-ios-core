//
//  GTNShipPriceEstimate.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/15/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNShipPriceEstimate: NSObject {

    public var minPrice: GTNPriceInfo = GTNPriceInfo();
    public var maxPrice: GTNPriceInfo = GTNPriceInfo();
    public var vendorCountryCode: String = "";
    public var canShipExpedited: Bool = false;
    public var estShipDays: Int = 0;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject) {
        if let minPriceObj = jsonObj["MinPrice"], minPriceJson = minPriceObj{
            self.minPrice = GTNPriceInfo(minPriceJson);
        }
        
        if let maxPriceObj = jsonObj["MaxPrice"], maxPriceJson = maxPriceObj{
            self.maxPrice = GTNPriceInfo(maxPriceJson);
        }
        
        if let vendorCountryCodeS = jsonObj["VendorCountryCode"] as? String { self.vendorCountryCode = vendorCountryCodeS };
        if let canShipExpeditedS = jsonObj["CanShipExpedited"] as? Bool { self.canShipExpedited = canShipExpeditedS };
        if let estShipDaysS = jsonObj["EstShipDays"] as? Int { self.estShipDays = estShipDaysS };
    }
}


