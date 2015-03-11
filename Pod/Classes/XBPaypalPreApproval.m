//
//  XBPaypalPreApproval.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/10/15.
//
//

#import "XBPaypalPreApproval.h"
#import "AFNetworking.h"
#import "XBPayment.h"
#import "NSString+NVParser.h"
#import "XBPWebViewViewController.h"

@interface XBPaypalPreApproval () <UIWebViewDelegate>
{
    XBPWebViewViewController *webBrowser;
}

@end

@implementation XBPaypalPreApproval
@synthesize apiCancelURL;
@synthesize apiReturnURL;
@synthesize apiCurrency;
@synthesize apiMaxAmountPerPayment;
@synthesize apiMaxNumberOfPayments;
@synthesize apiStartDate;
@synthesize apiDurationInSecond;

@synthesize apiPreapprovalKey;
@synthesize apiSenderEmail;

@synthesize isModal;
@synthesize basedController;
@synthesize modalCloseTitle;

@synthesize completionBlock;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.apiCurrency = @"USD";
    }
    return self;
}

- (void)startWithCompletionBlock:(XBPPaypalExpressCheckoutCompletion)completion
{
    completionBlock = completion;
    [self startSetupPreApproval];
}

- (void)startSetupPreApproval
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[XBPayment sharedInstance].apiUser forHTTPHeaderField:@"X-PAYPAL-SECURITY-USERID"];
    [manager.requestSerializer setValue:[XBPayment sharedInstance].apiPassword forHTTPHeaderField:@"X-PAYPAL-SECURITY-PASSWORD"];
    [manager.requestSerializer setValue:[XBPayment sharedInstance].apiSignature forHTTPHeaderField:@"X-PAYPAL-SECURITY-SIGNATURE"];
    [manager.requestSerializer setValue:@"NV" forHTTPHeaderField:@"X-PAYPAL-REQUEST-DATA-FORMAT"];
    [manager.requestSerializer setValue:@"NV" forHTTPHeaderField:@"X-PAYPAL-RESPONSE-DATA-FORMAT"];
    if ([XBPayment sharedInstance].isSandboxMode || ![XBPayment sharedInstance].apiAppID)
    {
        [manager.requestSerializer setValue:@"APP-80W284485P519543T" forHTTPHeaderField:@"X-PAYPAL-APPLICATION-ID"];
    }
    else
    {
        [manager.requestSerializer setValue:[XBPayment sharedInstance].apiAppID forHTTPHeaderField:@"X-PAYPAL-APPLICATION-ID"];
    }
    
    NSDictionary *postParams = @{@"returnUrl": self.apiReturnURL,
                                 @"cancelUrl": self.apiCancelURL,
                                 @"startingDate": [self stringForDate:self.apiStartDate],
                                 @"endingDate": [self stringForDate:[self.apiStartDate dateByAddingTimeInterval:apiDurationInSecond]],
                                 @"maxAmountPerPayment": @(self.apiMaxAmountPerPayment),
                                 @"maxNumberOfPayments": @(self.apiMaxNumberOfPayments),
                                 @"maxTotalAmountOfAllPayments": @(self.apiMaxNumberOfPayments * self.apiMaxAmountPerPayment),
                                 @"currencyCode": self.apiCurrency,
                                 @"requestEnvelope.errorLanguage": @"en_US"};
    
    if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Start setPreapproval: %@", postParams);
    AFHTTPRequestOperation *operation = [manager POST:@"https://svcs.sandbox.paypal.com/AdaptivePayments/Preapproval" parameters:postParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = [operation.responseString nvObject];
        apiPreapprovalKey = result[@"preapprovalKey"];
        [self openBrowser];
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Done  setPreapproval: %@", result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Error setPreapproval: %@", error);
    }];
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
}

- (void)startGetPreApprovalDetails
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[XBPayment sharedInstance].apiUser forHTTPHeaderField:@"X-PAYPAL-SECURITY-USERID"];
    [manager.requestSerializer setValue:[XBPayment sharedInstance].apiPassword forHTTPHeaderField:@"X-PAYPAL-SECURITY-PASSWORD"];
    [manager.requestSerializer setValue:[XBPayment sharedInstance].apiSignature forHTTPHeaderField:@"X-PAYPAL-SECURITY-SIGNATURE"];
    [manager.requestSerializer setValue:@"NV" forHTTPHeaderField:@"X-PAYPAL-REQUEST-DATA-FORMAT"];
    [manager.requestSerializer setValue:@"NV" forHTTPHeaderField:@"X-PAYPAL-RESPONSE-DATA-FORMAT"];
    if ([XBPayment sharedInstance].isSandboxMode || ![XBPayment sharedInstance].apiAppID)
    {
        [manager.requestSerializer setValue:@"APP-80W284485P519543T" forHTTPHeaderField:@"X-PAYPAL-APPLICATION-ID"];
    }
    else
    {
        [manager.requestSerializer setValue:[XBPayment sharedInstance].apiAppID forHTTPHeaderField:@"X-PAYPAL-APPLICATION-ID"];
    }
    
    NSDictionary *postParams = @{@"preapprovalKey": self.apiPreapprovalKey,
                                 @"requestEnvelope.errorLanguage": @"en_US"};
    
    if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Start getPreapproval: %@", postParams);
    AFHTTPRequestOperation *operation = [manager POST:@"https://svcs.sandbox.paypal.com/AdaptivePayments/PreapprovalDetails" parameters:postParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *result = [operation.responseString nvObject];
        self.apiSenderEmail = result[@"senderEmail"];
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Done  getPreapproval: %@", result);
        completionBlock(result, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Error getPreapproval: %@", error);
        completionBlock(nil, error);
    }];
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
}

- (void)openBrowser
{
    NSString *url;
    if ([XBPayment sharedInstance].isSandboxMode)
    {
        url = [NSString stringWithFormat:@"https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=%@", self.apiPreapprovalKey];
    }
    else
    {
        url = [NSString stringWithFormat:@"https://www.paypal.com/cgi-bin/webscr?cmd=_ap-preapproval&preapprovalkey=%@", self.apiPreapprovalKey];
    }
    webBrowser = [[XBPWebViewViewController alloc] init];
    webBrowser.delegate = self;
    webBrowser.url = [NSURL URLWithString:url];
    if (isModal)
    {
        [self.basedController presentViewController:webBrowser animated:YES completion:^{
            
        }];
    }
    else
    {
        [self.basedController.navigationController pushViewController:webBrowser animated:YES];
    }
}

- (NSString *)stringForDate:(NSDate *)date
{
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    gmtDateFormatter.dateFormat = @"yyyy-MM-ddZZZZZ";
    return [gmtDateFormatter stringFromDate:date];
}

#pragma mark - WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString rangeOfString:self.apiReturnURL].location != NSNotFound)
    {
        NSString *paramsString = [[urlString componentsSeparatedByString:@"?"] lastObject];
        NSDictionary *params = [paramsString nvObject];
        [self startGetPreApprovalDetails];
        if (isModal)
        {
            [webBrowser dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.basedController.navigationController popViewControllerAnimated:YES];
        }
        return NO;
    }
    else if ([urlString rangeOfString:self.apiCancelURL].location != NSNotFound)
    {
        completionBlock(nil, nil);
    }
    return YES;
}

@end
