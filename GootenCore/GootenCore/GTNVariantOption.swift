//
//  GTNVariantOption.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/13/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNVariantOption: NSObject{
    
    public var optionId: String = "";
    public var valueId: String = "";
    public var name: String = "";
    public var value: String = "";
    
    public var imageUrl: String = "";
    public var imageType: String = "";
    public var sortValue: Int = 0;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject) {
        
        if let optionIdS = jsonObj["OptionId"] as? String { self.optionId = optionIdS; }
        if let valueIdS = jsonObj["ValueId"] as? String { self.valueId = valueIdS; }
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let valueS = jsonObj["Value"] as? String { self.value = valueS; }
        if let imageUrlS = jsonObj["ImageUrl"] as? String { self.imageUrl = imageUrlS; }
        if let imageTypeS = jsonObj["ImageType"] as? String { self.imageType = imageTypeS; }
        
        if let sortValueObj = jsonObj["SortValue"] {
            if sortValueObj is String, let sortValueS = sortValueObj as? String, sortValueI = Int(sortValueS) {
                self.sortValue = sortValueI;
            } else if sortValueObj is Int, let sortValueI = sortValueObj as? Int {
                self.sortValue = sortValueI;
            }
        }
    }
}
