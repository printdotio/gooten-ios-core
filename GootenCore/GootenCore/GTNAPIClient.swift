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
    case .Staging:
        return kGTNServerURLStaging;
    case .Production:
        return kGTNServerURLProduction;
    case .QA:
        return kGTNServerURLQA;
    }
}

class GTNAPIClient {
    
    // MARK: Endpoint calls
    func getUserLocation(success success:(countryCode: String)->(), failure:(error: GTNError)->()) {
        execute(kGTNRESTAPIServerUserLocation, path: kGTNRESTAPIPathUserLocation, serializer: .RawData, useRecipeId: false, success: { (responseObj) in
            var resultS = String(data: responseObj as! NSData, encoding: NSUTF8StringEncoding)!;
            resultS = gtnUtilsReplace(resultS, pattern: "[^a-zA-Z0-9]", replacementPattern: "")!;
            success(countryCode: resultS);
        }) { (error) in
            failure(error: error);
        };
    }
    
    func getProducts(success success:(products: Array<GTNProduct>)->(), failure:(error: GTNError)->()){
        let params = basicParams(true);
        
        execute(path: kGTNRESTAPIPathProducts, params: params, success: { (responseObj) in
            guard let products = responseObj["Products"] as? [AnyObject]
                else {
                    failure(error: GTNError(.ParseJSONFailed));
                    return;
            }
            
            var productsArr: Array<GTNProduct> = [];
            for productJson in products {
                let product = GTNProduct(productJson);
                productsArr.append(product);
            }
            success(products: productsArr);
            
        }) { (error) in
            failure(error: error);
        };
    }
    
    func getProductVariants(productId productId: Int, success: (variants: Array<GTNProductVariant>)->(), failure: (error: GTNError)->()){
        var params = basicParams(true);
        params["productId"] = String(productId);
        
        execute(path: kGTNRESTAPIPathVariants, params: params, success: { (responseObj) in
            guard let variants = responseObj["ProductVariants"] as? [AnyObject]
                else {
                    failure(error: GTNError(.ParseJSONFailed));
                    return;
            }
            
            var variantsArr: Array<GTNProductVariant> = [];
            for variantJson in variants{
                let variant = GTNProductVariant(variantJson);
                variantsArr.append(variant);
            }
            success(variants: variantsArr);
            
        }) { (error) in
            failure(error: error);
        }
    }
    
    func getProductTemplates(sku sku: String, success: (templates: Array<GTNProductTemplate>)->(), failure: (error: GTNError)->()){
        var params = basicParams(true);
        params["sku"] = sku;
        
        execute(path: kGTNRESTAPIPathTemplates, params: params, success: { (responseObj) in
            guard let templates = responseObj["Options"] as? [AnyObject]
                else {
                    failure(error: GTNError(.ParseJSONFailed));
                    return;
            }
            
            var templatesArr: Array<GTNProductTemplate> = [];
            for templateJson in templates{
                let template = GTNProductTemplate(templateJson);
                templatesArr.append(template);
            }
            success(templates: templatesArr);
        }) { (error) in
            failure(error: error);
        };
    }
    
