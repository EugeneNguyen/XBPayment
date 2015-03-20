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

- (NSDictionary *)paramsForIndex:(int)index
{
    NSMutableDictionary *params = [@{} mutableCopy];
    
    [params setValue:name forKey:[NSString stringWithFormat:@"L_PAYMENTREQUEST_%d_NAME%d", index,index]];
    
    [params setValue:@(_amount + shippingfee) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_AMT", index]];
    [params setValue:@(_amount) forKey:[NSString stringWithFormat:@"L_PAYMENTREQUEST_%d_AMT%d", index,index]];
    
    [params setValue:@(_amount) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_ITEMAMT", index]];
    [params setValue:@(shippingfee) forKey:[NSString stringWithFormat:@"PAYMENTREQUEST_%d_SHIPPINGAMT", index]];
    
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
    
    return params;
}

@end
