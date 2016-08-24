//
//  GTNProductTemplate.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/14/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNProductTemplate: NSObject{
    
    public var name: String = "";
    public var imageUrl: String = "";
    public var isDefault: Bool = false;
    public var spaces: Array<GTNSpace> = [];
    
    public override init() {
        super.init();
    }
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject){
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