    func getRequiredImages(sku sku: String, templateName: String, success: (sizes: Array<GTNSize>)->(), failure: (error: GTNError)->()){
        getProductTemplates(sku: sku, success: { (templates) in
            
            var template: GTNProductTemplate = GTNProductTemplate();
            
            for t in templates {
                if t.name == templateName {
                    template = t;
                    break;
                }
            }
            
            if template.spaces.count == 0 {
                failure(error: GTNError(.InvalidTemplate));
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
            
            success(sizes: sizesArr);
            
        }) { (error) in
            failure(error: error);
        };
    }
    
    func getShippingOptions(postalCode postalCode: String, state: String, countryCode: String, items: Array<GTNShippingItem>, success:(options: Array<GTNShippingOption>)->(), failure:(error: GTNError)->()){
        
        if items.count == 0 {
            failure(error: GTNError(.NoItems));
            return;
        }
        
        var itemsArr: Array<Dictionary<String, AnyObject>> = [];
        
        for item in items{
            itemsArr.append(item.dict());
        }
        
        let params : [String : AnyObject] = ["ShipToPostalCode" : postalCode,
                                             "ShipToCountry" : countryCode,
                                             "ShipToState" : state,
                                             "LanguageCode" : GTNConfig.sharedInstance.languageCode,
                                             "CurrencyCode" : GTNConfig.sharedInstance.currencyCode,
                                             "Items" : itemsArr];
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding){
                execute(path: kGTNRESTAPIPathShippingPrices, method: kGTHttpMethodPOST, rawData: jsonString, success: { (responseObj) in
                    guard let resultsArr = responseObj["Result"] as? Array<AnyObject>
                        else {
                            failure(error: GTNError(.ParseJSONFailed));
                            return;
                    }
                    
                    var shippingOptionsArr: Array<GTNShippingOption> = [];
                    for item in resultsArr {
                        shippingOptionsArr.append((GTNShippingOption(item)));
                    }
                    success(options: shippingOptionsArr);
                    
                    }, failure: { (error) in
                        failure(error: error);
                });
            }
        } catch {
            failure(error: GTNError(.ParseJSONFailed));
        }
    }
    
    func getShipPriceEstimate(productId productId: Int, success:(shipPriceEstimate: GTNShipPriceEstimate)->(), failure:(error: GTNError)->()){
        var params = basicParams();
        params["productId"] = String(productId);
        
        execute(path: kGTNRESTAPIPathShipPriceEstimate, params: params, success: { (responseObj) in
            success(shipPriceEstimate: GTNShipPriceEstimate(responseObj));
        }) { (error) in
            failure(error: error);
        };
    }
    
    func getOrderStatus(orderId orderId: String, success:(orderStatus: GTNOrderStatus)->(), failure:(error: GTNError)->()){
        var params = basicParams();
        params["id"] = orderId;
        
        execute(path: kGTNRESTAPIPathOrders, params: params, success: { (responseObj) in
            success(orderStatus: GTNOrderStatus(responseObj));
        }) { (error) in
            failure(error: error);
        };
    }
    
    func getPaymentValidation(orderId orderId: String, paypalKey: String, success:(isValid: Bool)->(), failure:(error: GTNError)->()){
        var params = basicParams();
        params["OrderId"] = orderId;
        params["PayPalKey"] = paypalKey;
        
        execute(path: kGTNRESTAPIPathPaymentValidation, params: params, success: { (responseObj) in
            if let isValidResult = responseObj["IsValid"] as? Bool{
                success(isValid: isValidResult);
            } else {
                success(isValid: false);
            }
        }) { (error) in
            failure(error: error);
        };
    }
    
    // apple pay
    func getBraintreeClientToken(success success:(token: String)->(), failure:(error: GTNError)->()){
        execute(path: kGTNRESTAPIPathBraintreeClientToken, success: { (responseObj) in
            guard let tokenS = responseObj as? String else { return; }
            success(token: tokenS);
        }) { (error) in
            failure(error: error);
        };
    }
    
    func orderSubmitApplePay(shippingAddress shippingAddress: GTNAddress, billingAddress: GTNAddress, pkPayment: PKPayment, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], success:(orderId: String)->(), failure:(error: GTNError)->()){
        
        // first get braintree toket from our server
        self.getBraintreeClientToken(success: { (token) in
            if token.characters.count == 0 {
                return;
            }
            
            let braintree = Braintree(clientToken: token);
            braintree.tokenizeApplePayPayment(pkPayment, completion: { (nonce, error) in
                
                if error != nil {
                    failure(error: GTNError(.Custom, message: error.description));
                    return;
                }
                
                self.orderSubmit(shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, isPreSubmit: false, nonce: nonce,  success: { (orderId) in
                    success(orderId: orderId);
                }) { (error) in
                    failure(error: error);
                };
            });
            
        }) { (error) in
            failure(error: error);
        };
    }
    
    // paypal
    func orderSubmitPaypal(shippingAddress shippingAddress: GTNAddress, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], success:(orderId: String)->(), failure: (error: GTNError)->()){
        
        self.orderSubmit(shippingAddress, billingAddress: GTNAddress(), payment: payment, items: items, couponCodes: couponCodes, isPreSubmit: true, nonce: "", success: { (orderId) in
            success(orderId: orderId);
        }) { (error) in
            failure(error: error);
        };
    }
    
    // credit card - braintree
    func orderSubmitBraintree(shippingAddress shippingAddress: GTNAddress, billingAddress: GTNAddress, payment: GTNPaymentBraintree, items: [GTNOrderItem], couponCodes: [String], success:(orderId: String)->(), failure: (error: GTNError)->()){
        
        self.orderSubmit(shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, isPreSubmit: false, nonce: "", success: { (orderId) in
            success(orderId: orderId);
        }) { (error) in
            failure(error: error);
        };
    }
    
    // main submit order function
    func orderSubmit(shippingAddress: GTNAddress, billingAddress: GTNAddress, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], isPreSubmit: Bool, nonce: String, success:(orderId: String)->(), failure: (error: GTNError)->()){
        
        // create items array
        var itemsArr:[AnyObject] = [];
        for orderItem in items {
            itemsArr.append(orderItem.elements());
        }
        
        var jsonDict: Dictionary = ["ShipToAddress" :  shippingAddress.elements(),
                                    "BillingAddress" : billingAddress.elements(),
                                    "Items" : itemsArr,
                                    "Payment" : payment.elements(),
                                    "CouponCodes" : couponCodes,
                                    "Meta" : ["Source" : "ios-core", "Version" : GTNDefaults.SDKVersion],
                                    "isInTestMode" : (GTNConfig.sharedInstance.isInTestMode ? "true" : "false")];
        
        // paypal settings
        if isPreSubmit {
            jsonDict.removeValueForKey("BillingAddress");
            jsonDict["IsPreSubmit"] = "true";
        }
        
        // apple pay setting
        if nonce.characters.count > 0 {
            var paymentDict = payment.elements();
            paymentDict["braintreepaymentnonce"] = nonce;
            jsonDict["Payment"] = paymentDict;
        }
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions.PrettyPrinted)
            
            if let jsonString = String(data: jsonData, encoding: NSUTF8StringEncoding){
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
                            
                            failure(error: GTNError(.Custom, message: errorMessage));
                            return;
                        }
                    }
                    
                    if let orderId = responseObj["Id"] as? String {
                        success(orderId: orderId);
                        return;
                    }
                    
                    failure(error: GTNError(.ParseJSONFailed));
                    
                }) { (error) in
                    failure(error: error);
                };
            }
        } catch {
            failure(error: GTNError(.ParseJSONFailed));
        }
    }
    
    // MARK: Other, less important endopoints
    
    func getCountries(success success:(countries: Array<GTNCountry>)->(), failure:(error: GTNError)->()) {
        let params = basicParams();
        
        execute(path: kGTNRESTAPIPathCountries, params: params, success: { (responseObj) in
            guard let countriesArr = responseObj["Countries"] as? Array<AnyObject>
                else {
                    failure(error: GTNError(.ParseJSONFailed));
                    return;
            }
            
            var countries: Array<GTNCountry> = [];
            
            for country in countriesArr {
                countries.append(GTNCountry(country));
            }
            
            success(countries: countries);
            
        }) { (error) in
            failure(error: error);
        };
    }
    
    func getCurrencies(success success:(currencies: Array<GTNCurrency>)->(), failure:(error: GTNError)->()){
        let params = basicParams();
        
        execute(path: kGTNRESTAPIPathCurrencies, params: params, success: { (responseObj) in
            guard let currenciesArr = responseObj["Currencies"] as? Array<AnyObject>
                else {
                    failure(error: GTNError(.ParseJSONFailed));
                    return;
            }
            
            var currencies: Array<GTNCurrency> = [];
            
            for country in currenciesArr {
                currencies.append(GTNCurrency(country));
            }
            
            success(currencies: currencies);
            
        }) { (error) in
            failure(error: error);
        };
    }
    
    func getUserInfo(success success:(userInfo: GTNUserInfo)->(), failure:(error: GTNError)->()){
        let params = basicParams();
        
        execute(path: kGTNRESTAPIPathUserInfo, params: params, success: { (responseObj) in
            success(userInfo: GTNUserInfo(responseObj));
        }) { (error) in
            failure(error: error);
        };
    }
    
    func convertCurrency(fromCurrencyCode fromCurrencyCode: String, toCurrencyCode: String, amount: Double, success:(result: GTNPriceInfo)->(), failure:(error: GTNError)->()) {
        
        let params = ["fromCurrencyCode" : fromCurrencyCode, "toCurrencyCode" : toCurrencyCode, "amount" : String(amount)];
        
        execute(path: kGTNRESTAPIPathCurrencyConversion, params: params, success: { (responseObj) in
            success(result: GTNPriceInfo(responseObj));
        }) { (error) in
            failure(error: error);
        };
    }
    
    func validateAddress(address: GTNAddress, success:(result: GTNAddressValidation)->(), failure:(error: GTNError)->()){
        
        let params = ["line1" : address.line1, "line2" : address.line2, "city" : address.city, "state" : address.state, "postalCode" : address.postalCode, "countryCode" : address.countryCode];
        
        execute(path: kGTNRESTAPIPathAddressValidation, params: params, success: { (responseObj) in
            success(result: GTNAddressValidation(responseObj));
        }) { (error) in
            failure(error: error);
        };
    }
    
    // MARK: Utils
    func basicParams(addShowAllProducts: Bool = false)->[String: String]{
        var params = ["countryCode" : GTNConfig.sharedInstance.countryCode,
                      "languageCode" : GTNConfig.sharedInstance.languageCode,
                      "currencyCode" : GTNConfig.sharedInstance.currencyCode];
        if (addShowAllProducts){
            params["showAllProducts"] = GTNConfig.sharedInstance.showAllProducts ? "true" : "false"
        }
        return params;
    }
    
    // MARK: Execute calls
    func execute(baseUrl: String = serverURL(), path: String, method: String = kGTHttpMethodGET, serializer: GTNSerializer = .JSON, params: [String:String] = [:], rawData: String = "", useRecipeId: Bool = true, success:(responseObj: AnyObject) -> (), failure:(error: GTNError) -> ()){
        
        guard let baseURL = NSURL(string: baseUrl) else {return;}
        
        // validate GTNConfig
        if !GTNConfig.sharedInstance.isValid(){
            failure(error: GTNError(GTNErrorCode.InvalidConfiguration));
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
                anyParams = rawData.dataUsingEncoding(NSUTF8StringEncoding)!;
            } else {
                anyParams = params;
            }
            
            urlConnection.postToPath(endpoint, parameters: anyParams, success: { (response) in
                printgt("GTNAPIClient response: \(response)");
                success(responseObj: response);
                }, failure: { (error) in
                    failure(error: error);
            });
        }
        
        if method == kGTHttpMethodGET {
            urlConnection.getFromPath(endpoint, parameters: params, success: { (response) in
                printgt("GTNAPIClient response: \(response)");
                success(responseObj: response);
                }, failure: { (error) in
                    failure(error: error);
            });
        }
    }
}
