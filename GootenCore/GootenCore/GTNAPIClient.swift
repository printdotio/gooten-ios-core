//
//  GTNAPIClient.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/4/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import Foundation

let kGTNServerURLProduction = "https://api.print.io/api/v/\(GTNConfig.buildVersion)/source/ios/";
let kGTNServerURLStaging = "https://staging-api.print.io/api/v/\(GTNConfig.buildVersion)/source/ios/";
let kGTNServerURLQA = "http://qa-api.print.io/api/v/\(GTNConfig.buildVersion)/source/ios/";

let kGTNRESTAPIServerUserLocation = "https://printio-geo.appspot.com/ip/";

let kGTNRESTAPIPathUserLocation = "jsonp";
let kGTNRESTAPIPathProducts = "products/?";
let kGTNRESTAPIPathVariants = "productvariants/?";
let kGTNRESTAPIPathTemplates = "producttemplates/?";
let kGTNRESTAPIPathShippingPrices = "shippingprices/?";
let kGTNRESTAPIPathShipPriceEstimate = "shippriceestimate/?";
let kGTNRESTAPIPathPriceEstimate = "priceestimate/?";
let kGTNRESTAPIPathOrders = "orders/?";
let kGTNRESTAPIPathPaymentValidation = "paymentvalidation/?";
let kGTNRESTAPIPathBraintreeClientToken = "braintreeclienttoken/?";

// other less important endpoints
let kGTNRESTAPIPathCountries = "countries/?"
let kGTNRESTAPIPathCurrencies = "currencies/?";
let kGTNRESTAPIPathCurrencyConversion = "currencyconversion/?";
let kGTNRESTAPIPathUserInfo = "userinfo/?";
let kGTNRESTAPIPathAddressValidation = "addressvalidation/?";

func serverURL() -> String {
    switch GTNConfig.sharedInstance.environment {
    case .staging:
        return kGTNServerURLStaging;
    case .production:
        return kGTNServerURLProduction;
    case .qa:
        return kGTNServerURLQA;
    }
}

class GTNAPIClient {
    
    // MARK: Endpoint calls
    func getUserLocation(success:@escaping (_ countryCode: String)->(), failure:@escaping (_ error: GTNError)->()) {
        execute(kGTNRESTAPIServerUserLocation, path: kGTNRESTAPIPathUserLocation, serializer: .rawData, useRecipeId: false, success: { (responseObj) in
            var resultS = String(data: responseObj as! Data, encoding: String.Encoding.utf8)!;
            resultS = gtnUtilsReplace(resultS, pattern: "[^a-zA-Z0-9]", replacementPattern: "")!;
            success(resultS);
        }) { (error) in
            failure(error);
        };
    }
    
    func getProducts(success:@escaping (_ products: Array<GTNProduct>)->(), failure:@escaping (_ error: GTNError)->()){
        let params = basicParams(true);
        
        execute(path: kGTNRESTAPIPathProducts, params: params, success: { (responseObj) in
            guard let products = responseObj["Products"] as? [AnyObject]
                else {
                    failure(GTNError(.parseJSONFailed));
                    return;
            }
            
            var productsArr: Array<GTNProduct> = [];
            for productJson in products {
                let product = GTNProduct(productJson);
                productsArr.append(product);
            }
            success(productsArr);
            
        }) { (error) in
            failure(error);
        };
    }
    
    func getProductVariants(productId: Int, success:@escaping (_ variants: Array<GTNProductVariant>)->(), failure:@escaping (_ error: GTNError)->()){
        var params = basicParams(true);
        params["productId"] = String(productId);
        
        execute(path: kGTNRESTAPIPathVariants, params: params, success: { (responseObj) in
            guard let variants = responseObj["ProductVariants"] as? [AnyObject]
                else {
                    failure(GTNError(.parseJSONFailed));
                    return;
            }
            
            var variantsArr: Array<GTNProductVariant> = [];
            for variantJson in variants{
                let variant = GTNProductVariant(variantJson);
                variantsArr.append(variant);
            }
            success(variantsArr);
            
        }) { (error) in
            failure(error);
        }
    }
    
