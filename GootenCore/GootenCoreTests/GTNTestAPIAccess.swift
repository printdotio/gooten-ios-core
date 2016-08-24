//
//  GTNTestUtils.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/7/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import XCTest

@testable import GootenCore

class GTNTestAPIAccess: XCTestCase {
    
    let braintreeEncryptedCCNumberRaw = "$bt3|ios_2_0_0$b8bkKRvWpZMgu4nWJPiR/Si23e3CEUJDxwl2T+k7qVq6zizzFZX9vqy7vJpRIwCxe1593kuDDjf+UfANH80RmoLqbod4CHRTKjEoFIv4ZlnvsRIsxhMQkRL2M7lVLA14PIw1VoDodihMh4dUDvnobzRxEjykPwM5z8GjlsSSL9GhiBxTyRTtBQ/kpbslxmPxnf0oZR+tF99WNqOSoD4qdah+gN+EJHVehOrRzsC/xgez340hoJ4albbQwWfEr/HS2WRgG6vlYWkK6KqMQZBf9mevFAOrJ3H8aomnEtbSTTZPp638xQAQV3qHZN7NFVQLzMVN11LTLvSPFg4qnwVbbg==$1aEH4NYveLcAAAAAAAAAAG2FwOaLCbW1iBeuR1ea1R4ZuDZCqGRffoGR5VIMTHfP";
    
    let braintreeEncryptedCCExpDateRaw = "$bt3|ios_2_0_0$mk0xUWfcTaBt//YS2TSrpr//xAr8fGwgHJgdH+PFqTIwCxb035ic4uBjuJsywOCeLJ3/A5UEChiIA8I+BIgackf1MO2pGBUcpiYEh6LtmGpYfXxhCtHZCngVcYQK/f2n832a+Ao7eBlLvoVlWGo+LC7JtAz779UgoNPkjeNKg1Y9lt0fP7NDqREXipjJZ2a8tnfl8+gONAmJPnslCFaj8mO73+2xbD/2SurW2CyC8mL0ucrOPvoqk4GsQxbi+oHAxTpWip3CPgYaPeloqEMrhjFVEzxwfktPmCs4YD4zXXei6qJgf04hFNUYqolvw4Jh+eU1iNz3oC1jqgt2OyWXrw==$VCI95P8CILAwCJDe5X8AADG+5mOi5Nk5IeAyB8Z3g1I=";
    
    let braintreeEncryptedCCVRaw = "$bt3|ios_2_0_0$InS/s77PLxuYQbp4eie5klpsXn6Ims8caT7RodaKG87Ho1cPHoYoNj28Ci1YSJM3Q0I3yLEF1EhAamS5QW5MLVxkCQNcskjYKl6ZmbRIoYO26B09iLcSbGoDIhGnZpsN1O36BgJECXi70Gp1+IqpTj0ce3q6pJ/yzgWsEQ82DvhTbMoDL8f6/Mk1vut1CZuDCyOp1LUVXnSJgJGWD7XanuD3GA73olWHVSbPzgeN9lHNKkH1VPdJIa3BQBICOoftcsx0a2VSNaZ3gy39h6W1qkz+RvTMtlSw3hlrn9Jv/jWr2WOnuuuCqGxfgVmkjCZCNEBtj8HtoSOj9N983+lj2g==$ERc5nw/zZ8EQFefZ5X8AAB5h9Em8D9V8JbKOz84HLzI=";
    
