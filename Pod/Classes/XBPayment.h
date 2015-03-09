//
//  XBPayment.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/8/15.
//
//

#import <Foundation/Foundation.h>

#import "XBPaypalExpressCheckout.h"
#import "XBPaypalItem.h"

@interface XBPayment : NSObject
{
    
}

@property (nonatomic, assign) BOOL isSandboxMode;
@property (nonatomic, retain) NSString *brandname;

@property (nonatomic, retain) NSString *apiUser;
@property (nonatomic, retain) NSString *apiPassword;
@property (nonatomic, retain) NSString *apiSignature;
@property (nonatomic, retain) NSString *apiVersion;

+ (XBPayment *)sharedInstance;
- (NSDictionary *)params;

@end
