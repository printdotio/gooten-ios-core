//
//  GTNConfig.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/1/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import UIKit

@objc public enum GTNEnvironment: Int { // @objc -> used to support Obj C enums
    case production
    case staging
    case qa
}

open class GTNConfig: NSObject {
    
    static let sharedInstance = GTNConfig();
    static let buildVersion = 34;
    
    // public configuration with default values
    open var isInTestMode: Bool = false;
    open var recipeId = "";
    open var turnOffLogs: Bool = false;
    open var environment: GTNEnvironment = .production;
    open var countryCode: String = GTNDefaults.kCountryCode;
    open var languageCode: String = GTNDefaults.kLanguageCode;
    open var currencyCode: String = GTNDefaults.kCurrencyCode;
    open var showAllProducts: Bool = true;
    
    public override init(){
        super.init();
    }
    
    func isValid() -> Bool {
        return self.recipeId.characters.count != 0;
    }
    
    func copy(from config: GTNConfig){
        GTNConfig.sharedInstance.isInTestMode = config.isInTestMode;
        GTNConfig.sharedInstance.recipeId = config.recipeId;
        GTNConfig.sharedInstance.turnOffLogs = config.turnOffLogs;
        GTNConfig.sharedInstance.environment = config.environment;
        GTNConfig.sharedInstance.countryCode = config.countryCode;
        GTNConfig.sharedInstance.languageCode = config.languageCode;
        GTNConfig.sharedInstance.currencyCode = config.currencyCode;
        GTNConfig.sharedInstance.showAllProducts = config.showAllProducts;
    }
    
    override open func isEqual(_ object: Any?) -> Bool {
        if !(object is GTNConfig) {return false;}
        
        guard let obj = object as? GTNConfig
            else {return false;}
        
        if (self.isInTestMode == obj.isInTestMode &&
            self.recipeId == obj.recipeId && self.turnOffLogs == obj.turnOffLogs &&
            self.environment == obj.environment && self.countryCode == obj.countryCode &&
            self.languageCode == obj.languageCode && self.currencyCode == obj.currencyCode &&
            self.showAllProducts == obj.showAllProducts){
            return true;
        }
        
        return false;
    }
}
