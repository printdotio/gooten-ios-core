//
//  GTNOrderStatus.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/18/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNOrderStatus: NSObject{
    
    open var id: String = "";
    open var niceId: String = "";
    open var sourceId: String = "";
    open var items: Array<GTNOrderStatusItem> = [];
    open var total: GTNPriceInfo = GTNPriceInfo();
    open var shippingTotal: GTNPriceInfo = GTNPriceInfo();
    open var shippingAddress: GTNAddress = GTNAddress();
    open var billingAddress: GTNAddress = GTNAddress();
    open var meta: Dictionary<String, AnyObject> = [:];
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let idS = jsonObj["Id"] as? String { self.id = idS; }
        if let niceIdS = jsonObj["NiceId"] as? String { self.niceId = niceIdS; }
        if let sourceIdS = jsonObj["SourceId"] as? String { self.sourceId = sourceIdS; }
        if let totalObj = jsonObj["Total"] { self.total = GTNPriceInfo(totalObj as AnyObject); }
        if let sTotalObj = jsonObj["ShippingTotal"] { self.shippingTotal = GTNPriceInfo(sTotalObj as AnyObject); }
        if let sAddressObj = jsonObj["ShippingAddress"] { self.shippingAddress = GTNAddress(sAddressObj as AnyObject); }
        if let bAddressObj = jsonObj["BillingAddress"] { self.billingAddress = GTNAddress(bAddressObj as AnyObject); }
        if let metaS = jsonObj["Meta"] as? Dictionary<String, AnyObject> { self.meta = metaS; }
        
        if let items = jsonObj["Items"] as? Array<AnyObject> {
            for item in items {
                self.items.append(GTNOrderStatusItem(item));
            }
        }
    }
}
