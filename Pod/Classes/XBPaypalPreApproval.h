//
//  XBPaypalPreApproval.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/10/15.
//
//

#import <Foundation/Foundation.h>

typedef void (^XBPPaypalPreapprovalCompletion)(NSDictionary *result, NSError * error);

@interface XBPaypalPreApproval : NSObject
{
    
}

@property (nonatomic, retain) NSString * apiReturnURL;
@property (nonatomic, retain) NSString * apiCancelURL;

@property (nonatomic, retain) NSDate * apiStartDate;
@property (nonatomic, assign) int apiDurationInSecond;

@property (nonatomic, assign) float apiMaxAmountPerPayment;
@property (nonatomic, assign) int apiMaxNumberOfPayments;
@property (nonatomic, retain) NSString * apiCurrency;

@property (nonatomic, retain) NSString *apiPreapprovalKey;
@property (nonatomic, retain) NSString *apiSenderEmail;

@property (nonatomic, assign) UIViewController * basedController;
@property (nonatomic, assign) BOOL isModal;
@property (nonatomic, retain) NSString * modalCloseTitle;

@property (nonatomic, copy) XBPPaypalPreapprovalCompletion completionBlock;

- (void)startWithCompletionBlock:(XBPPaypalPreapprovalCompletion)completion;

- (void)startSetupPreApproval;
- (void)startGetPreApprovalDetails;

- (void)startCapturePaymentTo:(NSString *)receiverEmail amount:(float)amount withCompletionBlock:(XBPPaypalPreapprovalCompletion)completion;

@end
