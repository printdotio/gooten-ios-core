//
//  GTNAPIError.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/6/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

@objc public enum GTNErrorCode: Int {
    case invalidURL
    case invalidTemplate
    case noInternetConnection
    case noResponseFromServer
    case noItems
    case parseJSONFailed
    case custom
    case invalidConfiguration
}

open class GTNError: NSObject, Error {
    
    open var errorCode: GTNErrorCode;
    var errorMessage: String = "";
    
    // API
    let invalidURL = "Invalid URL"
    let invalidTemplate = "Template isn't valid. Please contact partnersupport@gooten.com"
    let invalidConfiguration = "Validation of GTNConfig failed. Missing 'recipeId'.";
    let noInternetConnection = "Please check your internet connection or try again later."
    let noResponseFromServer = "There's no response from server"
    let noItems = "No items"
    let parseJSONFailed = "Parsing JSON failed"
    
    init(_ errorCode: GTNErrorCode, message: String = "") {
        self.errorCode = errorCode;
        self.errorMessage = message;
    }
    
    open func message()->String{
        switch self.errorCode {
        case .invalidURL: return invalidURL;
        case .invalidTemplate: return invalidTemplate;
        case .noInternetConnection: return noInternetConnection;
        case .noResponseFromServer: return noResponseFromServer;
        case .noItems: return noItems;
        case .parseJSONFailed: return parseJSONFailed;
        case .custom: return self.errorMessage;
        case .invalidConfiguration: return self.invalidConfiguration;
        }
    }
}
