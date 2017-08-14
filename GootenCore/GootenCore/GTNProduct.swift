//
//  GTNProduct.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/5/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNProduct: NSObject{
    
    open var id: Int = -1;
    open var uId: String = "";
    open var name: String = "";
    open var shortDescription: String = "";
    
    open var hasAvailableProductVariants: Bool = false;
    open var hasProductTemplates: Bool = false;
    open var isFeatured: Bool = false;
    open var isComingSoon: Bool = false;
    
    open var maxZoom: Double = 1.0;
    
    open var retailPrice: GTNPriceInfo = GTNPriceInfo();
    open var priceInfo: GTNPriceInfo = GTNPriceInfo();
    
    open var info: Array<GTNProductInfo> = [];
    open var images: Array<GTNProductImage> = [];
    open var categories: Array<GTNProductCategory> = [];
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject) {
        if let idS = jsonObj["Id"] as? Int { self.id = idS; }
        if let uIdS = jsonObj["UId"] as? String { self.uId = uIdS; }
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let shortDescriptionS = jsonObj["ShortDescription"] as? String { self.shortDescription = shortDescriptionS; }
        if let hasAvailableProductVariantsS = jsonObj["HasAvailableProductVariants"] as? Bool { self.hasAvailableProductVariants = hasAvailableProductVariantsS; }
        if let hasProductTemplatesS = jsonObj["HasProductTemplates"] as? Bool { self.hasProductTemplates = hasProductTemplatesS; }
        if let isFeaturedS = jsonObj["IsFeatured"] as? Bool { self.isFeatured = isFeaturedS; }
        if let isComingSoonS = jsonObj["IsComingSoon"] as? Bool { self.isComingSoon = isComingSoonS; }
        if let maxZoomS = jsonObj["MaxZoom"] as? Double { self.maxZoom = maxZoomS; }
        if let retailPriceObj = jsonObj["RetailPrice"], let rpObj = retailPriceObj { self.retailPrice = GTNPriceInfo(rpObj as AnyObject); }
        
        if let infoArr = jsonObj["Info"] as? [AnyObject] {
            for infoObj in infoArr {
                self.info.append(GTNProductInfo(infoObj));
            }
        }
        
        if let imagesArr = jsonObj["Images"] as? [AnyObject] {
            for imageObj in imagesArr {
                self.images.append(GTNProductImage(imageObj));
            }
        }
        
        if let priceObj = jsonObj["PriceInfo"],let pObj = priceObj {
            self.priceInfo = GTNPriceInfo(pObj as AnyObject);
            
            if let categoriesArr = jsonObj["Categories"] as? [AnyObject] {
                for catObj in categoriesArr {
                    self.categories.append(GTNProductCategory(catObj));
                }
            }
        }
    }
}
