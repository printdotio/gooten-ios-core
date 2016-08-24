//
//  GTNProposedAddress.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/21/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNProposedAddress: NSObject {

    public var city: String = "";
    public var countryCode: String = "";
    public var postalCode: String = "";
    public var stateOrProvinceCode: String = "";
    public var streetLines: [String] = [];
    
    override init() {
        
    }
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject){
        if let cityS = jsonObj["City"] as? String { self.city = cityS; }
        if let countryCodeS = jsonObj["CountryCode"] as? String { self.countryCode = countryCodeS; }
        if let postalCodeS = jsonObj["PostalCode"] as? String { self.postalCode = postalCodeS; }
        if let stateOrProvinceCodeS = jsonObj["StateOrProvinceCode"] as? String { self.stateOrProvinceCode = stateOrProvinceCodeS; }
        
        if let streetLinesObj = jsonObj["StreetLines"] as? [String] {
            streetLines.appendContentsOf(streetLinesObj);
        }
    }
}