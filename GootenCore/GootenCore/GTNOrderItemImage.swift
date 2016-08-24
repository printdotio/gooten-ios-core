//
//  GTNOrderItemImage.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/22/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNOrderItemImage: NSObject {

    public var url: String = "";
    public var index: Int = 0;
    public var thumbnailUrl: String = "";
    public var manipCommand: String = "";
    
    init(url: String, index: Int, thumbnailUrl: String, manipCommand: String) {
        super.init();
        self.url = url;
        self.index = index;
        self.thumbnailUrl = thumbnailUrl;
        self.manipCommand = manipCommand;
    }
    
    func elements()->Dictionary<String, String>{
        return ["Url" : url,
                "Index" : String(index),
                "ThumbnailUrl" : thumbnailUrl,
                "ManipCommand" : manipCommand];
    }
}