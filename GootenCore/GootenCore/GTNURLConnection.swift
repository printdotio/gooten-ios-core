//
//  GTNURLConnection.swift
//  GootenCore
//
//  Created by Boro Perisic on 6/30/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

enum GTNSerializer {
    case json
    case rawData
}

let kGTHttpMethodGET = "GET";
let kGTHttpMethodPOST = "POST";

class GTNURLConnection {
    
    var baseURL : URL;
    var rSerializer : GTNSerializer;
    
    init(URL: Foundation.URL){
        baseURL = URL;
        rSerializer = .json
    }
    
    func setResponseSerializer(_ rs: GTNSerializer){
        rSerializer = rs;
    }
    
    func postToPath(_ path: String, parameters: AnyObject, success:@escaping (_ response: AnyObject) -> (), failure:@escaping (_ error: GTNError) -> ()){
        var dataParams : Data;
        
        if parameters is Dictionary<String, String> {
            dataParams = dataFromParameters(parameters as! Dictionary<String, String>);
        } else {
            dataParams = (parameters as? Data)!;
        }
        executeMethod(kGTHttpMethodPOST, path: path, dataParams: dataParams as AnyObject, success: success, failure: failure);
    }
    
    func getFromPath(_ path: String, parameters: Dictionary<String, String>, success: @escaping (_ response: AnyObject) -> (), failure:@escaping (_ error: GTNError) -> ()){
        let dataParams = stringFromParams(parameters);
        executeMethod(kGTHttpMethodGET, path: path, dataParams: dataParams as AnyObject, success: success, failure: failure);
    }
    
    func upload(_ data: Data, path: String, success:(_ response: AnyObject) -> (), failure:(_ errorMsg: String) -> ()){
        // TO-DO
    }
    
    func downloadFileWithUrl(_ fileUrl: String, progress:(_ totalBytesRead: Double, _ totalBytesExpectedToRead: Double) -> (), success:(_ response: AnyObject) -> (), failure:(_ errorMsg: String) -> ()){
        // TO-DO
    }
    
    // MARK: Main call
    func executeMethod(_ method: String, path: String, dataParams: AnyObject, success:@escaping (_ response: AnyObject) -> (), failure:@escaping (_ error: GTNError) -> ()){
        var sUrl = "\(baseURL.absoluteString)\(path)";
        
        if method == kGTHttpMethodGET && dataParams is String{
            sUrl = "\(sUrl)\(dataParams)";
        }
        
        guard let url = URL(string: sUrl)
            else {
                failure(GTNError(.invalidURL));
                return;
        };
        
        let request = NSMutableURLRequest(url: url);
        request.timeoutInterval = 60.0;
        
        if method == kGTHttpMethodPOST{
            if dataParams is Data {
                request.httpBody = dataParams as? Data;
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type");
        }
        
        request.httpMethod = method;
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error != nil {
                    //printgt("GTNURLConnection error: \(error.debugDescription)");
                    failure(GTNError(.noInternetConnection));
                    return;
                }
                
                if data == nil {
                    failure(GTNError(.noResponseFromServer));
                }
                
                switch self.rSerializer {
                case .rawData:
                    guard let unwrappData = data
                        else {
                            failure(GTNError(.noResponseFromServer));
                            return;
                    };
                    success(unwrappData as AnyObject);
                    
                    break;
                    
                case .json:
                    let jsonResult : Any;
                    do {
                        guard let unwrappData = data
                            else {
                                failure(GTNError(.noResponseFromServer));
                                return;
                        }
                        
                        jsonResult = try JSONSerialization.jsonObject(with: unwrappData, options:.allowFragments);
                        success(jsonResult as AnyObject);
                        
                    } catch _ as NSError {
                        failure(GTNError(.parseJSONFailed));
                    }
                    break;
                }
            });

        }).resume()
    }
    
    // MARK: Other
    func dataFromParameters(_ params: Dictionary<String,String>) -> Data{
        let mString = stringFromParams(params);
        return mString.data(using: String.Encoding.utf8)!;
    }
    
    func stringFromParams(_ params: Dictionary<String,String>) -> String {
        if params.count == 0 {
            return "";
        }
        
        var mString = "";
        
        for key in (params.keys) {
            guard let value = params[key]
                else { return ""; }
            
            let decodedValue = value.stringByDecodingHTMLEntities
            let newValue = String(decodedValue).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            mString += "\(key)=\(newValue!)&";
        }
        
        if mString.characters.count > 0 {
            mString = String(mString.characters.dropLast());
        }
        
        return mString;
    }
}

