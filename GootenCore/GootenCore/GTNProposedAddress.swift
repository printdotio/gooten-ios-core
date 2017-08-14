//
//  GTNProposedAddress.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/21/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNProposedAddress: NSObject {

    open var city: String = "";
    open var countryCode: String = "";
    open var postalCode: String = "";
    open var stateOrProvinceCode: String = "";
    open var streetLines: [String] = [];
    
    public override init() {
        super.init();
    }
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let cityS = jsonObj["City"] as? String { self.city = cityS; }
        if let countryCodeS = jsonObj["CountryCode"] as? String { self.countryCode = countryCodeS; }
        if let postalCodeS = jsonObj["PostalCode"] as? String { self.postalCode = postalCodeS; }
        if let stateOrProvinceCodeS = jsonObj["StateOrProvinceCode"] as? String { self.stateOrProvinceCode = stateOrProvinceCodeS; }
        
        if let streetLinesObj = jsonObj["StreetLines"] as? [String] {
            streetLines.append(contentsOf: streetLinesObj);
        }
    }
}
