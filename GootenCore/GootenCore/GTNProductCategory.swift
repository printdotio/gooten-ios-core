//
//  GTNProductCategory.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/6/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNProductCategory: NSObject{
    
    open var name: String = "";
    open var id: Int = 1;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject) {
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        
        if let idObj = jsonObj["Id"] {
            if idObj is String, let idS = idObj as? String, let idI = Int(idS) {
                self.id = idI;
            } else if idObj is Int, let idI = idObj as? Int {
                self.id = idI;
            }
        }
    }
}
