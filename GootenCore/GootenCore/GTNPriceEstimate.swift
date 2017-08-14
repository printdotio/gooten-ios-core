//
//  GTNPriceEstimate.swift
//  GootenCore
//
//  Created by Boro Perisic on 8/14/17.
//  Copyright © 2017 Gooten. All rights reserved.
//

import Foundation

open class GTNPriceEstimate: NSObject {
    
    open var items: GTNPriceInfo = GTNPriceInfo();
    open var shipping: GTNPriceInfo = GTNPriceInfo();
    open var tax: GTNPriceInfo = GTNPriceInfo();
    open var hadCouponApply: Bool = false;
    open var hadError: Bool = false;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject) {
        if let itemsObj = jsonObj["Items"]{
            self.items = GTNPriceInfo(itemsObj as AnyObject);
        }
        if let shippingObj = jsonObj["Shipping"]{
            self.shipping = GTNPriceInfo(shippingObj as AnyObject);
        }
        if let taxObj = jsonObj["Tax"]{
            self.tax = GTNPriceInfo(taxObj as AnyObject);
        }
        if let hadCouponApplyObj = jsonObj["HadCouponApply"] {
            self.hadCouponApply = hadCouponApplyObj as! Bool;
        }
        if let hadErrorObj = jsonObj["HadError"] {
            self.hadError = hadErrorObj as! Bool;
        }
    }
}
