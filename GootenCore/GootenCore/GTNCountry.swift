//
//  GTNCountry.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/20/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNCountry: NSObject {
    
    public var name: String = "";
    public var code: String = "";
    public var isSupported: Bool = false;
    public var measurementCode: String = "";
    public var flagUrl: String = "";
    public var defaultCurrency: GTNCurrency = GTNCurrency();
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject){
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let codeS = jsonObj["Code"] as? String { self.code = codeS; }
        if let isSupportedS = jsonObj["IsSupported"] as? Bool { self.isSupported = isSupportedS; }
        if let measurementCodeS = jsonObj["MeasurementCode"] as? String { self.measurementCode = measurementCodeS; }
        if let flagUrlS = jsonObj["FlagUrl"] as? String { self.flagUrl = flagUrlS; }
        
        if let defCurrObj = jsonObj["DefaultCurrency"], defCurrJson = defCurrObj {
            self.defaultCurrency = GTNCurrency(defCurrJson);
        }
    }
}
