@import Foundation;
@import PassKit;

#import "BTAPIResponseParser.h"

@interface BTClientTokenApplePayPaymentNetworksValueTransformer : NSObject <BTValueTransforming>

+ (instancetype)sharedInstance;

@end
