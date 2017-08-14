//
//  GTNCurrency.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/20/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNCurrency: NSObject {
    
    open var name: String = "";
    open var code: String = "";
    open var format: String = "";
    
    public override init() {
        super.init();
    }
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let codeS = jsonObj["Code"] as? String { self.code = codeS; }
        if let formatS = jsonObj["Format"] as? String { self.format = formatS; }
    }
}