    func getProductTemplates(sku: String, success:@escaping (_ templates: Array<GTNProductTemplate>)->(), failure:@escaping (_ error: GTNError)->()){
        var params = basicParams(true);
        params["sku"] = sku;
        
        execute(path: kGTNRESTAPIPathTemplates, params: params, success: { (responseObj) in
            guard let templates = responseObj["Options"] as? [AnyObject]
                else {
                    failure(GTNError(.parseJSONFailed));
                    return;
            }
            
            var templatesArr: Array<GTNProductTemplate> = [];
            for templateJson in templates{
                let template = GTNProductTemplate(templateJson);
                templatesArr.append(template);
            }
            success(templatesArr);
        }) { (error) in
            failure(error);
        };
    }
    
    func getRequiredImages(sku: String, templateName: String, success:@escaping (_ sizes: Array<GTNSize>)->(), failure:@escaping (_ error: GTNError)->()){
        getProductTemplates(sku: sku, success: { (templates) in
            
            var template: GTNProductTemplate = GTNProductTemplate();
            
            for t in templates {
                if t.name == templateName {
                    template = t;
                    break;
                }
            }
            
            if template.spaces.count == 0 {
                failure(GTNError(.invalidTemplate));
                return;
            }
            
            var sizesArr: Array<GTNSize> = [];
            
            for space in template.spaces {
                for layer in space.layers {
                    if layer.type == "Image"{
                        sizesArr.append(GTNSize(width: layer.X2-layer.X1, height: layer.Y2 - layer.Y1));
                    }
                }
            }
            
            success(sizesArr);
            
        }) { (error) in
            failure(error);
        };
    }
    
