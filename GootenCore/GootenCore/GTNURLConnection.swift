//
//  GTNURLConnection.swift
//  GootenCore
//
//  Created by Boro Perisic on 6/30/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

enum GTNSerializer {
    case JSON
    case RawData
}

let kGTHttpMethodGET = "GET";
let kGTHttpMethodPOST = "POST";

class GTNURLConnection {
    
    var baseURL : NSURL;
    var rSerializer : GTNSerializer;
    
    init(URL: NSURL){
        baseURL = URL;
        rSerializer = .JSON
    }
    
    func setResponseSerializer(rs: GTNSerializer){
        rSerializer = rs;
    }
    
    func postToPath(path: String, parameters: AnyObject, success:(response: AnyObject) -> (), failure:(error: GTNError) -> ()){
        var dataParams : NSData;
        
        if parameters is Dictionary<String, String> {
            dataParams = dataFromParameters(parameters as! Dictionary<String, String>);
        } else {
            dataParams = (parameters as? NSData)!;
        }
        executeMethod(kGTHttpMethodPOST, path: path, dataParams: dataParams, success: success, failure: failure);
    }
    
    func getFromPath(path: String, parameters: Dictionary<String, String>, success:(response: AnyObject) -> (), failure:(error: GTNError) -> ()){
        let dataParams = stringFromParams(parameters);
        executeMethod(kGTHttpMethodGET, path: path, dataParams: dataParams, success: success, failure: failure);
    }
    
    func upload(data: NSData, path: String, success:(response: AnyObject) -> (), failure:(errorMsg: String) -> ()){
        // TO-DO
    }
    
    func downloadFileWithUrl(fileUrl: String, progress:(totalBytesRead: Double, totalBytesExpectedToRead: Double) -> (), success:(response: AnyObject) -> (), failure:(errorMsg: String) -> ()){
        // TO-DO
    }
    
    // MARK: Main call
    func executeMethod(method: String, path: String, dataParams: AnyObject, success:(response: AnyObject) -> (), failure:(error: GTNError) -> ()){
        var sUrl = "\(baseURL.absoluteString)\(path)";
        
        if method == kGTHttpMethodGET && dataParams is String{
            sUrl = "\(sUrl)\(dataParams)";
        }
        
        guard let url = NSURL(string: sUrl)
            else {
                failure(error: GTNError(.InvalidURL));
                return;
        };
        
        let request = NSMutableURLRequest(URL: url);
        request.timeoutInterval = 60.0;
        
        if method == kGTHttpMethodPOST{
            if dataParams is NSData {
                request.HTTPBody = dataParams as? NSData;
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        }
        
        request.HTTPMethod = method;
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            dispatch_async(dispatch_get_main_queue(), {
                if error != nil {
                    //printgt("GTNURLConnection error: \(error.debugDescription)");
                    failure(error: GTNError(.NoInternetConnection));
                    return;
                }
                
                if data == nil {
                    failure(error: GTNError(.NoResponseFromServer));
                }
                
                switch self.rSerializer {
                case .RawData:
                    guard let unwrappData = data
                        else {
                            failure(error: GTNError(.NoResponseFromServer));
                            return;
                    };
                    success(response: unwrappData);
                    
                    break;
                    
                case .JSON:
                    let jsonResult : AnyObject;
                    do {
                        guard let unwrappData = data
                            else {
                                failure(error: GTNError(.NoResponseFromServer));
                                return;
                        }
                        
                        jsonResult = try NSJSONSerialization.JSONObjectWithData(unwrappData, options:.AllowFragments);
                        success(response: jsonResult);
                        
                    } catch _ as NSError {
                        failure(error: GTNError(.ParseJSONFailed));
                    }
                    break;
                }
            });
            }.resume();
        
    }
    
    // MARK: Other
    func dataFromParameters(params: Dictionary<String,String>) -> NSData{
        let mString = stringFromParams(params);
        return mString.dataUsingEncoding(NSUTF8StringEncoding)!;
    }
    
    func stringFromParams(params: Dictionary<String,String>) -> String {
        if params.count == 0 {
            return "";
        }
        
        var mString = "";
        
        for key in (params.keys) {
            guard let value = params[key]
                else { return ""; }
            
            let decodedValue = value.stringByDecodingHTMLEntities
            let newValue = String(decodedValue).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            mString += "\(key)=\(newValue!)&";
        }
        
        if mString.characters.count > 0 {
            mString = String(mString.characters.dropLast());
        }
        
        return mString;
    }
}

