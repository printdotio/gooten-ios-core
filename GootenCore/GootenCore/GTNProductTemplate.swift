//
//  GTNProductTemplate.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/14/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNProductTemplate: NSObject{
    
    open var name: String = "";
    open var imageUrl: String = "";
    open var isDefault: Bool = false;
    open var spaces: Array<GTNSpace> = [];
    
    public override init() {
        super.init();
    }
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let imageUrlS = jsonObj["ImageUrl"] as? String { self.imageUrl = imageUrlS; }
        if let isDefaultS = jsonObj["IsDefault"] as? Bool { self.isDefault = isDefaultS; }
        if let spacesObj = jsonObj["Spaces"] as? Array<AnyObject> {
            for spaceJson in spacesObj {
                self.spaces.append(GTNSpace(spaceJson));
            }
        }
    }
}
