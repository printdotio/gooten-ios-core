//
//  GTNAPIError.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/6/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

@objc public enum GTNErrorCode: Int {
    case InvalidURL
    case InvalidTemplate
    case NoInternetConnection
    case NoResponseFromServer
    case NoItems
    case ParseJSONFailed
    case Custom
    case InvalidConfiguration
}

public class GTNError: NSObject, ErrorType {
    
    public var errorCode: GTNErrorCode;
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
    
    public func message()->String{
        switch self.errorCode {
        case .InvalidURL: return invalidURL;
        case .InvalidTemplate: return invalidTemplate;
        case .NoInternetConnection: return noInternetConnection;
        case .NoResponseFromServer: return noResponseFromServer;
        case .NoItems: return noItems;
        case .ParseJSONFailed: return parseJSONFailed;
        case .Custom: return self.errorMessage;
        case .InvalidConfiguration: return self.invalidConfiguration;
        }
    }
}