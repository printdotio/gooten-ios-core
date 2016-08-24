//
//  GTNProductLayer.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/14/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNLayer: NSObject{
    
    public var id: String = "";
    public var type: String = "";
    public var zIndex: Int = -1;
    public var X1: Int = 0;
    public var X2: Int = 0;
    public var Y1: Int = 0;
    public var Y2: Int = 0;
    public var backgroundImageUrl: String = "";
    public var overlayImageUrl: String = "";
    public var includeInPrint: Bool = false;
    public var imageFill: String = "";
    public var color: String = "";
    public var fontName: String = "";
    public var fontSize: Double = 0.0;
    public var horizontalAlignment: String = "";
    public var verticalAlignment: String = "";
    public var defaultText: String = "";
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject) {
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
