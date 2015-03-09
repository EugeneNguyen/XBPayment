//
//  XBPayment.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/8/15.
//
//

#import "XBPayment.h"

static XBPayment *__sharedXBPayment = nil;

@implementation XBPayment

@synthesize isSandboxMode;
@synthesize apiUser;
@synthesize apiPassword;
@synthesize apiSignature;
@synthesize apiVersion;

@synthesize brandname;

- (id)init
{
    self = [super init];
    if (self)
    {
        apiVersion = @"114.0";
    }
    return self;
}

+ (XBPayment *)sharedInstance
{
    if (!__sharedXBPayment)
    {
        __sharedXBPayment = [[XBPayment alloc] init];
    }
    return __sharedXBPayment;
}

- (NSDictionary *)params
{
    NSMutableDictionary *params = [@{@"USER": [XBPayment sharedInstance].apiUser,
                                     @"PWD": [XBPayment sharedInstance].apiPassword,
                                     @"SIGNATURE": [XBPayment sharedInstance].apiSignature,
                                     @"VERSION": [XBPayment sharedInstance].apiVersion} mutableCopy];
    if (self.brandname)
    {
        params[@"BRANDNAME"] = self.brandname;
    }
    return params;
}

@end
