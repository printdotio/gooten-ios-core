//
//  GTNProductLayer.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/14/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNLayer: NSObject{
    
    open var id: String = "";
    open var type: String = "";
    open var zIndex: Int = -1;
    open var X1: Int = 0;
    open var X2: Int = 0;
    open var Y1: Int = 0;
    open var Y2: Int = 0;
    open var backgroundImageUrl: String = "";
    open var overlayImageUrl: String = "";
    open var includeInPrint: Bool = false;
    open var imageFill: String = "";
    open var color: String = "";
    open var fontName: String = "";
    open var fontSize: Double = 0.0;
    open var horizontalAlignment: String = "";
    open var verticalAlignment: String = "";
    open var defaultText: String = "";
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject) {
        if let idS = jsonObj["Id"] as? String { self.id = idS; }
        if let typeS = jsonObj["Type"] as? String { self.type = typeS; }
        if let zIndexS = jsonObj["ZIndex"] as? Int { self.zIndex = zIndexS; }
        if let kX1S = jsonObj["X1"] as? Int { self.X1 = kX1S; }
        if let kX2S = jsonObj["X2"] as? Int { self.X2 = kX2S; }
        if let kY1S = jsonObj["Y1"] as? Int { self.Y1 = kY1S; }
        if let kY2S = jsonObj["Y2"] as? Int { self.Y2 = kY2S; }
        if let backgroundImageUrlS = jsonObj["BackgroundImageUrl"] as? String { self.backgroundImageUrl = backgroundImageUrlS; }
        if let overlayImageUrlS = jsonObj["OverlayImageUrl"] as? String { self.overlayImageUrl = overlayImageUrlS; }
        if let includeInPrintS = jsonObj["IncludeInPrint"] as? Bool { self.includeInPrint = includeInPrintS; }
        if let imageFillS = jsonObj["ImageFill"] as? String { self.imageFill = imageFillS; }
        if let colorS = jsonObj["Color"] as? String { self.color = colorS; }
        if let fontNameS = jsonObj["FontName"] as? String { self.fontName = fontNameS; }
        if let fontSizeS = jsonObj["FontSize"] as? Double { self.fontSize = fontSizeS; }
        if let horizontalAlignmentS = jsonObj["FontHAlignment"] as? String { self.horizontalAlignment = horizontalAlignmentS; }
        if let verticalAlignmentS = jsonObj["FontVAlignment"] as? String { self.verticalAlignment = verticalAlignmentS; }
        if let defaultTextS = jsonObj["DefaultText"] as? String { self.defaultText = defaultTextS; }
    }
}
