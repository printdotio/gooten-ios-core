//
//  GTNProductInfo.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/6/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNProductInfo: NSObject{
    
    open var content: Array<String> = [];
    open var contentType: String = "";
    open var key: String = "";
    open var index: Int = 0;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject) {
        if let contentS = jsonObj["Content"] as? Array<String> { self.content = contentS; }
        if let contentTypeS = jsonObj["ContentType"] as? String { self.contentType = contentTypeS; }
        if let keyS = jsonObj["Key"] as? String { self.key = keyS; }
        if let indexS = jsonObj["Index"] as? Int { self.index = indexS; }
    }
}
