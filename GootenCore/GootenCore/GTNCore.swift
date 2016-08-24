//
//  GTNCore.swift
//  GootenCore
//
//  Created by Boro Perisic on 6/30/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

public class GTNCore : NSObject{
    
    var restClient: GTNAPIClient;
    
    public override init() {
        self.restClient = GTNAPIClient();
    }
    
    public func setConfig(configuration: GTNConfig){
        GTNConfig.sharedInstance.copy(from: configuration);
    }
    
    public func config()->GTNConfig{
        return GTNConfig.sharedInstance;
    }
    
    // MARK: Public functions
    public func getUserLocation(success success:(countryCode: String)->(), failure:(error: GTNError)->()){
        restClient.getUserLocation(success: { (countryCode) in
            success(countryCode: countryCode);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getProducts(success success:(products: Array<GTNProduct>)->(), failure:(error: GTNError)->()){
        restClient.getProducts(success: { (products) in
            success(products: products);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getProductVariants(productId productId: Int, success:(variants: Array<GTNProductVariant>)->(), failure:(error: GTNError)->()){
        restClient.getProductVariants(productId: productId, success: { (variants) in
            success(variants: variants);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getRequiredImages(sku sku: String, templateName: String, success: (sizes: Array<GTNSize>)->(), failure: (error: GTNError)->()){
        restClient.getRequiredImages(sku: sku, templateName: templateName, success: { (sizes) in
            success(sizes: sizes);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getProductTemplates(sku sku: String, success:(templates: Array<GTNProductTemplate>)->(), failure:(error: GTNError)->()){
        restClient.getProductTemplates(sku: sku, success: { (templates) in
            success(templates: templates);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getShippingOptions(postalCode postalCode: String, state: String, countryCode: String, items: Array<GTNShippingItem>, success:(options: Array<GTNShippingOption>)->(), failure:(error: GTNError)->()){
        restClient.getShippingOptions(postalCode: postalCode, state: state, countryCode: countryCode, items: items, success: { (shippingPrices) in
            success(options: shippingPrices);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getShipPriceEstimate(productId productId: Int, success:(shipPriceEstimate: GTNShipPriceEstimate)->(), failure:(error: GTNError)->()){
        restClient.getShipPriceEstimate(productId: productId, success: { (shipPriceEstimate) in
            success(shipPriceEstimate: shipPriceEstimate);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getPaymentValidation(orderId orderId: String, paypalKey: String, success:(isValid: Bool)->(), failure:(error: GTNError)->()){
        restClient.getPaymentValidation(orderId: orderId, paypalKey: paypalKey, success: { (isValid) in
            success(isValid: isValid);
        }) { (error) in
            failure(error: error);
        }
    }
    
    public func getOrderStatus(orderId orderId: String, success:(orderStatus: GTNOrderStatus)->(), failure:(error: GTNError)->()){
        restClient.getOrderStatus(orderId: orderId, success: { (orderStatus) in
            success(orderStatus: orderStatus);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func orderSubmitApplePay(shippingAddress shippingAddress: GTNAddress, billingAddress: GTNAddress, pkPayment: PKPayment, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], success:(orderId: String)->(), failure:(error: GTNError)->()){
        restClient.orderSubmitApplePay(shippingAddress: shippingAddress, billingAddress: billingAddress, pkPayment: pkPayment, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            success(orderId: orderId);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func orderSubmitBraintree(shippingAddress shippingAddress: GTNAddress, billingAddress: GTNAddress, payment: GTNPaymentBraintree, items: [GTNOrderItem], couponCodes: [String], success:(orderId: String)->(), failure: (error: GTNError)->()){
        restClient.orderSubmitBraintree(shippingAddress: shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            success(orderId: orderId);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func orderSubmitPaypal(shippingAddress shippingAddress: GTNAddress, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], success:(orderId: String)->(), failure: (error: GTNError)->()){
        restClient.orderSubmitPaypal(shippingAddress: shippingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            success(orderId: orderId);
        }) { (error) in
            failure(error: error);
        };
    }
    
    // MARK: Other
    
    public func getCountries(success success:(countries: Array<GTNCountry>)->(), failure:(error: GTNError)->()) {
        restClient.getCountries(success: { (countries) in
            success(countries: countries);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getCurrencies(success success:(currencies: Array<GTNCurrency>)->(), failure:(error: GTNError)->()){
        restClient.getCurrencies(success: { (currencies) in
            success(currencies: currencies);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public func getUserInfo(success success:(userInfo: GTNUserInfo)->(), failure:(error: GTNError)->()){
        restClient.getUserInfo(success: { (userInfo) in
            success(userInfo: userInfo);
        }) { (error) in
            failure(error: error);
        };
    }
    
    public  func convertCurrency(fromCurrencyCode fromCurrencyCode: String, toCurrencyCode: String, amount: Double, success:(result: GTNPriceInfo)->(), failure:(error: GTNError)->()) {
        restClient.convertCurrency(fromCurrencyCode: fromCurrencyCode, toCurrencyCode: toCurrencyCode, amount: amount, success: { (result) in
            success(result: result);
        }) { (error) in
            failure(error: error);
        }
    }
    
    public func validateAddress(address: GTNAddress, success:(result: GTNAddressValidation)->(), failure:(error: GTNError)->()){
        restClient.validateAddress(address, success: { (result) in
            success(result: result);
        }) { (error) in
            failure(error: error);
        };
    }
}



