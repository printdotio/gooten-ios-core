//
//  GTNShippingOption.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/15/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNSingleShipOption: NSObject{
    
    public var carrierName: String = "";
    public var methodType: String = "";
    public var name: String = "";
    public var price: GTNPriceInfo = GTNPriceInfo();
    public var id: Int = 1;
    public var estBusinessDaysTilDelivery: Int = 0;
    public var methodId: Int = 0;
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject){
        if let carrierNameS = jsonObj["CarrierName"] as? String { self.carrierName = carrierNameS };
        if let methodTypeS = jsonObj["MethodType"] as? String { self.methodType = methodTypeS };
        if let nameS = jsonObj["Name"] as? String { self.name = nameS };
        if let priceObj = jsonObj["Price"], priceS = priceObj { self.price = GTNPriceInfo(priceS); }
        if let idS = jsonObj["Id"] as? Int { self.id = idS };
        if let estBusinessDaysTilDeliveryS = jsonObj["EstBusinessDaysTilDelivery"] as? Int { self.estBusinessDaysTilDelivery = estBusinessDaysTilDeliveryS };
        if let methodIdS = jsonObj["MethodId"] as? Int { self.methodId = methodIdS };
    }
}