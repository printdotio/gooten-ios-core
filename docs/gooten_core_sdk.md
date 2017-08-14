# Gooten iOS Core SDK

## Gooten Core SDK Configuration

The very first step is to create and set configuration for Gooten Core SDK.  Gooten Core SDK configuration is held by `GTNConfig` class. There is only one mandatory property that need to be set and it is Recipe ID. Below is example of creating and setting configuration for Gooten Core SDK.
```Objective-C
// Objective C
GTNCore *core = [GTNCore new];
    
GTNConfig *config = [GTNConfig new];
config.recipeId = @"<INSERT YOUR RECIPE ID HERE>";
[core setConfig:config];
``` 
```Swift
// Swift
let core = GTNCore();

let config = GTNConfig();
config.recipeId = "<INSERT YOUR RECIPE ID HERE>";
core.setConfig(config);
```
After configuration has been set all API requests will use specified Recipe ID.

## Gooten API

- [Getting a User's Location](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-a-users-location)
- [Getting a List of Products](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-a-list-of-products)
- [Getting a List of SKUs (Product Variants) for a Product](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-a-list-of-skus-product-variants-for-a-product)
- [Getting a SKU's Required Images](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-a-skus-required-images)
- [Getting a List of Templates For a SKU](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-a-list-of-templates-for-a-sku)
- [Getting Shipping Options For a Cart](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-shipping-options-for-a-cart)
- [Getting a Ship Price Estimate](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-a-ship-price-estimate)
- [Submitting an Order via Braintree](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#submitting-an-order-via-braintree-credit-card)
- [Submitting an Order via ApplePay](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#submitting-order-via-applepay)
- [Submitting an Order via PayPal](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#submitting-order-via-paypal)
- [Getting an Order price estimate]()
- [Getting Payment Validation](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-payment-validation)
- [Getting an Order's Info](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-an-orders-info)

####Other API
- [Getting Countries](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-countries)
- [Getting Currencies](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-currencies)
- [Currency Conversion](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#currency-conversion)
- [Getting User Info](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#getting-user-info)
- [Address validation](https://github.com/printdotio/gooten-ios-core-private/blob/master/docs/gooten_core_sdk.md#address-validation)

### Getting a User's Location

Getting a user's home/ship-to country is incredibly important. The ship-to country is used for:

 - deciding which products are available for the geography
 - deciding which vendor would be the best to print for the geography
 - deciding what product and shipping prices will be

If you have a two character country code (like "US") already, then feel free to skip. 

Below is example for getting user's country code using Gooten API.

```Objective-C
// Objective C
[core getUserLocationWithSuccess:^(NSString * _Nonnull countryCode) {
        core.config.countryCode = countryCode; // set user's country code to GTNConfig for future API requests
        
} failure:^(GTNError * _Nonnull error) {

}];
```
```Swift
// Swift
core.getUserLocation(success: { (countryCode) in
	core.config().countryCode = countryCode; // set user's country code to GTNConfig for future API requests
	
}) { (error) in
            
};
```

### Getting a List of Products
Now that we have the user's country, we can call out to the API for a list of products. 

At Gooten, the term "product" has a meaning more like "product category." For instance, "Canvas Wraps" is a product that has different variants/skus underneath it, like for instance, a 10x10 black-wrapped canvas. 

 - see what product categories are available in your region
 - see the starting prices of SKUs for the product
 - get marketing-worthy content and images for the product

Example code for getting list of a products:

```Objective-C
// Objective C
[core getProductsWithSuccess:^(NSArray<GTNProduct *> * _Nonnull products) {
            
} failure:^(GTNError * _Nonnull error) {

}];
```
```Swift
// Swift
core.getProducts(success: { (products) in

}) { (error) in

};
```

This request will use following properties set in `GTNConfig`:

 - `countryCode` - required -  the 2 character country code the user is interested in shipping to
 - `currencyCode` - optional, defaults to "USD" - the currency to get prices in
 - `languageCode` - optional, defaults to "en" - the language to have product data returned in
 - `allProductsAndVariants` - optional, defaults to `true` - whether to return all the products that are orderable in the user's region, or to only return products the user has set up in the [product settings page](https://www.gooten.com/admin#product-settings). TODO check that link

So now we have a list of products. You want to choose products where `Product.isComingSoon()==false`; "coming soon" products are ones that are not available.

### Getting a List of SKUs (Product Variants) for a Product

It's easy to get a list of available SKUs for a product, after you have the a product's Id from our products endpoint (above).

#### Selection of a SKU

Different SKUs *can be* available for different regions. For instance, in US, our canvas wrap SKUs are based on inch formats, while in Europe, those SKUs are based on centimeter formats. This results in different SKUs.

The important point here is that you want to show the US SKU to someone from US, and the European SKU for the person in Europe. This is why getting (and setting) the user's country is so crucial. 

Here is example for getting list of SKUs for Product:

```Objective-C
// Objective C
int productId = <SOME VALID PRODUCT ID>; // e.g. product.id

[core getProductVariantsWithProductId:productId success:^(NSArray<GTNProductVariant *> * _Nonnull variants) {

} failure:^(GTNError * _Nonnull error) {

}];
```
```Swift
// Swift
let productId = <SOME VALID PRODUCT ID>; // e.g. product.id

core.getProductVariants(productId: productId, success: { (variants) in

}) { (error) in

};
```

This request will use following properties set in `GTNConfig`:

 - `countryCode` - required -  the 2 character country code the user is interested in shipping to
 - `currencyCode` - optional, defaults to "USD" - the currency to get prices in
 - `languageCode` - optional, defaults to "en" - the language to have product data returned in
 - `allProductsAndVariants` - optional, defaults to `true` - whether to return all the products that are orderable in the user's region, or to only return products the user has set up in the [product settings page](https://www.gooten.com/admin#product-settings). TODO check that link

### Getting a SKU's Required Images

Without the correct sized images, an item will not be submitted to a printer.

The getRequiredImages function params argument takes 2 values:

sku - required - the SKU you are requesting templates for
template - required - the name of template to get images sizes

Example:

```Objective-C
// Objective C
NSString *sku = @"<SOME VALID SKU>"; // e.g. productVariant.sku;
NSString *templateName = @"<SOME VALID TEMPLATE NAME>";

[core getRequiredImagesWithSku:sku templateName:templateName success:^(NSArray<GTNSize * _Nonnull sizes) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
let sku = "<SOME VALID SKU>"; // e.g. productVariant.sku();
let templateName = "<SOME VALID TEMPLATE NAME>";

core.getRequiredImages(sku: sku, templateName: templateName, success: { (sizes) in

}) { (error) in

};
```

Result is array of GTNSize objects.

### Getting a List of Templates For a SKU

"Templates" are data that describe how to build a UI for a SKU. For example, a template contains information such as:

 - how many images does one need to supply for a SKU?
 - what size images should one supply?
 - coordinates for where to place images
 - assets (images) to build a more realistic representation of what the final product would look like, with their coordinates

Example:

```Objective-C
// Objective C
NSString *sku = @"<SOME VALID SKU>"; // e.g. productVariant.sku;

[core getProductTemplatesWithSku:sku success:^(NSArray<GTNProductTemplate *> * _Nonnull templates) {
                    
} failure:^(GTNError * _Nonnull error) {

}];
```
```Swift
// Swift
let sku = "<SOME VALID SKU>"; // e.g. productVariant.sku();

core.getProductTemplates(sku: sku, success: { (templates) in

}) { (error) in

};
```

### Getting Shipping Options For a Cart

The getShippingOptions function params argument takes several values:

ShipToPostalCode - required - postal code
ShipToCountry - required - 2-letter country code
ShipToState - optional - state code if exists

GTNShippingItem contains SKU of product and number of items with this SKU.

```Objective-C
// Objective C
NSString *postalCode = @"<POSTAL CODE>";
NSString *state = @"<STATE>";
NSString *countryCode = @"<COUNTRY CODE>";

GTNShippingItem *item1 = [[GTNShippingItem alloc]initWithSku:@"<SOME VALID SKU>" quantity:1];
GTNShippingItem *item2 = [[GTNShippingItem alloc]initWithSku:@"<SOME VALID SKU>" quantity:1];

[core getShippingOptionsWithPostalCode:postalCode state:state countryCode:countryCode items:@[item1, item2] success:^(NSArray<GTNShippingPrice *> * _Nonnull options) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```

```Swift
// Swift
let postalCode = "<POSTAL CODE>";
let state = "<STATE>";
let countryCode = "<COUNTRY CODE>";

let item1 = GTNShippingItem(sku: <SOME VALID SKU>, quantity: 1);
let item2 = GTNShippingItem(sku: <SOME VALID SKU>, quantity: 1);

core.getShippingOptions(postalCode: postalCode, state: state, countryCode: country code, items: [item1, item2], success: { (options) in

}) { (error) in

};
```

### Getting a Ship Price Estimate
```Objective-C
// Objective C
int productId = <SOME VALID PRODUCT ID>; // e.g. product.id

[core getShipPriceEstimateWithProductId:productId success:^(GTNShipPriceEstimate * _Nonnull shipPriceEstimate) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
let productId = <SOME VALID PRODUCT ID>; // e.g. product.id

core.getShipPriceEstimate(productId: productId, success: { (shipPriceEstimate) in

}) { (error) in

};
```
### Submitting an Order
There are three possible payment methods (Braintree, PayPal and Apple Pay) that could be used to pay for order. Depending on payment method there three ways to create an order:
- using Credit Card data, encrypted using Braintree
- pre-submitted order, for orders paid using PayPal
- using payment info from Apple Pay

#### Submitting an Order via Braintree (Credit Card)

Following properties must be defined:
- ```shippingAddress``` (```GTNAddress```) required.
	- ```firstName``` - first name of user
    - ```lastName``` - last name of user
    - ```line1``` - shipping address
    - ```line2``` - second shipping address (optional)
    - ```city``` - shipping city
    - ```state``` - shipping state if exist
    - ```countryCode``` - shipping 2-letter country code
    - ```postalCode``` - shipping postal code
    - ```phone``` - user's phone number
    - ```email``` -  user's email
- ```billingAddress``` (```GTNAddress```) required.
	- ```firstName``` - first name of user
	- ```lastName``` - last name of user
	- ```line1``` - billing address
	- ```city``` - billing city
	- ```state``` - billing state if exist
	- ```postalCode``` - billing postal code
- ```payment``` (```GTNPaymentBraintree```) required.
	- ```braintreeEncryptedCCNumber``` - encrypted credit card number
    - ```braintreeEncryptedCCExpDate``` - encrypted expiration date
    - ```braintreeEncryptedCCV``` - encrypted CCV
    - ```currencyCode``` - currency code
    - ```total``` - order total
- ```items``` array of ```GTNOrderItem``` required.
	- ```sku``` - SKU of product
    - ```quantity``` - number of items with this SKU
    - ```shipCarrierMethod``` - Id of ship carrier method 
    - ```meta``` - meta data (optional)
    - ```images``` - array of ```GTNOrderItemImage```
    	- ```url``` - url of image
    	- ```index``` - index
    	- ```thumbnailUrl``` - thumbnail url
    	- ```manipCommand``` - manip command
- ```couponCodes``` - array coupon codes. Optional.

Result is ```orderId```.
```Objective-C
// Objective C
[core orderSubmitBraintreeWithShippingAddress:shippingAddress billingAddress:billingAddress payment:payment items:items couponCodes:couponCodes success:^(NSString * _Nonnull orderId) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```

```Swift
// Swift
core.orderSubmitBraintree(shippingAddress: shippingAddress, billingAddress: billingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in

}) { (error) in

};
```

#### Submitting Order via ApplePay

Following properties must be defined:
- ```shippingAddress``` (```GTNAddress```) required.
	- ```firstName``` - first name of user
    - ```lastName``` - last name of user
    - ```line1``` - shipping address
    - ```line2``` - second shipping address (optional)
    - ```city``` - shipping city
    - ```state``` - shipping state if exist
    - ```countryCode``` - shipping 2-letter country code
    - ```postalCode``` - shipping postal code
    - ```phone``` - user's phone number
    - ```email``` -  user's email
- ```billingAddress``` (```GTNAddress```) required.
	- ```firstName``` - first name of user
	- ```lastName``` - last name of user
	- ```line1``` - billing address
	- ```city``` - billing city
	- ```state``` - billing state if exist
	- ```postalCode``` - billing postal code
- ```pkPayment``` (```PKPayment```) payment info from ```didAuthorizePayment``` after successful payment via ApplePay. Required.
- ```payment``` (```GTNPayment```) required.
    - ```currencyCode``` - currency code
    - ```total``` - order total
- ```items``` array of ```GTNOrderItem``` required.
	- ```sku``` - SKU of product
    - ```quantity``` - number of items with this SKU
    - ```shipCarrierMethod``` - Id of ship carrier method 
    - ```meta``` - meta data (optional)
    - ```images``` - array of ```GTNOrderItemImage```
    	- ```url``` - url of image
    	- ```index``` - index
    	- ```thumbnailUrl``` - thumbnail url
    	- ```manipCommand``` - manip command
- ```couponCodes``` - array coupon codes. Optional.

Result is ```orderId```.
```Objective-C
// Objective C
[core orderSubmitApplePayWithShippingAddress:shippingAddress billingAddress:billingAddress pkPayment:pkPayment payment:payment items:items couponCodes:couponCodes success:^(NSString * _Nonnull orderId) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```

```Swift
// Swift
core.orderSubmitApplePay(shippingAddress: shippingAddress, billingAddress: billingAddress, pkPayment: pkPayment, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in

}) { (error) in

};
```

#### Submitting Order via PayPal

- ```shippingAddress``` (```GTNAddress```) required.
	- ```firstName``` - first name of user
    - ```lastName``` - last name of user
    - ```line1``` - shipping address
    - ```line2``` - second shipping address (optional)
    - ```city``` - shipping city
    - ```state``` - shipping state if exist
    - ```countryCode``` - shipping 2-letter country code
    - ```postalCode``` - shipping postal code
    - ```phone``` - user's phone number
    - ```email``` -  user's email
- ```payment``` (```GTNPayment```) required.
    - ```currencyCode``` - currency code
    - ```total``` - order total
- ```items``` array of ```GTNOrderItem``` required.
	- ```sku``` - SKU of product
    - ```quantity``` - number of items with this SKU
    - ```shipCarrierMethod``` - Id of ship carrier method 
    - ```meta``` - meta data (optional)
    - ```images``` - array of ```GTNOrderItemImage```
    	- ```url``` - url of image
    	- ```index``` - index
    	- ```thumbnailUrl``` - thumbnail url
    	- ```manipCommand``` - manip command
- ```couponCodes``` - array coupon codes. Optional.

Result is ```orderId```. This payment needs to be validated. Please see Getting Payment Validation below.
```Objective-C
// Objective C
[core orderSubmitPaypalWithShippingAddress:shippingAddress payment:payment items:tems couponCodes:couponCodes success:^(NSString * _Nonnull orderId) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```

```Swift
// Swift
core.orderSubmitPaypal(shippingAddress: shippingAddress, payment: payment, items: items, couponCodes: couponCodes, success: { (orderId) in

}) { (error) in

};
```
### Getting Order Price Estimate
Used to estimate cost of the order, including any coupon discounts.

- ```shippingAddress``` (```GTNAddress```) required.
	- ```firstName``` - first name of user
    - ```lastName``` - last name of user
    - ```line1``` - shipping address
    - ```line2``` - second shipping address (optional)
    - ```city``` - shipping city
    - ```state``` - shipping state if exist
    - ```countryCode``` - shipping 2-letter country code
    - ```postalCode``` - shipping postal code
    - ```phone``` - user's phone number
    - ```email``` -  user's email
- ```items``` array of ```GTNOrderItem``` required.
	- ```sku``` - SKU of product
    - ```quantity``` - number of items with this SKU
    - ```shipCarrierMethod``` - Id of ship carrier method 
    - ```meta``` - meta data (optional)
    - ```images``` - array of ```GTNOrderItemImage```
    	- ```url``` - url of image
    	- ```index``` - index
    	- ```thumbnailUrl``` - thumbnail url
    	- ```manipCommand``` - manip command
- ```currencyCode``` - currency code.
- ```couponCodes``` - array coupon codes. Optional.

```Objective-C
// Objective C
[core orderPriceEstimate:shippingAddress items:items currencyCode:currencyCode couponCodes:couponCodes
success:^(GTNPriceEstimate * _Nonnull priceEstimate) {

} failure:^(GTNError * _Nonnull error) {
            
}];
```

```Swift
// Swift
core.orderPriceEstimate(shippingAddress: shippingAddress, items: items, currencyCode: currencyCode, couponCodes: couponCodes, success: { (priceEstimate) in

}) { (error) in

}
```

### Getting Payment Validation

```Objective-C
// Objective C
NSString *orderId = @"<VALID ORDER ID>";
NSString *paypalKey = @"<PAYPAL KEY>"; // pay id provided by PayPal after succesfull order

[core getPaymentValidationWithOrderId:orderId paypalKey:paypalKey success:^(BOOL isValid) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
let orderId = "<VALID ORDER ID>";
let paypalKey = "<PAYPAL KEY>"; // pay id provided by PayPal after succesfull order

core.getPaymentValidation(orderId: orderId, paypalKey: paypalKey, success: { (isValid) in

}) { (error) in

}
```

### Getting an Order's Info

```Objective-C
// Objective C
NSString *orderId = @"<VALID ORDER ID>";

[core getOrderStatusWithOrderId:orderId success:^(GTNOrderStatus * _Nonnull orderStatus) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
let orderId = "<VALID ORDER ID>";

core.getOrderStatus(orderId: orderId, success: { (orderStatus) in

}) { (error) in

};
```

##Other API

### Getting Countries
```Objective-C
// Objective C
[core getCountriesWithSuccess:^(NSArray<GTNCountry *> * _Nonnull countries) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
core.getCountries(success: { (countries) in

}) { (error) in

};
```

### Getting Currencies
```Objective-C
// Objective C
[core getCurrenciesWithSuccess:^(NSArray<GTNCurrency *> * _Nonnull currencies) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
core.getCurrencies(success: { (currencies) in

}) { (error) in

};
```
### Currency Conversion
```Objective-C
// Objective C
NSString *fromCurrencyCode = @"<FROM CURRENCY CODE>"; // e.g. "RSD" 
NSString *toCurrencyCode = @"<TO CURRENCY CODE>"; // e.g. "USD"
double amountToConvert = 1.0; // total amount to convert

[core convertCurrencyFromCurrencyCode:fromCurrencyCode toCurrencyCode:toCurrencyCode amount:amountToConvert success:^(GTNPriceInfo * _Nonnull result) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
let fromCurrencyCode = "<FROM CURRENCY CODE>"; // e.g. "RSD" 
let toCurrencyCode = "<TO CURRENCY CODE>"; // e.g. "USD"
let amountToConvert = 1.0; // total amount to convert

core.convertCurrency(fromCurrencyCode: fromCurrencyCode, toCurrencyCode: toCurrencyCode, amount: amountToConvert, success: { (result) in

}) { (error) in

};
```

### Getting User Info
```Objective-C
// Objective C
[core getUserInfoWithSuccess:^(GTNUserInfo * _Nonnull userInfo) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
core.getUserInfo(success: { (userInfo) in

}) { (error) in

};
```

### Address validation
```Objective-C
// Objective C
GTNAddress *address = [[GTNAddress alloc]init]; // fill in line1, city, state, postal code...

[core validateAddress:address success:^(GTNAddressValidation * _Nonnull result) {
            
} failure:^(GTNError * _Nonnull error) {
            
}];
```
```Swift
// Swift
let address = GTNAddress(); // fill in line1, city, state, postal code...

core.validateAddress(address, success: { (result) in

}) { (error) in

};
```
