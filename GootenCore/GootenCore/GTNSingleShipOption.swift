//
//  GTNShippingOption.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/15/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

open class GTNSingleShipOption: NSObject{
    
    open var carrierName: String = "";
    open var methodType: String = "";
    open var name: String = "";
    open var price: GTNPriceInfo = GTNPriceInfo();
    open var id: Int = 1;
    open var estBusinessDaysTilDelivery: Int = 0;
    open var methodId: Int = 0;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(_ jsonObj: AnyObject){
        if let carrierNameS = jsonObj["CarrierName"] as? String { self.carrierName = carrierNameS };
        if let methodTypeS = jsonObj["MethodType"] as? String { self.methodType = methodTypeS };
        if let nameS = jsonObj["Name"] as? String { self.name = nameS };
        if let priceObj = jsonObj["Price"] { self.price = GTNPriceInfo(priceObj as AnyObject); }
        if let idS = jsonObj["Id"] as? Int { self.id = idS };
        if let estBusinessDaysTilDeliveryS = jsonObj["EstBusinessDaysTilDelivery"] as? Int { self.estBusinessDaysTilDelivery = estBusinessDaysTilDeliveryS };
        if let methodIdS = jsonObj["MethodId"] as? Int { self.methodId = methodIdS };
    }
}
