//
//  XBPayment.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/8/15.
//
//

#import "XBPayment.h"
#import "AFNetworking.h"

static XBPayment *__sharedXBPayment = nil;

@implementation XBPayment

@synthesize isSandboxMode;
@synthesize apiUser;
@synthesize apiPassword;
@synthesize apiSignature;
@synthesize apiVersion;
@synthesize apiAppID;

@synthesize brandname;
@synthesize host = _host;

+ (NSBundle *)bundle
{
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"XBPayment" ofType:@"bundle"]];
}

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
    NSMutableDictionary *params = [@{@"USER": apiUser,
                                     @"PWD": apiPassword,
                                     @"SIGNATURE": apiSignature,
                                     @"VERSION": apiVersion} mutableCopy];
    if (self.brandname)
    {
        params[@"BRANDNAME"] = self.brandname;
    }
    return params;
}

- (void)setHost:(NSString *)host
{
    _host = host;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation = [manager POST:[NSString stringWithFormat:@"%@/pluspaypal/services/get_paypal_account", host] parameters:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        apiUser = responseObject[@"api_username"];
        apiPassword = responseObject[@"api_password"];
        apiSignature = responseObject[@"api_signature"];
        apiVersion = responseObject[@"api_version"];
        apiAppID = responseObject[@"app_id"];
        isSandboxMode = [responseObject[@"is_sandbox"] boolValue];
        brandname = responseObject[@"brandname"] ;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html"]];
    [operation setResponseSerializer:serializer];
}

@end
