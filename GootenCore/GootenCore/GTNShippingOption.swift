//
//  GTNShippingPrice.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/15/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNShippingOption: NSObject{
    
    public var skus: Array<String> = [];
    public var shipOptions: Array<GTNSingleShipOption> = [];
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject) {
        if let skusObj = jsonObj["SKUs"] as? Array<String> { self.skus = skusObj };
        
        if let shipOptionsObj = jsonObj["ShipOptions"] as? Array<AnyObject> {
            for shipOptionObj in shipOptionsObj{
                self.shipOptions.append(GTNSingleShipOption(shipOptionObj));
            }
        }
    }
}