//
//  XBPaypalItem.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import <Foundation/Foundation.h>

@interface XBPaypalItem : NSObject
{
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, assign) float amount;
@property (nonatomic, assign) float shippingfee;
@property (nonatomic, assign) float taxAmount;
@property (nonatomic, assign) float taxRate;
@property (nonatomic, assign) float quantity;
@property (nonatomic, retain) NSString *currency;
@property (nonatomic, retain) NSString *seller;
@property (nonatomic, retain) NSString *paymentAction;

@property (nonatomic, assign) int noShipping;
@property (nonatomic, assign) BOOL allowNote;

- (NSDictionary *)paramsForIndex:(int)index;

@end
