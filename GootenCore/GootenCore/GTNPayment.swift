//
//  GTNPayment.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/25/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNPayment: NSObject {
    
    public var currencyCode: String = "";
    public var total: Double = 0.0;
    
    public init(currencyCode: String, total: Double) {
        super.init();
        self.currencyCode = currencyCode;
        self.total = total;
    }
    
    func elements()->Dictionary<String, String>{
        return ["CurrencyCode" : currencyCode,
                "Total" : String(total)];
    }
}