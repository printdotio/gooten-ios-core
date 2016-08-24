//
//  GTNProductInfo.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/6/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNProductInfo: NSObject{
    
    public var content: Array<String> = [];
    public var contentType: String = "";
    public var key: String = "";
    public var index: Int = 0;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject) {
        if let contentS = jsonObj["Content"] as? Array<String> { self.content = contentS; }
        if let contentTypeS = jsonObj["ContentType"] as? String { self.contentType = contentTypeS; }
        if let keyS = jsonObj["Key"] as? String { self.key = keyS; }
        if let indexS = jsonObj["Index"] as? Int { self.index = indexS; }
    }
}