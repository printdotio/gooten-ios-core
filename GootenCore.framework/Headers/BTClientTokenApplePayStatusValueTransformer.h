@import Foundation;
@import PassKit;


#import "BTAPIResponseParser.h"

@interface BTClientTokenApplePayStatusValueTransformer : NSObject <BTValueTransforming>

+ (instancetype)sharedInstance;

@end
