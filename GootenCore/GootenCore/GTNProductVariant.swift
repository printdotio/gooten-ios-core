//
//  GTNProductVariant.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/13/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNProductVariant: NSObject{
    
    open var options: Array<GTNVariantOption> = [];
    open var priceInfo: GTNPriceInfo = GTNPriceInfo();
    open var sku: String = "";
    open var maxImages: Int = 0;
    open var hasTemplates: Bool = false;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject) {
        if let optionsArr = jsonObj["Options"] as? [AnyObject] {
            for optionObj in optionsArr {
                self.options.append(GTNVariantOption(optionObj));
            }
        }
        
        if let priceInfoObj = jsonObj["PriceInfo"] {
            self.priceInfo = GTNPriceInfo(priceInfoObj as AnyObject);
        }
        
        if let skuS = jsonObj["Sku"] as? String { self.sku = skuS; }
        if let indexS = jsonObj["MaxImages"] as? Int { self.maxImages = indexS; }
        if let hasTemplatesS = jsonObj["HasTemplates"] as? Bool { self.hasTemplates = hasTemplatesS; }
    }
}
