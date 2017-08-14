//
//  GTNOrderItem.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/22/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNOrderItem: NSObject {

    open var sku: String = ""
    open var quantity: Int = 0
    open var shipCarrierMethod: Int = 0
    open var meta: Dictionary<String, String> = [:]
    open var images: Array<GTNOrderItemImage> = []
    
    public init(sku: String, quantity: Int, shipCarrierMethod: Int, images: [GTNOrderItemImage], meta: [String:String]) {
        super.init()
        self.sku = sku
        self.quantity = quantity
        self.shipCarrierMethod = shipCarrierMethod
        self.images = images
        self.meta = meta
    }
    
    func elements()->[String:Any]{
        // create images array
        var imagesArr: [Any] = [];
        for image in images {
            imagesArr.append(image.elements());
        }
        
        return ["Quantity" : String(quantity),
                "SKU" : sku,
                "ShipCarrierMethodId" : String(shipCarrierMethod),
                "Images" : imagesArr,
                "Meta" : meta]
    }
}
