//
//  GTNShippingItem.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/15/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNShippingItem: NSObject{
    
    open var sku: String = "";
    open var quantity: Int = 0;
    
    public init(sku skuS: String, quantity: Int) {
        super.init();
        self.sku = skuS;
        self.quantity = quantity;
    }
    
    func dict()->Dictionary<String, AnyObject>{
        return ["SKU" : self.sku as AnyObject, "Quantity" : self.quantity as AnyObject];
    }
}
