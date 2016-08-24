//
//  GTNTestURLConnection.swift
//  GootenCore
//
//  Created by Boro Perisic on 7/7/16.
//  Copyright © 2016 Gooten. All rights reserved.
//

import XCTest

@testable import GootenCore

class GTNTestModels: XCTestCase {
    
    let productJSON = "{\"Id\": 1151, \"UId\": \"Adjustable Strap Totes\", \"Name\": \"Adjustable Strap Totes\", \"ShortDescription\": \"Get a unique adjustable strap tote bag and even a trip to the farmer’s market will feel like a strut on the catwalk!\", \"HasAvailableProductVariants\": true, \"HasProductTemplates\": true, \"IsFeatured\": false, \"IsComingSoon\": false, \"MaxZoom\": 1.5, \"RetailPrice\": { \"Price\": 32.06, \"CurrencyCode\": \"USD\", \"FormattedPrice\": \"$32.06\", \"CurrencyFormat\": \"${1}\", \"CurrencyDigits\": 2 }, \"Info\": [ { \"Content\": [ \"Want to look fashionable every time you leave home? Get a unique adjustable strap tote bag and even a trip to the farmer’s market will feel like a strut on the catwalk!\" ], \"ContentType\": \"Text\", \"Index\": 1 }, { \"Content\": [ \"16x16\", \"18x18\"\" ], \"ContentType\": \"List\", \"Key\": \"Size\", \"Index\": 1 }, { \"Content\": [ \"Made in the USA. Spun poly material - Black nonwoven laminate inside, black cotton web handles.\" ], \"ContentType\": \"List\", \"Key\": \"Material\", \"Index\": 2 }, { \"Content\": [ \"Machine wash separately in cold water, use delicate cycle only. Do not bleach and tumble dry on low. Do not iron, press with heat or dry clean.\" ], \"ContentType\": \"List\", \"Key\": \"Care of\", \"Index\": 3 }, { \"Content\": [ \"Grey poly bag\" ], \"ContentType\": \"List\", \"Key\": \"Packaging\", \"Index\": 4 }, { \"Content\": [ \"3-4 days\" ], \"ContentType\": \"List\", \"Key\": \"Production time\", \"Index\": 5 }, { \"Content\": [ \"7 Days\" ], \"ContentType\": \"List\", \"Key\": \"Est. Domestic Arrival\", \"Index\": 6 }, { \"Content\": [ \"7 - 21 Days\" ], \"ContentType\": \"List\", \"Key\": \"Est. International Arrival\", \"Index\": 7 } ], \"Images\": [ { \"Url\": \"http://cdn.print.io/temp/1151-f3b8-AdjustableStrap_Stars_Front_296x307.png\", \"Index\": 0, \"Id\": \"3285\", \"ImageTypes\": [ \"Web2aLargeRightSide\" ] }, { \"Url\": \"http://cdn.print.io/temp/1151-b01f-AdjustableStrap_Stars_Front_612Sq.png\", \"Index\": 0, \"Id\": \"3286\", \"ImageTypes\": [ \"AppFeatured\" ] }, { \"Url\": \"http://cdn.print.io/temp/1151-a98d-AdjustableStrap_Stars_Profile_544x355.png\", \"Index\": 0, \"Id\": \"3287\", \"ImageTypes\": [ \"Web2bDetailsPage\" ] }, { \"Url\": \"http://cdn.print.io/temp/1151-b76a-AdjustableStrap_Stars_Front_227x280.png\", \"Index\": 0, \"Id\": \"3288\", \"ImageTypes\": [ \"AppGrid\" ] }, { \"Url\": \"http://cdn.print.io/temp/1151-6478-AdjustableStrap_Stars_Profile_700x500.png\", \"Index\": 0, \"Id\": \"3289\", \"ImageTypes\": [ \"AppDetails\" ] }, { \"Url\": \"http://cdn.print.io/temp/1151-a7f7-AdjustableStrap_Stars_HalfProfile_544x355.png\", \"Index\": 2, \"Id\": \"3292\", \"ImageTypes\": [ \"Web2bDetailsPage\" ] }, { \"Url\": \"http://cdn.print.io/temp/1151-1c5d-AdjustableStrap_Stars_HalfProfile_700x500.png\", \"Index\": 2, \"Id\": \"3293\", \"ImageTypes\": [ \"AppDetails\" ] } ], \"PriceInfo\": { \"Price\": 27.06, \"CurrencyCode\": \"USD\", \"FormattedPrice\": \"$27.06\", \"CurrencyFormat\": \"${1}\", \"CurrencyDigits\": 2 }, \"Categories\": [ { \"Id\": \"6\", \"Name\": \"Apparel\" }]}";
    
    let layerJSON = "{\"Id\":\"3ffa\", \"Type\":\"Image\", \"DefaultText\":\"sample text\"}";
    
    let productCategoryJSON = "{\"Name\":\"Test\", \"Id\":\"123\"}";
    
    let core = GTNCore();
    let config = GTNConfig();
    
