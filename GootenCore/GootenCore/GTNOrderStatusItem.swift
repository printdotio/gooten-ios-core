//
//  GTNOrderItem.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/18/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNOrderStatusItem: NSObject{
    
    public var sku: String = "";
    public var productId: Int = 0;
    public var product: String = "";
    public var quantity: Int = 0;
    public var status: String = "";
    public var price: GTNPriceInfo = GTNPriceInfo();
    public var discountAmount: GTNPriceInfo = GTNPriceInfo();
    public var meta: Dictionary<String, AnyObject> = [:];
    public var shipments: Array<AnyObject> = []; // TO-DO !!!!!
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject){
        if let skuS = jsonObj["Sku"] as? String { self.sku = skuS; }
        if let productIdS =  jsonObj["ProductId"] as? Int { self.productId = productIdS; }
        if let productS = jsonObj["Product"] as? String { self.product = productS; }
        if let quantityS = jsonObj["Quantity"] as? Int { self.quantity = quantityS; }
        if let statusS = jsonObj["Status"] as? String { self.status = statusS; }
        if let priceObj = jsonObj["Price"], priceJson = priceObj { self.price = GTNPriceInfo(priceJson); }
        if let disObj = jsonObj["DiscountAmount"], disJson = disObj { self.discountAmount = GTNPriceInfo(disJson); }
        if let metaS = jsonObj["Meta"] as? Dictionary<String, AnyObject> { self.meta = metaS; }
        // shipments TO-DO
    }
}