//
//  XBPaypalItem.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import "XBPaypalItem.h"

@interface XBPaypalItem ()
{
    NSMutableDictionary *params;
}

@end

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
@synthesize addressOverride;

- (NSDictionary *)paramsForIndex:(int)index
{
    params = [@{} mutableCopy];
    
    [params setValue:name forKey:[NSString stringWithFormat:@"L_PAYMENTREQUEST_%d_NAME%d", index,index]];
    [self setNotNullValue:desc forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_DESC", index]];
    
    [params setValue:@(_amount + shippingfee) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_AMT", index]];
    [params setValue:@(_amount) forKey:[NSString stringWithFormat:@"L_PAYMENTREQUEST_%d_AMT%d", index,index]];
    
    [params setValue:@(_amount) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_ITEMAMT", index]];
    [params setValue:@(shippingfee) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPPINGAMT", index]];
    [params setValue:currency forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_CURRENCYCODE", index]];
    
    [params setValue:@(noShipping) forKey:@"NOSHIPPING"];
    [params setValue:@(allowNote) forKey:@"ALLOWNOTE"];
    [params setValue:@(self.addressOverride) forKey:@"ADDROVERRIDE"];
    
    if (quantity != 0)
    {
        [params setValue:@(quantity) forKey:[NSString stringWithFormat:@"L_PAYMENTREQUEST_%d_QTY%d", index,index]];
    }
    
    [self setNotNullValue:seller forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SELLERPAYPALACCOUNTID", index]];
    [self setNotNullValue:paymentAction forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_PAYMENTACTION", index]];
    [self setNotNullValue:shipToName forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTONAME", index]];
    [self setNotNullValue:shipToStreet forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOSTREET", index]];
    [self setNotNullValue:shipToStreet2 forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOSTREET2", index]];
    [self setNotNullValue:shipToCity forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOCITY", index]];
    [self setNotNullValue:shipToState forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOSTATE", index]];
    [self setNotNullValue:shipToZip forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOZIP", index]];
    [self setNotNullValue:shipToCountryCode forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOCOUNTRYCODE", index]];
    [self setNotNullValue:shipToCountryName forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOCOUNTRYNAME", index]];
    [self setNotNullValue:shipToPhoneNumber forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPTOPHONENUM", index]];
    [self setNotNullValue:shipToAddressStatus forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_ADDRESSSTATUS", index]];
    [self setNotNullValue:shipToAddressNormalizationStatus forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_ADDRESSNORMALIZATIONSTATUS", index]];
    
    
    
    return params;
}

- (void)setNotNullValue:(id)object forKey:(NSString *)key
{
    if (object)
    {
        [params setValue:object forKey:key];
    }
}

@end
