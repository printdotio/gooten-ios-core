//
//  GTNVariantOption.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/13/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNVariantOption: NSObject{
    
    open var optionId: String = "";
    open var valueId: String = "";
    open var name: String = "";
    open var value: String = "";
    
    open var imageUrl: String = "";
    open var imageType: String = "";
    open var sortValue: Int = 0;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject) {
        
        if let optionIdS = jsonObj["OptionId"] as? String { self.optionId = optionIdS; }
        if let valueIdS = jsonObj["ValueId"] as? String { self.valueId = valueIdS; }
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let valueS = jsonObj["Value"] as? String { self.value = valueS; }
        if let imageUrlS = jsonObj["ImageUrl"] as? String { self.imageUrl = imageUrlS; }
        if let imageTypeS = jsonObj["ImageType"] as? String { self.imageType = imageTypeS; }
        
        if let sortValueObj = jsonObj["SortValue"] {
            if sortValueObj is String, let sortValueS = sortValueObj as? String, let sortValueI = Int(sortValueS) {
                self.sortValue = sortValueI;
            } else if sortValueObj is Int, let sortValueI = sortValueObj as? Int {
                self.sortValue = sortValueI;
            }
        }
    }
}
