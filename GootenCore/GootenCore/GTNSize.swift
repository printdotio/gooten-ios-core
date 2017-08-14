//
//  GTNSize.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/21/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNSize: NSObject {
    
    open var width: Int = 0;
    open var height: Int = 0;
    
    public init(width: Int, height: Int) {
        super.init();
        self.width = width;
        self.height = height;
    }
}
