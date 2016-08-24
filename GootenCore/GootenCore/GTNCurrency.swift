//
//  GTNCurrency.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/20/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNCurrency: NSObject {
    
    public var name: String = "";
    public var code: String = "";
    public var format: String = "";
    
    override init() {
        
    }
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject){
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let codeS = jsonObj["Code"] as? String { self.code = codeS; }
        if let formatS = jsonObj["Format"] as? String { self.format = formatS; }
    }
}