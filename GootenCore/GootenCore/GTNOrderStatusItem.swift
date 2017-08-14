//
//  GTNOrderItem.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/18/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNOrderStatusItem: NSObject{
    
    open var sku: String = "";
    open var productId: Int = 0;
    open var product: String = "";
    open var quantity: Int = 0;
    open var status: String = "";
    open var price: GTNPriceInfo = GTNPriceInfo();
    open var discountAmount: GTNPriceInfo = GTNPriceInfo();
    open var meta: Dictionary<String, AnyObject> = [:];
    open var shipments: Array<AnyObject> = []; // TO-DO !!!!!
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let skuS = jsonObj["Sku"] as? String { self.sku = skuS; }
        if let productIdS =  jsonObj["ProductId"] as? Int { self.productId = productIdS; }
        if let productS = jsonObj["Product"] as? String { self.product = productS; }
        if let quantityS = jsonObj["Quantity"] as? Int { self.quantity = quantityS; }
        if let statusS = jsonObj["Status"] as? String { self.status = statusS; }
        if let priceObj = jsonObj["Price"], let priceJson = priceObj { self.price = GTNPriceInfo(priceJson as AnyObject); }
        if let disObj = jsonObj["DiscountAmount"], let disJson = disObj { self.discountAmount = GTNPriceInfo(disJson as AnyObject); }
        if let metaS = jsonObj["Meta"] as? Dictionary<String, AnyObject> { self.meta = metaS; }
        // shipments TO-DO
    }
}
