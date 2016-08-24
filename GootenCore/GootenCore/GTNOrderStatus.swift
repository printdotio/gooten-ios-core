//
//  GTNOrderStatus.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/18/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNOrderStatus: NSObject{
    
    public var id: String = "";
    public var niceId: String = "";
    public var sourceId: String = "";
    public var items: Array<GTNOrderStatusItem> = [];
    public var total: GTNPriceInfo = GTNPriceInfo();
    public var shippingTotal: GTNPriceInfo = GTNPriceInfo();
    public var shippingAddress: GTNAddress = GTNAddress();
    public var billingAddress: GTNAddress = GTNAddress();
    public var meta: Dictionary<String, AnyObject> = [:];
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject){
        if let idS = jsonObj["Id"] as? String { self.id = idS; }
        if let niceIdS = jsonObj["NiceId"] as? String { self.niceId = niceIdS; }
        if let sourceIdS = jsonObj["SourceId"] as? String { self.sourceId = sourceIdS; }
        if let totalObj = jsonObj["Total"], totalJson = totalObj { self.total = GTNPriceInfo(totalJson); }
        if let sTotalObj = jsonObj["ShippingTotal"], totalJson = sTotalObj { self.shippingTotal = GTNPriceInfo(totalJson); }
        if let sAddressObj = jsonObj["ShippingAddress"], sAddressJson = sAddressObj { self.shippingAddress = GTNAddress(sAddressJson); }
        if let bAddressObj = jsonObj["BillingAddress"], bAddressJson = bAddressObj { self.billingAddress = GTNAddress(bAddressJson); }
        if let metaS = jsonObj["Meta"] as? Dictionary<String, AnyObject> { self.meta = metaS; }
        
        if let items = jsonObj["Items"] as? Array<AnyObject> {
            for item in items {
                self.items.append(GTNOrderStatusItem(item));
            }
        }
    }
}