    func getShippingOptions(postalCode: String, state: String, countryCode: String, items: Array<GTNShippingItem>, success:@escaping(_ options: Array<GTNShippingOption>)->(), failure:@escaping (_ error: GTNError)->()){
        
        if items.count == 0 {
            failure(GTNError(.noItems));
            return;
        }
        
        var itemsArr: Array<Dictionary<String, AnyObject>> = [];
        
        for item in items{
            itemsArr.append(item.dict());
        }
        
        let params : [String : Any] = ["ShipToPostalCode" : postalCode,
                                             "ShipToCountry" : countryCode,
                                             "ShipToState" : state,
                                             "LanguageCode" : GTNConfig.sharedInstance.languageCode,
                                             "CurrencyCode" : GTNConfig.sharedInstance.currencyCode,
                                             "Items" : itemsArr];
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                execute(path: kGTNRESTAPIPathShippingPrices, method: kGTHttpMethodPOST, rawData: jsonString, success: { (responseObj) in
                    guard let resultsArr = responseObj["Result"] as? Array<AnyObject>
                        else {
                            failure(GTNError(.parseJSONFailed));
                            return;
                    }
                    
                    var shippingOptionsArr: Array<GTNShippingOption> = [];
                    for item in resultsArr {
                        shippingOptionsArr.append((GTNShippingOption(item)));
                    }
                    success(shippingOptionsArr);
                    
                    }, failure: { (error) in
                        failure(error);
                });
            }
        } catch {
            failure(GTNError(.parseJSONFailed));
        }
    }
    
    func getShipPriceEstimate(productId: Int, success:@escaping (_ shipPriceEstimate: GTNShipPriceEstimate)->(), failure:@escaping (_ error: GTNError)->()){
        var params = basicParams();
        params["productId"] = String(productId);
        
        execute(path: kGTNRESTAPIPathShipPriceEstimate, params: params, success: { (responseObj) in
            success(GTNShipPriceEstimate(responseObj));
        }) { (error) in
            failure(error);
        };
    }
    
    func getOrderStatus(orderId: String, success:@escaping (_ orderStatus: GTNOrderStatus)->(), failure:@escaping (_ error: GTNError)->()){
        var params = basicParams();
        params["id"] = orderId;
        
        execute(path: kGTNRESTAPIPathOrders, params: params, success: { (responseObj) in
            success(GTNOrderStatus(responseObj));
        }) { (error) in
            failure(error);
        };
    }
    
    func getPaymentValidation(orderId: String, paypalKey: String, success:@escaping (_ isValid: Bool)->(), failure:@escaping (_ error: GTNError)->()){
        var params = basicParams();
        params["OrderId"] = orderId;
        params["PayPalKey"] = paypalKey;
        
        execute(path: kGTNRESTAPIPathPaymentValidation, params: params, success: { (responseObj) in
            if let isValidResult = responseObj["IsValid"] as? Bool{
                success(isValidResult);
            } else {
                success(false);
            }
        }) { (error) in
            failure(error);
        };
    }
    
    // apple pay
    func getBraintreeClientToken(success:@escaping (_ token: String)->(), failure:@escaping (_ error: GTNError)->()){
        execute(path: kGTNRESTAPIPathBraintreeClientToken, success: { (responseObj) in
            guard let tokenS = responseObj as? String else { return; }
            success(tokenS);
        }) { (error) in
            failure(error);
        };
    }
    
    func orderSubmitApplePay(shippingAddress: GTNAddress, billingAddress: GTNAddress, pkPayment: PKPayment, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], success:@escaping (_ orderId: String)->(), failure:@escaping (_ error: GTNError)->()){
        
        // first get braintree toket from our server
        self.getBraintreeClientToken(success: { (token) in
            if token.characters.count == 0 {
                return;
            }
            
            let braintree = Braintree(clientToken: token);
            braintree?.tokenizeApplePay(pkPayment, completion: { (nonce, error) in
                
                if error != nil {
                    failure(GTNError(.custom, message: error.debugDescription));
                    return;
                }
                
                self.orderSubmit(shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, isPreSubmit: false, nonce: nonce!,  success: { (orderId) in
                    success(orderId);
                }) { (error) in
                    failure(error);
                };
            });
            
        }) { (error) in
            failure(error);
        };
    }
    
    // paypal
    func orderSubmitPaypal(shippingAddress: GTNAddress, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], success:@escaping (_ orderId: String)->(), failure:@escaping (_ error: GTNError)->()){
        
        self.orderSubmit(shippingAddress, billingAddress: GTNAddress(), payment: payment, items: items, couponCodes: couponCodes, isPreSubmit: true, nonce: "", success: { (orderId) in
            success(orderId);
        }) { (error) in
            failure(error);
        };
    }
    
    // credit card - braintree
    func orderSubmitBraintree(shippingAddress: GTNAddress, billingAddress: GTNAddress, payment: GTNPaymentBraintree, items: [GTNOrderItem], couponCodes: [String], success:@escaping (_ orderId: String)->(), failure:@escaping (_ error: GTNError)->()){
        
        self.orderSubmit(shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, isPreSubmit: false, nonce: "", success: { (orderId) in
            success(orderId);
        }) { (error) in
            failure(error);
        };
    }
    
    func orderPriceEstimate(shippingAddress: GTNAddress, items: [GTNOrderItem], currencyCode: String, couponCodes: [String], success:@escaping (_ priceEstimate: GTNPriceEstimate)->(), failure:@escaping (_ error: GTNError)->()){
        
        // create items array
        var itemsArr:[AnyObject] = [];
        for orderItem in items {
            itemsArr.append(orderItem.elements() as AnyObject);
        }
        
        var jsonDict: Dictionary = ["ShipToAddress" :  shippingAddress.elements(),
                                    "Items" : itemsArr,
                                    "Payment" : ["CurrencyCode" : currencyCode],
                                    "CouponCodes" : couponCodes] as [String : Any];
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                execute(path: kGTNRESTAPIPathPriceEstimate, method: kGTHttpMethodPOST, rawData: jsonString, success: { (responseObj) in
                    
                    // parse error if exist
                    if let hadError = responseObj["HadError"] as? Bool{
                        if hadError == true {
                            var errorMessage = "";
                            
                            if let errors = responseObj["Errors"] as? [AnyObject]{
                                for error in errors {
                                    if let message = error["ErrorMessage"] as? String {
                                        errorMessage += message;
                                    }
                                    
                                    if let propertyName = error["PropertyName"] as? String {
                                        errorMessage += ":" + propertyName + "\n";
                                    }
                                }
                            }
                            
                            failure(GTNError(.custom, message: errorMessage));
                            return;
                        }
                    }
                    
                    success(GTNPriceEstimate(responseObj));
                    
                }) { (error) in
                    failure(error);
                };
            }
        } catch {
            failure(GTNError(.parseJSONFailed));
        }
    }
    
    // main submit order function
    func orderSubmit(_ shippingAddress: GTNAddress, billingAddress: GTNAddress, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], isPreSubmit: Bool, nonce: String, success:@escaping (_ orderId: String)->(), failure:@escaping (_ error: GTNError)->()){
        
        // create items array
        var itemsArr:[AnyObject] = [];
        for orderItem in items {
            itemsArr.append(orderItem.elements() as AnyObject);
        }
        
        var jsonDict: Dictionary = ["ShipToAddress" :  shippingAddress.elements(),
                                    "BillingAddress" : billingAddress.elements(),
                                    "Items" : itemsArr,
                                    "Payment" : payment.elements(),
                                    "CouponCodes" : couponCodes,
                                    "Meta" : ["Source" : "ios-core", "Version" : GTNDefaults.SDKVersion],
                                    "isInTestMode" : (GTNConfig.sharedInstance.isInTestMode ? "true" : "false")] as [String : Any];
        
        // paypal settings
        if isPreSubmit {
            jsonDict.removeValue(forKey: "BillingAddress");
            jsonDict["IsPreSubmit"] = "true";
        }
        
        // apple pay setting
        if nonce.characters.count > 0 {
            var paymentDict = payment.elements();
            paymentDict["braintreepaymentnonce"] = nonce;
            jsonDict["Payment"] = paymentDict;
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8){
                execute(path: kGTNRESTAPIPathOrders, method: kGTHttpMethodPOST, rawData: jsonString, success: { (responseObj) in
                    
                    // parse error if exist
                    if let hadError = responseObj["HadError"] as? Bool{
                        if hadError == true {
                            var errorMessage = "";
                            
                            if let errors = responseObj["Errors"] as? [AnyObject]{
                                for error in errors {
                                    if let message = error["ErrorMessage"] as? String {
                                        errorMessage += message;
                                    }
                                    
                                    if let propertyName = error["PropertyName"] as? String {
                                        errorMessage += ":" + propertyName + "\n";
                                    }
                                }
                            }
                            
                            failure(GTNError(.custom, message: errorMessage));
                            return;
                        }
                    }
                    
                    if let orderId = responseObj["Id"] as? String {
                        success(orderId);
                        return;
                    }
                    
                    failure(GTNError(.parseJSONFailed));
                    
                }) { (error) in
                    failure(error);
                };
            }
        } catch {
            failure(GTNError(.parseJSONFailed));
        }
    }
    
    // MARK: Other, less important endopoints
    
    func getCountries(success:@escaping (_ countries: Array<GTNCountry>)->(), failure:@escaping (_ error: GTNError)->()) {
        let params = basicParams();
        
        execute(path: kGTNRESTAPIPathCountries, params: params, success: { (responseObj) in
            guard let countriesArr = responseObj["Countries"] as? Array<AnyObject>
                else {
                    failure(GTNError(.parseJSONFailed));
                    return;
            }
            
            var countries: Array<GTNCountry> = [];
            
            for country in countriesArr {
                countries.append(GTNCountry(country));
            }
            
            success(countries);
            
        }) { (error) in
            failure(error);
        };
    }
    
    func getCurrencies(success:@escaping (_ currencies: Array<GTNCurrency>)->(), failure:@escaping (_ error: GTNError)->()){
        let params = basicParams();
        
        execute(path: kGTNRESTAPIPathCurrencies, params: params, success: { (responseObj) in
            guard let currenciesArr = responseObj["Currencies"] as? Array<AnyObject>
                else {
                    failure(GTNError(.parseJSONFailed));
                    return;
            }
            
            var currencies: Array<GTNCurrency> = [];
            
            for country in currenciesArr {
                currencies.append(GTNCurrency(country));
            }
            
            success(currencies);
            
        }) { (error) in
            failure(error);
        };
    }
    
    func getUserInfo(success:@escaping (_ userInfo: GTNUserInfo)->(), failure:@escaping (_ error: GTNError)->()){
        let params = basicParams();
        
        execute(path: kGTNRESTAPIPathUserInfo, params: params, success: { (responseObj) in
            success(GTNUserInfo(responseObj));
        }) { (error) in
            failure(error);
        };
    }
    
    func convertCurrency(fromCurrencyCode: String, toCurrencyCode: String, amount: Double, success:@escaping (_ result: GTNPriceInfo)->(), failure:@escaping (_ error: GTNError)->()) {
        
        let params = ["fromCurrencyCode" : fromCurrencyCode, "toCurrencyCode" : toCurrencyCode, "amount" : String(amount)];
        
        execute(path: kGTNRESTAPIPathCurrencyConversion, params: params, success: { (responseObj) in
            success(GTNPriceInfo(responseObj));
        }) { (error) in
            failure(error);
        };
    }
    
    func validateAddress(_ address: GTNAddress, success:@escaping (_ result: GTNAddressValidation)->(), failure:@escaping (_ error: GTNError)->()){
        
        let params = ["line1" : address.line1, "line2" : address.line2, "city" : address.city, "state" : address.state, "postalCode" : address.postalCode, "countryCode" : address.countryCode];
        
        execute(path: kGTNRESTAPIPathAddressValidation, params: params, success: { (responseObj) in
            success(GTNAddressValidation(responseObj));
        }) { (error) in
            failure(error);
        };
    }
    
    // MARK: Utils
    func basicParams(_ addShowAllProducts: Bool = false)->[String: String]{
        var params = ["countryCode" : GTNConfig.sharedInstance.countryCode,
                      "languageCode" : GTNConfig.sharedInstance.languageCode,
                      "currencyCode" : GTNConfig.sharedInstance.currencyCode];
        if (addShowAllProducts){
            params["showAllProducts"] = GTNConfig.sharedInstance.showAllProducts ? "true" : "false"
        }
        return params;
    }
    
    // MARK: Execute calls
    func execute(_ baseUrl: String = serverURL(), path: String, method: String = kGTHttpMethodGET, serializer: GTNSerializer = .json, params: [String:String] = [:], rawData: String = "", useRecipeId: Bool = true, success:@escaping (_ responseObj: AnyObject) -> (), failure:@escaping (_ error: GTNError) -> ()){
        
        guard let baseURL = URL(string: baseUrl) else {return;}
        
        // validate GTNConfig
        if !GTNConfig.sharedInstance.isValid(){
            failure(GTNError(GTNErrorCode.invalidConfiguration));
            return;
        }
        
        let endpoint = useRecipeId ? "\(path)recipeid=\(GTNConfig.sharedInstance.recipeId)&" : "\(path)";
        
        printgt("GTNAPIClient url: \(baseURL.absoluteString)\(endpoint)");
        printgt("GTNAPIClient params: \(params)");
        printgt("GTNAPIClient rawData: \(rawData)");
        
        let urlConnection = GTNURLConnection(URL: baseURL);
        urlConnection.setResponseSerializer(serializer);
        
        if method == kGTHttpMethodPOST {
            var anyParams: AnyObject;
            if !rawData.isEmpty {
                anyParams = rawData.data(using: String.Encoding.utf8)! as AnyObject;
            } else {
                anyParams = params as AnyObject;
            }
            
            urlConnection.postToPath(endpoint, parameters: anyParams, success: { (response) in
                printgt("GTNAPIClient response: \(response)");
                success(response);
                }, failure: { (error) in
                    failure(error);
            });
        }
        
        if method == kGTHttpMethodGET {
            urlConnection.getFromPath(endpoint, parameters: params, success: { (response) in
                printgt("GTNAPIClient response: \(response)");
                success(response);
                }, failure: { (error) in
                    failure(error);
            });
        }
    }
}
