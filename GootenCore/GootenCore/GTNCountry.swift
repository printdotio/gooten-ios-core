//
//  GTNCountry.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/20/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNCountry: NSObject {
    
    open var name: String = "";
    open var code: String = "";
    open var isSupported: Bool = false;
    open var measurementCode: String = "";
    open var flagUrl: String = "";
    open var defaultCurrency: GTNCurrency = GTNCurrency();
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let nameS = jsonObj["Name"] as? String { self.name = nameS; }
        if let codeS = jsonObj["Code"] as? String { self.code = codeS; }
        if let isSupportedS = jsonObj["IsSupported"] as? Bool { self.isSupported = isSupportedS; }
        if let measurementCodeS = jsonObj["MeasurementCode"] as? String { self.measurementCode = measurementCodeS; }
        if let flagUrlS = jsonObj["FlagUrl"] as? String { self.flagUrl = flagUrlS; }
        
        if let defCurrObj = jsonObj["DefaultCurrency"], let defCurrJson = defCurrObj {
            self.defaultCurrency = GTNCurrency(defCurrJson as AnyObject);
        }
    }
}