    var urlConnection = GTNURLConnection(URL: NSURL(string: serverURL())!);
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMissingRecipeId() {
        let expectation = expectationWithDescription("wait to get result of missing recipe id");
        
        let core = GTNCore()
        core.setConfig(GTNConfig());
        
        core.getProducts(success: { (products) in
            XCTAssert(products.count == 0, "should be empty array");
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count > 0, "should contain error message");
            print("error message: \(error.message())");
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    func testGetLocation(){
        let expectation = expectationWithDescription("wait to get user location");
        
        let core = GTNCore()
        core.getUserLocation(success: {(countryCode) in
            XCTAssert(countryCode.characters.count == 2, "country code should be 2 chars");
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    func testGetProductsWORecipeId(){
        // test without setting recipe id in GTNConfig
        let expectation = expectationWithDescription("wait to get products2");
        
        let core = GTNCore()
        core.setConfig(GTNConfig());
        
        core.getProducts(success: { (products) in
            XCTAssert(products.count == 0, "should be empty array");
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count > 0, "should contain error message");
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    func testGetProducts(){
        let expectation = expectationWithDescription("wait to get products1");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getProducts(success: { (products) in
            XCTAssert(products.count > 0, "should be > 0");
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    func testGetProductVariants(){
        let expectation = expectationWithDescription("wait to get product variants");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getProductVariants(productId: 43, success: { (variants) in
            XCTAssert(variants.count > 0, "should be > 0");
            for variant in variants {
                GTNTestModels.verifyVariant(variant);
                
                XCTAssert(variant.options.count > 0, "missing options");
                for option in variant.options {
                    GTNTestModels.verifyVariantOption(option);
                }
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testGetProductTemplates(){
        let expectation = expectationWithDescription("wait to get product variants");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getProductTemplates(sku: "CanvsWrp-BlkWrp-8x10", success: { (templates) in
            XCTAssert(templates.count > 0, "should be > 0");
            
            for template in templates {
                GTNTestModels.verifyTemplate(template);
                
                XCTAssert(template.spaces.count > 0, "missing spaces");
                for space in template.spaces {
                    GTNTestModels.verifySpace(space);
                    
                    XCTAssert(space.layers.count > 0, "missing layers");
                    for layer in space.layers {
                        GTNTestModels.verifyLayer(layer);
                    }
                }
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testGetRequiredImages(){
        let expectation = expectationWithDescription("wait to get required images");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getRequiredImages(sku: "CanvsWrp-BlkWrp-8x10", templateName: "Single", success: { (sizes) in
            print("sizes: \(sizes)");
            XCTAssert(sizes.count == 1, "should be only one image");
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testGetShipPriceEstimate(){
        let expectation = expectationWithDescription("wait to get ship price estimate");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getShipPriceEstimate(productId: 43, success: { (shipPriceEstimate) in
            GTNTestModels.verifyShipPriceEstimate(shipPriceEstimate);
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testGetShippingPrices(){
        let expectation = expectationWithDescription("wait to get shipping prices");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getShippingOptions(postalCode: "90210", state: "CA", countryCode: "US", items: [GTNShippingItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1)], success: { (options) in
            
            XCTAssert(options.count > 0, "should return shipping prices");
            for shipPrice in options {
                GTNTestModels.verifyShippingOption(shipPrice);
                
                for sku in shipPrice.skus{
                    XCTAssert(sku.characters.count > 1, "sku should be grather than 1 charachter");
                }
                
                for shipOption in shipPrice.shipOptions{
                    GTNTestModels.verifySingleShipOption(shipOption);
                }
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testGetPaymentValidation(){
        let expectation = expectationWithDescription("wait to get payment validation");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getPaymentValidation(orderId: "12345", paypalKey: "12345", success: { (isValid) in
            XCTAssert(isValid == false, "this should not be valid");
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        }
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testOrderStatus(){
        let orderId = "13-b399e5dd-b3da-4807-abf3-56be87909c61" // it could be changed in the future !!!
        
        let expectation = expectationWithDescription("wait to get payment validation");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getOrderStatus(orderId: orderId, success: { (orderStatus) in
            XCTAssert(orderStatus.id.characters.count > 0, "should be > 0");
            XCTAssert(orderStatus.niceId.characters.count > 0, "should be > 0");
            XCTAssert(orderStatus.sourceId.characters.count > 0, "should be > 0");
            
            XCTAssert(orderStatus.items.count > 0, "should be > 0");
            for item in orderStatus.items{
                // shipments: to e tested TO-DO
                XCTAssert(item.sku.characters.count > 0, "should be > 0");
                XCTAssert(item.productId > 0, "should be > 0");
                XCTAssert(item.product.characters.count > 0, "should be > 0");
                XCTAssert(item.quantity > 0, "should be > 0");
                XCTAssert(item.status.characters.count > 0, "should be > 0");
                GTNTestModels.verifyPriceInfo(item.price);
                GTNTestModels.verifyPriceInfo(item.discountAmount, isDiscount: true);
                XCTAssert(item.meta.count > 0, "should be > 0");
            }
            
            GTNTestModels.verifyPriceInfo(orderStatus.total);
            GTNTestModels.verifyPriceInfo(orderStatus.shippingTotal);
            // GTNTestModels.verifyAddress(orderStatus.shippingAddress);
            // GTNTestModels.verifyAddress(orderStatus.billingAddress);
            
            XCTAssert(orderStatus.meta.count > 0, "should be > 0");
            
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        }
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testOrderSubmitViaBraintree(){
        let expectation = expectationWithDescription("wait to submit an order via braintree");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        config.isInTestMode = true;
        core.setConfig(config);
        
        let shippingAddress = GTNAddress(firstName: "Lepa", lastName: "Brena", line1: "641 Highland Ave", line2: "", city: "Los Angeles", state: "CA", countryCode: "US", postalCode: "90036", phone: "1234", email: "kiki@nini.com");
        
        let billingAddress = shippingAddress;
        
        let payment = GTNPaymentBraintree(braintreeEncryptedCCNumber: braintreeEncryptedCCNumberRaw, braintreeEncryptedCCExpDate: braintreeEncryptedCCExpDateRaw, braintreeEncryptedCCV: braintreeEncryptedCCVRaw, currencyCode: "USD", total: 33.26);
        
        let couponCodes = [""];
        
        let image1 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        let image2 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        
        let orderItem1 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image1, image2], meta: ["":""]);
        let orderItem2 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image2, image1], meta: ["":""]);
        
        let items = [orderItem1, orderItem2];
        
        core.orderSubmitBraintree(shippingAddress: shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            
            print("ORDER ID BRAINTREE: \(orderId)");
            XCTAssert(orderId.characters.count > 0, "missing order id");
            expectation.fulfill();
        }) { (error) in
            print("errorMessage: \(error.message())")
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(30.0, handler: nil);
    }
    
    func testOrderSubmitViaBraintreeMissingShippingAddress(){
        let expectation = expectationWithDescription("wait to submit an order via braintree");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        config.isInTestMode = true;
        core.setConfig(config);
        
        let shippingAddress = GTNAddress();
        let billingAddress = shippingAddress;
        
        let payment = GTNPaymentBraintree(braintreeEncryptedCCNumber: braintreeEncryptedCCNumberRaw, braintreeEncryptedCCExpDate: braintreeEncryptedCCExpDateRaw, braintreeEncryptedCCV: braintreeEncryptedCCVRaw, currencyCode: "USD", total: 33.26);
        
        let couponCodes = [""];
        
        let image1 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        let image2 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        
        let orderItem1 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image1, image2], meta: ["":""]);
        let orderItem2 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image2, image1], meta: ["":""]);
        
        let items = [orderItem1, orderItem2];
        
        core.orderSubmitBraintree(shippingAddress: shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            
            print("ORDER ID BRAINTREE: \(orderId)");
            XCTAssert(orderId.characters.count == 0, "no order id");
            expectation.fulfill();
        }) { (error) in
            print("errorMessage: \(error.message())")
            XCTAssert(error.message().characters.count > 0, "shouldn fire an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(30.0, handler: nil);
    }
    
    func testOrderSubmitViaBraintreeMissingBillingAddress(){
        let expectation = expectationWithDescription("wait to submit an order via braintree");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        config.isInTestMode = true;
        core.setConfig(config);
        
        let shippingAddress = GTNAddress(firstName: "Lepa", lastName: "Brena", line1: "641 Highland Ave", line2: "", city: "Los Angeles", state: "CA", countryCode: "US", postalCode: "90036", phone: "1234", email: "kiki@nini.com");
        
        let billingAddress = GTNAddress();
        
        let payment = GTNPaymentBraintree(braintreeEncryptedCCNumber: braintreeEncryptedCCNumberRaw, braintreeEncryptedCCExpDate: braintreeEncryptedCCExpDateRaw, braintreeEncryptedCCV: braintreeEncryptedCCVRaw, currencyCode: "USD", total: 33.26);
        
        let couponCodes = [""];
        
        let image1 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        let image2 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        
        let orderItem1 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image1, image2], meta: ["":""]);
        let orderItem2 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image2, image1], meta: ["":""]);
        
        let items = [orderItem1, orderItem2];
        
        core.orderSubmitBraintree(shippingAddress: shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            XCTAssert(orderId.characters.count == 0, "shoudn't be order id");
            expectation.fulfill();
        }) { (error) in
            print("errorMessage: \(error.message())")
            XCTAssert(error.message().characters.count > 0, "shouldn fire an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(30.0, handler: nil);
    }
    
    func testOrderSubmitViaBraintreeMissingPayment(){
        let expectation = expectationWithDescription("wait to submit an order via braintree");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        config.isInTestMode = true;
        core.setConfig(config);
        
        let shippingAddress = GTNAddress(firstName: "Lepa", lastName: "Brena", line1: "641 Highland Ave", line2: "", city: "Los Angeles", state: "CA", countryCode: "US", postalCode: "90036", phone: "1234", email: "kiki@nini.com");
        
        let billingAddress = GTNAddress();
        
        let payment = GTNPaymentBraintree(braintreeEncryptedCCNumber: "", braintreeEncryptedCCExpDate: "", braintreeEncryptedCCV: "", currencyCode: "USD", total: 33.26);
        
        let couponCodes = [""];
        
        let image1 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        let image2 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        
        let orderItem1 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image1, image2], meta: ["":""]);
        let orderItem2 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image2, image1], meta: ["":""]);
        
        let items = [orderItem1, orderItem2];
        
        core.orderSubmitBraintree(shippingAddress: shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            XCTAssert(orderId.characters.count == 0, "shoudn't be order id");
            expectation.fulfill();
        }) { (error) in
            print("errorMessage: \(error.message())")
            XCTAssert(error.message().characters.count > 0, "shouldn fire an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(30.0, handler: nil);
    }
    
    
    func testOrderSubmitViaBraintreeMissingCurrencyCode(){
        let expectation = expectationWithDescription("wait to submit an order via braintree");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        config.isInTestMode = true;
        core.setConfig(config);
        
        let shippingAddress = GTNAddress(firstName: "Lepa", lastName: "Brena", line1: "641 Highland Ave", line2: "", city: "Los Angeles", state: "CA", countryCode: "US", postalCode: "90036", phone: "1234", email: "kiki@nini.com");
        
        let billingAddress = GTNAddress();
        
        let payment = GTNPaymentBraintree(braintreeEncryptedCCNumber: braintreeEncryptedCCNumberRaw, braintreeEncryptedCCExpDate: braintreeEncryptedCCExpDateRaw, braintreeEncryptedCCV: braintreeEncryptedCCVRaw, currencyCode: "", total: 33.26);
        
        let couponCodes = [""];
        
        let image1 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        let image2 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        
        let orderItem1 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image1, image2], meta: ["":""]);
        let orderItem2 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image2, image1], meta: ["":""]);
        
        let items = [orderItem1, orderItem2];
        
        core.orderSubmitBraintree(shippingAddress: shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            XCTAssert(orderId.characters.count == 0, "shoudn't be order id");
            expectation.fulfill();
        }) { (error) in
            print("errorMessage: \(error.message())")
            XCTAssert(error.message().characters.count > 0, "shouldn fire an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(30.0, handler: nil);
    }

    
    func testOrderSubmitViaPaypal(){
        let expectation = expectationWithDescription("wait to submit an order via paypal");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        config.isInTestMode = true;
        core.setConfig(config);
        
        let shippingAddress = GTNAddress(firstName: "Lepa", lastName: "Brena", line1: "641 Highland Ave", line2: "", city: "Los Angeles", state: "CA", countryCode: "US", postalCode: "90036", phone: "1234", email: "kiki@nini.com");
        
        let payment = GTNPayment(currencyCode: "USD", total: 33.26);
        
        let couponCodes = [""];
        
        let image1 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        let image2 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        
        let orderItem1 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image1, image2], meta: ["":""]);
        let orderItem2 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image2, image1], meta: ["":""]);
        
        let items = [orderItem1, orderItem2];
        
        core.orderSubmitPaypal(shippingAddress: shippingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            
            print("ORDER ID PAYPAL: \(orderId)");
            XCTAssert(orderId.characters.count > 0, "missing order id");
            expectation.fulfill();
        }) { (error) in
            print("errorMessage: \(error.message())")
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(30.0, handler: nil);
    }
    
    func testOrderSubmitApplePay(){
        let expectation = expectationWithDescription("wait to submit order via ApplePay");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "00000000-0000-0000-0000-000000000000";
        config.environment = GTNEnvironment.Staging;
        core.setConfig(config);
        
        let shippingAddress = GTNAddress(firstName: "Lepa", lastName: "Brena", line1: "641 Highland Ave", line2: "", city: "Los Angeles", state: "CA", countryCode: "US", postalCode: "90036", phone: "1234", email: "kiki@nini.com");
        
        let billingAddress = shippingAddress;
        
        let payment = GTNPayment(currencyCode: "USD", total: 34.98);
        
        let couponCodes = [""];
        
        let image1 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        let image2 = GTNOrderItemImage(url: "http://roa.h-cdn.co/assets/15/39/980x490/landscape-1443100986-x3.jpg", index: 1, thumbnailUrl: "", manipCommand: "");
        
        let orderItem1 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image1, image2], meta: ["":""]);
        let orderItem2 = GTNOrderItem(sku: "CanvsWrp-BlkWrp-8x10", quantity: 1, shipCarrierMethod: 1, images: [image2, image1], meta: ["":""]);
        
        let items = [orderItem1, orderItem2];
        
        // create fake PKPayment
        let pkPayment = PKPayment();
        //pkPayment.token
        
        core.orderSubmitApplePay(shippingAddress: shippingAddress, billingAddress: billingAddress, pkPayment: pkPayment, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in
            print("ORDER ID APPLEPAY: \(orderId)");
            XCTAssert(orderId.characters.count > 0, "missing order id");
            expectation.fulfill();
        }) { (error) in
            print("errorMessage: \(error.message())")
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    // MARK:
    
    func testGetCountries(){
        let expectation = expectationWithDescription("wait to get countries");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getCountries(success: { (countries) in
            XCTAssert(countries.count > 0, "missing countries");
            
            for country in countries {
                GTNTestModels.verifyCountry(country);
                GTNTestModels.verifyCurrency(country.defaultCurrency);
            }
            
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testGetCurrencies(){
        let expectation = expectationWithDescription("wait to get currencies");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getCurrencies(success: { (currencies) in
            XCTAssert(currencies.count > 0, "missing currencies");
            for currency in currencies {
                GTNTestModels.verifyCurrency(currency);
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testGetUserInfo(){
        let expectation = expectationWithDescription("wait to get user info");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.getUserInfo(success: { (userInfo) in
            GTNTestModels.verifyUserInfo(userInfo);
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testCurrencyConversion(){
        let expectation = expectationWithDescription("wait to get user info");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        core.convertCurrency(fromCurrencyCode: "USD", toCurrencyCode: "RSD", amount: 1.0, success: { (result) in
            GTNTestModels.verifyPriceInfo(result);
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    func testAddressValidation(){
        let expectation = expectationWithDescription("wait to get user info");
        
        let core = GTNCore()
        let config = GTNConfig();
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
        
        let address = GTNAddress();
        address.line1 = "641 Highland Ave";
        address.city = "Los Angeles";
        address.state = "CA";
        address.postalCode = "90036";
        address.countryCode = "US";
        
        core.validateAddress(address, success: { (result) in
            GTNTestModels.verifyAddressValidation(result);
            GTNTestModels.verifyProposedAddress(result.proposedAddress);
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error")
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(15.0, handler: nil);
    }
    
    // MARK:
    
    func testDictToString() {
        let params = urlConnection.stringFromParams(["key1":"value1", "key2":"value2"])
        XCTAssert(params == "key1=value1&key2=value2", "bad parsing");
    }
}
