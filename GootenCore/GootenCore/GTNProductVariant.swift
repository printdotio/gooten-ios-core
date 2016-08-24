//
//  GTNProductVariant.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/13/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNProductVariant: NSObject{
    
    public var options: Array<GTNVariantOption> = [];
    public var priceInfo: GTNPriceInfo = GTNPriceInfo();
    public var sku: String = "";
    public var maxImages: Int = 0;
    public var hasTemplates: Bool = false;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject) {
        if let optionsArr = jsonObj["Options"] as? [AnyObject] {
            for optionObj in optionsArr {
                self.options.append(GTNVariantOption(optionObj));
            }
        }
        
        if let priceInfoObj = jsonObj["PriceInfo"], priceInfoS = priceInfoObj {
            self.priceInfo = GTNPriceInfo(priceInfoS);
        }
        
        if let skuS = jsonObj["Sku"] as? String { self.sku = skuS; }
        if let indexS = jsonObj["MaxImages"] as? Int { self.maxImages = indexS; }
        if let hasTemplatesS = jsonObj["HasTemplates"] as? Bool { self.hasTemplates = hasTemplatesS; }
    }
}
