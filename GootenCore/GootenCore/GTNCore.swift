//
//  GTNCore.swift
//  GootenCore
//
//  Created by Boro Perisic on 6/30/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

open class GTNCore : NSObject{
    
    var restClient: GTNAPIClient;
    
    public override init() {
        self.restClient = GTNAPIClient();
    }
    
    open func setConfig(_ configuration: GTNConfig){
        GTNConfig.sharedInstance.copy(from: configuration);
    }
    
    open func config()->GTNConfig{
        return GTNConfig.sharedInstance;
    }
    
    // MARK: Public functions
    open func getUserLocation(success:@escaping (_ countryCode: String)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getUserLocation(success: { (countryCode) in
            success(countryCode);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getProducts(success:@escaping (_ products: Array<GTNProduct>)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getProducts(success: { (products) in
            success(products);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getProductVariants(productId: Int, success:@escaping (_ variants: Array<GTNProductVariant>)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getProductVariants(productId: productId, success: { (variants) in
            success(variants);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getRequiredImages(sku: String, templateName: String, success:@escaping (_ sizes: Array<GTNSize>)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getRequiredImages(sku: sku, templateName: templateName, success: { (sizes) in
            success(sizes);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getProductTemplates(sku: String, success:@escaping (_ templates: Array<GTNProductTemplate>)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getProductTemplates(sku: sku, success: { (templates) in
            success(templates);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getShippingOptions(postalCode: String, state: String, countryCode: String, items: Array<GTNShippingItem>, success:@escaping (_ options: Array<GTNShippingOption>)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getShippingOptions(postalCode: postalCode, state: state, countryCode: countryCode, items: items, success: { (shippingPrices) in
            success(shippingPrices);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getShipPriceEstimate(productId: Int, success:@escaping (_ shipPriceEstimate: GTNShipPriceEstimate)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getShipPriceEstimate(productId: productId, success: { (shipPriceEstimate) in
            success(shipPriceEstimate);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getPaymentValidation(orderId: String, paypalKey: String, success:@escaping (_ isValid: Bool)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getPaymentValidation(orderId: orderId, paypalKey: paypalKey, success: { (isValid) in
            success(isValid);
        }) { (error) in
            failure(error);
        }
    }
    
    open func getOrderStatus(orderId: String, success:@escaping (_ orderStatus: GTNOrderStatus)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getOrderStatus(orderId: orderId, success: { (orderStatus) in
            success(orderStatus);
        }) { (error) in
            failure(error);
        };
    }
    
    open func orderSubmitApplePay(shippingAddress: GTNAddress, billingAddress: GTNAddress, pkPayment: PKPayment, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], success:@escaping (_ orderId: String)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.orderSubmitApplePay(shippingAddress: shippingAddress, billingAddress: billingAddress, pkPayment: pkPayment, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            success(orderId);
        }) { (error) in
            failure(error);
        };
    }
    
    open func orderSubmitBraintree(shippingAddress: GTNAddress, billingAddress: GTNAddress, payment: GTNPaymentBraintree, items: [GTNOrderItem], couponCodes: [String], success:@escaping (_ orderId: String)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.orderSubmitBraintree(shippingAddress: shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            success(orderId);
        }) { (error) in
            failure(error);
        };
    }
    
    open func orderSubmitPaypal(shippingAddress: GTNAddress, payment: GTNPayment, items: [GTNOrderItem], couponCodes: [String], success:@escaping (_ orderId: String)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.orderSubmitPaypal(shippingAddress: shippingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            success(orderId);
        }) { (error) in
            failure(error);
        };
    }
    
    open func orderPriceEstimate(shippingAddress: GTNAddress, items: [GTNOrderItem], currencyCode: String, couponCodes: [String], success:@escaping (_ priceEstimate: GTNPriceEstimate)->(), failure:@escaping (_ error: GTNError)->()) {
        restClient.orderPriceEstimate(shippingAddress: shippingAddress, items: items, currencyCode: currencyCode, couponCodes: couponCodes, success: { (priceEstimate) in
            success(priceEstimate)
        }) { (error) in
            failure(error)
        }
    }
    
    // MARK: Other
    
    open func getCountries(success:@escaping (_ countries: Array<GTNCountry>)->(), failure:@escaping (_ error: GTNError)->()) {
        restClient.getCountries(success: { (countries) in
            success(countries);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getCurrencies(success:@escaping (_ currencies: Array<GTNCurrency>)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getCurrencies(success: { (currencies) in
            success(currencies);
        }) { (error) in
            failure(error);
        };
    }
    
    open func getUserInfo(success:@escaping (_ userInfo: GTNUserInfo)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.getUserInfo(success: { (userInfo) in
            success(userInfo);
        }) { (error) in
            failure(error);
        };
    }
    
    open func convertCurrency(fromCurrencyCode: String, toCurrencyCode: String, amount: Double, success:@escaping (_ result: GTNPriceInfo)->(), failure:@escaping (_ error: GTNError)->()) {
        restClient.convertCurrency(fromCurrencyCode: fromCurrencyCode, toCurrencyCode: toCurrencyCode, amount: amount, success: { (result) in
            success(result);
        }) { (error) in
            failure(error);
        }
    }
    
    open func validateAddress(_ address: GTNAddress, success:@escaping (_ result: GTNAddressValidation)->(), failure:@escaping (_ error: GTNError)->()){
        restClient.validateAddress(address, success: { (result) in
            success(result);
        }) { (error) in
            failure(error);
        };
    }
}



