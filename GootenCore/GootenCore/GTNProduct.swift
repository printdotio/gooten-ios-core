//
//  GTNProduct.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/5/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNProduct: NSObject{
    
    public var id: Int = -1;
    public var uId: String = "";
    public var name: String = "";
    public var shortDescription: String = "";
    
    public var hasAvailableProductVariants: Bool = false;
    public var hasProductTemplates: Bool = false;
    public var isFeatured: Bool = false;
    public var isComingSoon: Bool = false;
    
    public var maxZoom: Double = 1.0;
    
    public var retailPrice: GTNPriceInfo = GTNPriceInfo();
    public var priceInfo: GTNPriceInfo = GTNPriceInfo();
    
    public var info: Array<GTNProductInfo> = [];
    public var images: Array<GTNProductImage> = [];
    public var categories: Array<GTNProductCategory> = [];
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject) {
        if let idS = jsonObj["Id"] as? Int { self.id = idS; }
        if let uIdS = jsonObj["UId"] as? String { self.uId = uIdS; }
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let shortDescriptionS = jsonObj["ShortDescription"] as? String { self.shortDescription = shortDescriptionS; }
        if let hasAvailableProductVariantsS = jsonObj["HasAvailableProductVariants"] as? Bool { self.hasAvailableProductVariants = hasAvailableProductVariantsS; }
        if let hasProductTemplatesS = jsonObj["HasProductTemplates"] as? Bool { self.hasProductTemplates = hasProductTemplatesS; }
        if let isFeaturedS = jsonObj["IsFeatured"] as? Bool { self.isFeatured = isFeaturedS; }
        if let isComingSoonS = jsonObj["IsComingSoon"] as? Bool { self.isComingSoon = isComingSoonS; }
        if let maxZoomS = jsonObj["MaxZoom"] as? Double { self.maxZoom = maxZoomS; }
        if let retailPriceObj = jsonObj["RetailPrice"], let rpObj = retailPriceObj { self.retailPrice = GTNPriceInfo(rpObj); }
        
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
            self.priceInfo = GTNPriceInfo(pObj);
            
            if let categoriesArr = jsonObj["Categories"] as? [AnyObject] {
                for catObj in categoriesArr {
                    self.categories.append(GTNProductCategory(catObj));
                }
            }
        }
    }
}
