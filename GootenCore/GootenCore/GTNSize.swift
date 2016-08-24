//
//  GTNSize.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/21/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNSize: NSObject {
    
    public var width: Int = 0;
    public var height: Int = 0;
    
    init(width: Int, height: Int) {
        super.init();
        self.width = width;
        self.height = height;
    }
}