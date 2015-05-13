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

// Address

@property (nonatomic, retain) NSString *shipToName;
@property (nonatomic, retain) NSString *shipToStreet;
@property (nonatomic, retain) NSString *shipToStreet2;
@property (nonatomic, retain) NSString *shipToCity;
@property (nonatomic, retain) NSString *shipToState;
@property (nonatomic, retain) NSString *shipToZip;
@property (nonatomic, retain) NSString *shipToCountryCode;
@property (nonatomic, retain) NSString *shipToCountryName;
@property (nonatomic, retain) NSString *shipToPhoneNumber;
@property (nonatomic, retain) NSString *shipToAddressStatus;
@property (nonatomic, retain) NSString *shipToAddressNormalizationStatus;

@property (nonatomic, assign) float addressOverride;

- (NSDictionary *)paramsForIndex:(int)index;

@end
