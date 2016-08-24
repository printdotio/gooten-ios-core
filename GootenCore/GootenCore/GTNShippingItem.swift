//
//  GTNShippingItem.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/15/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNShippingItem: NSObject{
    
    public var sku: String = "";
    public var quantity: Int = 0;
    
    public init(sku skuS: String, quantity: Int) {
        super.init();
        self.sku = skuS;
        self.quantity = quantity;
    }
    
    func dict()->Dictionary<String, AnyObject>{
        return ["SKU" : self.sku, "Quantity" : self.quantity];
    }
}