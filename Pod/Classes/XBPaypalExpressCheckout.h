//
//  XBPaypalExpressCheckout.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/8/15.
//
//

#import <Foundation/Foundation.h>

typedef void (^XBPPaypalExpressCheckoutCompletion)(NSDictionary *result, NSError * error);

@interface XBPaypalExpressCheckout : NSObject
{
    
}

@property (nonatomic, retain) NSString *apiReturnURL;
@property (nonatomic, retain) NSString *apiCancelURL;
@property (nonatomic, retain) NSString *apiToken;
@property (nonatomic, retain) NSString *apiPayerID;

@property (nonatomic, assign) UIViewController *basedController;
@property (nonatomic, assign) BOOL isModal;
@property (nonatomic, retain) NSString * modalCloseTitle;

@property (nonatomic, retain) NSMutableArray *items;

@property (nonatomic, assign) XBPPaypalExpressCheckoutCompletion completionBlock;

- (void)startWithCompletionBlock:(XBPPaypalExpressCheckoutCompletion)completion;

- (void)startSetExpressCheckout;
- (void)startGetExpressCheckoutDetails;
- (void)startDoExpressCheckoutPayment;

@end
