//
//  XBPaypalExpressCheckout.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/8/15.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    eMEC = 0,
    eMECBilling,
} XBPMethod;

typedef void (^XBPPaypalExpressCheckoutCompletion)(NSDictionary *result, NSError * error);

@interface XBPaypalExpressCheckout : NSObject
{
    
}

@property (nonatomic, retain) NSString * apiReturnURL;
@property (nonatomic, retain) NSString * apiCancelURL;
@property (nonatomic, retain) NSString * apiToken;
@property (nonatomic, retain) NSString * apiPayerID;
@property (nonatomic, retain) NSString * apiBillingAgreementID;
@property (nonatomic, retain) NSString * apiSenderEmail;

@property (nonatomic, assign) UIViewController * basedController;

@property (nonatomic, assign) BOOL isUsingCreditcard;
@property (nonatomic, assign) BOOL isModal;

@property (nonatomic, retain) NSString * modalCloseTitle;

@property (nonatomic, assign) XBPMethod method;

@property (nonatomic, retain) NSMutableArray * items;

@property (nonatomic, copy) XBPPaypalExpressCheckoutCompletion completionBlock;

- (void)startWithCompletionBlock:(XBPPaypalExpressCheckoutCompletion)completion;
- (void)startSetExpressCheckout;
- (void)startGetExpressCheckoutDetails;
- (void)startDoExpressCheckoutPayment;

- (void)startBillingAgreementWithCompletionBlock:(XBPPaypalExpressCheckoutCompletion)completion;
- (void)startSetMECBillingAgreement;
- (void)startDoMECBillingAgreement;
- (void)cancelBillingAgreementWithCompletionBlock:(XBPPaypalExpressCheckoutCompletion)completion;

@end