    override func setUp() {
        super.setUp()
        
        config.recipeId = "f255af6f-9614-4fe2-aa8b-1b77b936d9d6";
        core.setConfig(config);
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Product
    func testProductCreationFromHardcodedJSON(){
        do {
            if let data = productJSON.dataUsingEncoding(NSUTF8StringEncoding){
                print("IMAMO DATA");
                let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments)
                let product = GTNProduct(parsedObject);
                GTNTestModels.verifyProduct(product);
                print("prosao");
            }
        } catch {
            
        }
    }
    
    func testProductCreationFromServer(){
        let expectation = expectationWithDescription("wait to get all products");
        
        core.getProducts(success: { (products) in
            for product in products{
                GTNTestModels.verifyProduct(product);
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error");
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    internal static func verifyProduct(product: GTNProduct){
        XCTAssert(product.id > 0, "missing product id");
        XCTAssert(product.name.characters.count > 0, "missing product name");
        XCTAssert(product.shortDescription.characters.count > 0, "missing short description");
        verifyPriceInfo(product.retailPrice);
        verifyPriceInfo(product.priceInfo);
        
        XCTAssert(product.info.count > 0, "midding product infos");
        for info in product.info {
            verifyProductInfo(info);
        }
        
        XCTAssert(product.images.count > 0, "missing product images");
        for image in product.images {
            verifyProductImage(image);
        }
        
        XCTAssert(product.categories.count > 0, "missing product category");
        for category in product.categories {
            verifyProductCategory(category);
        }
    }
    
    // MARK: Price info
    func testPriceInfoCreation() {
        let expectation = expectationWithDescription("wait to get all products");
        
        core.getProducts(success: { (products) in
            for product in products{
                GTNTestModels.verifyPriceInfo(product.priceInfo);
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error");
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    internal static func verifyPriceInfo(priceInfo: GTNPriceInfo, isDiscount: Bool = false){
        if !isDiscount { XCTAssert(priceInfo.price > 0.0, "should be > 0"); }
        XCTAssert(priceInfo.currencyCode.characters.count > 0, "should be > 0");
        XCTAssert(priceInfo.formattedPrice.characters.count > 0, "should be > 0");
        XCTAssert(priceInfo.currencyFormat.characters.count > 0, "should be > 0");
        XCTAssert(priceInfo.currencyDigits > 0, "should be > 0");
    }
    
    // MARK: Product info
    func testProductInfoCreation() {
        let expectation = expectationWithDescription("wait to get all products");
        
        core.getProducts(success: { (products) in
            for product in products{
                for info in product.info {
                    GTNTestModels.verifyProductInfo(info);
                }
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error");
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    internal static func verifyProductInfo(info: GTNProductInfo){
        XCTAssert(info.content.count > 0, "missing content");
        XCTAssert(info.contentType.characters.count > 0, "missing content type");
    }
    
    // MARK: Product image
    func testProductImageCreation(){
        let expectation = expectationWithDescription("wait to get all products");
        
        core.getProducts(success: { (products) in
            for product in products{
                for image in product.images {
                    GTNTestModels.verifyProductImage(image);
                }
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error");
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    internal static func verifyProductImage(image: GTNProductImage){
        XCTAssert(image.url.characters.count > 1, "missing image url");
        XCTAssert(image.types.count > 0, "missing image types");
    }
    
    // MARK: Product category
    func testProductCategoryCreation() {
        let expectation = expectationWithDescription("wait to get all products");
        
        core.getProducts(success: { (products) in
            for product in products{
                for category in product.categories {
                    GTNTestModels.verifyProductCategory(category);
                }
            }
            expectation.fulfill();
        }) { (error) in
            XCTAssert(error.message().characters.count == 0, "shouldn't be an error");
            expectation.fulfill();
        };
        
        waitForExpectationsWithTimeout(10.0, handler: nil);
    }
    
    func testProductCategoryCreationWithJSON() {
        do {
            let data = productCategoryJSON.dataUsingEncoding(NSUTF8StringEncoding);
            let parsedObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves);
            let category = GTNProductCategory(parsedObject);
            
            XCTAssert(category.id == 123, "this should be equal");
            XCTAssert(category.name == "Test", "this should be equal");
        } catch {
            
        }
    }
    
    internal static func verifyProductCategory(category: GTNProductCategory){
        XCTAssert(category.name.characters.count > 0, "missing category name");
    }
    
    // MARK: Product variant
    internal static func verifyVariant(variant: GTNProductVariant){
        XCTAssert(variant.sku.characters.count > 0, "missing sku");
        GTNTestModels.verifyPriceInfo(variant.priceInfo);
    }
    
    // MARK: Variant option
    internal static func verifyVariantOption(option: GTNVariantOption){
        XCTAssert(option.optionId.characters.count > 0, "optionIs is missing");
        XCTAssert(option.valueId.characters.count > 0, "valueId is missing");
        XCTAssert(option.name.characters.count > 0, "name is missing");
        XCTAssert(option.value.characters.count > 0, "value is missing");
        XCTAssert(option.imageUrl.characters.count > 0, "imageUrl is missing");
    }
    
    // MARK: Product template
    internal static func verifyTemplate(template: GTNProductTemplate){
        XCTAssert(template.name.characters.count > 0, "missing template name");
        XCTAssert(template.imageUrl.characters.count > 0, "missing image url");
    }
    
    // MARK: Space
    internal static func verifySpace(space: GTNSpace){
        XCTAssert(space.index > -1, "invalid space index");
    }
    
    // MARK: Layer
    func testLayerCreationWithMissingData() {
        do {
            let data = layerJSON.dataUsingEncoding(NSUTF8StringEncoding);
            let parsedObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves);
            let layer = GTNLayer(parsedObject);
            
            XCTAssert(layer.id == "3ffa", "this should be equal");
            XCTAssert(layer.type == "Image", "this should not be empty");
            XCTAssert(layer.defaultText == "sample text", "this should not be empty")
        } catch {
            
        }
    }
    
    internal static func verifyLayer(layer: GTNLayer){
        XCTAssert(layer.type.characters.count > 0, "missing layer type");
        XCTAssert(layer.zIndex > -1, "invalid Z index");
    }
    
    // MARK: Address
    internal static func verifyAddress(address: GTNAddress){
        XCTAssert(address.firstName.characters.count > 0, "should be > 0");
        XCTAssert(address.lastName.characters.count > 0, "should be > 0");
        XCTAssert(address.line1.characters.count > 0, "should be > 0");
        // line2 not mandatory
        XCTAssert(address.city.characters.count > 0, "should be > 0");
        XCTAssert(address.state.characters.count > 0, "should be > 0");
        XCTAssert(address.countryCode.characters.count > 0, "should be > 0");
        XCTAssert(address.postalCode.characters.count > 0, "should be > 0");
        XCTAssert(address.phone.characters.count > 0, "should be > 0");
        XCTAssert(address.email.characters.count > 0, "should be > 0");
    }
    
    // MARK: Shipping price estimate
    internal static func verifyShipPriceEstimate(price: GTNShipPriceEstimate){
        GTNTestModels.verifyPriceInfo(price.minPrice);
        GTNTestModels.verifyPriceInfo(price.maxPrice);
        XCTAssert(price.vendorCountryCode.characters.count > 0, "missing vendor country code");
        XCTAssert(price.estShipDays > 0, "est ship days should be > 0");
    }
    
    // MARK: Shipping price
    internal static func verifyShippingOption(sPrice: GTNShippingOption){
        XCTAssert(sPrice.skus.count > 0, "missing skus");
        XCTAssert(sPrice.shipOptions.count > 0, "missing ship options");
    }
    
    // MARK: Shipping option
    internal static func verifySingleShipOption(option: GTNSingleShipOption){
        XCTAssert(option.carrierName.characters.count > 0, "missing carrier name");
        XCTAssert(option.methodType.characters.count > 0, "missing method type");
        XCTAssert(option.name.characters.count > 0, "missing name");
        verifyPriceInfo(option.price);
    }
    
    // MARK: Shipping item
    internal static func verifyShippingItem(item: GTNShippingItem){
        XCTAssert(item.sku.characters.count > 0, "missing sku");
        XCTAssert(item.quantity > 0, "missing quantity");
    }
    
    // MARK:
    // MARK: Country
    
    internal static func verifyCountry(country: GTNCountry){
        XCTAssert(country.name.characters.count > 0, "missing country name");
        XCTAssert(country.code.characters.count > 0, "missing country code");
        XCTAssert(country.measurementCode.characters.count > 0, "missing measurement code");
        XCTAssert(country.flagUrl.characters.count > 0, "missing flag url");
    }
    
    // MARK: Currency
    internal static func verifyCurrency(curr: GTNCurrency){
        XCTAssert(curr.name.characters.count > 0, "missing currency name");
        XCTAssert(curr.code.characters.count > 0, "missing currency code");
        XCTAssert(curr.format.characters.count > 0, "missing currency format");
    }
    
    // MARK: User Info
    internal static func verifyUserInfo(uInfo: GTNUserInfo){
        XCTAssert(uInfo.languageCode.characters.count > 0, "missing language code");
        XCTAssert(uInfo.countryCode.characters.count > 0, "missing country code");
        XCTAssert(uInfo.countryName.characters.count > 0, "missing country name");
        XCTAssert(uInfo.currencyFormat.characters.count > 0, "missing currency format");
        XCTAssert(uInfo.currencyCode.characters.count > 0, "missing currency code");
        XCTAssert(uInfo.currencyName.characters.count > 0, "missing currency name");
    }
    
    // MARK: Address validation
    internal static func verifyAddressValidation(address: GTNAddressValidation){
        XCTAssert(address.reason.characters.count > 0, "missing reason");
        XCTAssert(address.score > -999, "missing score");
    }
    
    internal static func verifyProposedAddress(address: GTNProposedAddress){
        XCTAssert(address.city.characters.count > 0, "missing city");
        XCTAssert(address.countryCode.characters.count > 0, "missing country code");
        XCTAssert(address.postalCode.characters.count > 0, "missing postal code");
        XCTAssert(address.stateOrProvinceCode.characters.count > 0, "missing state");
        XCTAssert(address.streetLines.count > 0, "missing street lines");
    }
}



