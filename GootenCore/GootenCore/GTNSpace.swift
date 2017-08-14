//
//  GTNProductSpace.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/14/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNSpace: NSObject{
    
    open var id: String = "";
    open var index: Int = -1;
    open var finalX1: Int = 0;
    open var finalX2: Int = 0;
    open var finalY1: Int = 0;
    open var finalY2: Int = 0;
    open var layers: Array<GTNLayer> = [];
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let idS = jsonObj["Id"] as? String { self.id = idS; }
        if let indexS = jsonObj["Index"] as? Int { self.index = indexS; }
        if let finalX1S = jsonObj["FinalX1"] as? Int { self.finalX1 = finalX1S; }
        if let finalX2S = jsonObj["FinalX2"] as? Int { self.finalX2 = finalX2S; }
        if let finalY1S = jsonObj["FinalY1"] as? Int { self.finalY1 = finalY1S; }
        if let finalY2S = jsonObj["FinalY2"] as? Int { self.finalY2 = finalY2S; }
        if let layersObj = jsonObj["Layers"] as? Array<AnyObject> {
            for layerJson in layersObj {
                self.layers.append(GTNLayer(layerJson));
            }
        }
    }
}
