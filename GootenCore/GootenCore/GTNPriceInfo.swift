//
//  GTNPriceInfo.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/6/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNPriceInfo: NSObject{
    
    public var price: Double = 0.0;
    public var currencyCode: String = "";
    public var formattedPrice: String = "";
    public var currencyFormat: String = "";
    public var currencyDigits: Int = 0;
    
    public override init() {
        super.init();
    }
    
    init(_ jsonObj: AnyObject) {
        super.init();
        self.parseJson(jsonObj);
    }
    
    func parseJson(jsonObj: AnyObject) {
        if let priceS = jsonObj["Price"] as? Double { self.price = priceS; }
        if let currencyCodeS = jsonObj["CurrencyCode"] as? String { self.currencyCode = currencyCodeS; }
        if let formattedPriceS = jsonObj["FormattedPrice"] as? String { self.formattedPrice = formattedPriceS; }
        if let currencyFormatS = jsonObj["CurrencyFormat"] as? String { self.currencyFormat = currencyFormatS; }
        if let currencyDigitsS = jsonObj["CurrencyDigits"] as? Int { self.currencyDigits = currencyDigitsS; }
    }
}