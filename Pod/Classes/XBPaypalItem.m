//
//  XBPaypalItem.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import "XBPaypalItem.h"

@implementation XBPaypalItem
@synthesize name;
@synthesize desc;
@synthesize quantity;
@synthesize currency;
@synthesize taxRate = _taxRate;
@synthesize amount = _amount;
@synthesize taxAmount;
@synthesize seller;
@synthesize paymentAction;
@synthesize shippingfee;
@synthesize allowNote;
@synthesize noShipping;

@synthesize shipToCity;
@synthesize shipToName;
@synthesize shipToState;
@synthesize shipToStreet;
@synthesize shipToStreet2;
@synthesize shipToCountryCode;
@synthesize shipToCountryName;
@synthesize shipToPhoneNumber;
@synthesize shipToAddressStatus;
@synthesize shipToAddressNormalizationStatus;
@synthesize shipToZip;

- (NSDictionary *)paramsForIndex:(int)index
{
    NSMutableDictionary *params = [@{} mutableCopy];
    
    [params setValue:name forKey:[NSString stringWithFormat:@"L_PAYMENTREQUEST_%d_NAME%d", index,index]];
    
    [params setValue:@(_amount + shippingfee) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_AMT", index]];
    [params setValue:@(_amount) forKey:[NSString stringWithFormat:@"L_PAYMENTREQUEST_%d_AMT%d", index,index]];
    
    [params setValue:@(_amount) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_ITEMAMT", index]];
    [params setValue:@(shippingfee) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPPINGAMT", index]];
    
    [params setValue:@(noShipping) forKey:@"NOSHIPPING"];
    [params setValue:@(allowNote) forKey:@"ALLOWNOTE"];
    
    if (quantity != 0)
    {
        [params setValue:@(quantity) forKey:[NSString stringWithFormat:@"L_PAYMENTREQUEST_%d_QTY%d", index,index]];
    }
    
    if (seller)
    {
        [params setValue:seller forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SELLERPAYPALACCOUNTID", index]];
    }
    
    if (paymentAction)
    {
        [params setValue:paymentAction forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_PAYMENTACTION", index]];
    }
    
    // address
    
    if (shipToName)
    {
        [params setValue:shipToName forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTONAME", index]];
    }
    
    if (shipToStreet)
    {
        [params setValue:shipToStreet forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOSTREET", index]];
    }
    
    if (shipToStreet2)
    {
        [params setValue:shipToStreet2 forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOSTREET2", index]];
    }
    
    if (shipToCity)
    {
        [params setValue:shipToCity forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOCITY", index]];
    }
    
    if (shipToState)
    {
        [params setValue:shipToState forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOSTATE", index]];
    }
    
    if (shipToZip)
    {
        [params setValue:shipToZip forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOZIP", index]];
    }
    
    if (shipToCountryCode)
    {
        [params setValue:shipToCountryCode forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOCOUNTRYCODE", index]];
    }
    
    if (shipToCountryName)
    {
        [params setValue:shipToCountryName forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOCOUNTRYNAME", index]];
    }
    if (shipToPhoneNumber)
    {
        [params setValue:shipToPhoneNumber forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOPHONENUM", index]];
    }
    if (shipToAddressStatus)
    {
        [params setValue:shipToAddressStatus forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_ADDRESSSTATUS", index]];
    }
    if (shipToAddressNormalizationStatus)
    {
        [params setValue:shipToAddressNormalizationStatus forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_ADDRESSNORMALIZATIONSTATUS", index]];
    }
    
    return params;
}

@end
