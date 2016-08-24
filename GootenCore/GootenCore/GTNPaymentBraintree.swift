//
//  GTNPaymentBraintree.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/22/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

public class GTNPaymentBraintree: GTNPayment {
    
    public var braintreeEncryptedCCNumber: String = "";
    public var braintreeEncryptedCCExpDate: String = "";
    public var braintreeEncryptedCCV: String = "";
    
    public init(braintreeEncryptedCCNumber: String, braintreeEncryptedCCExpDate: String, braintreeEncryptedCCV: String, currencyCode: String, total: Double) {
        super.init(currencyCode: currencyCode, total: total);
        self.braintreeEncryptedCCNumber = braintreeEncryptedCCNumber;
        self.braintreeEncryptedCCExpDate = braintreeEncryptedCCExpDate;
        self.braintreeEncryptedCCV = braintreeEncryptedCCV;
    }
    
    override func elements()->Dictionary<String, String>{
        return ["BraintreeEncryptedCCNumber" : braintreeEncryptedCCNumber,
                "BraintreeEncryptedCCExpDate" : braintreeEncryptedCCExpDate,
                "BraintreeEncryptedCCV" : braintreeEncryptedCCV,
                "CurrencyCode" : self.currencyCode,
                "Total" : String(self.total)];
    }
}