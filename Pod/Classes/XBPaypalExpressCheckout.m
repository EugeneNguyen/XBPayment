
 //
//  XBPaypalExpressCheckout.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/8/15.
//
//

#import "XBPaypalExpressCheckout.h"
#import "AFNetworking.h"
#import "XBPWebViewViewController.h"
#import "XBPayment.h"
#import "XBPaypalItem.h"
#import "NSString+NVParser.h"
#import "XBMobile.h"

@interface XBPaypalExpressCheckout () <UIWebViewDelegate>
{
    XBPWebViewViewController *webBrowser;
}

@end

@implementation XBPaypalExpressCheckout

@synthesize apiCancelURL;
@synthesize apiReturnURL;
@synthesize apiToken;
@synthesize apiPayerID;
@synthesize apiBillingAgreementID;
@synthesize apiSenderEmail;

@synthesize basedController;
@synthesize isModal;
@synthesize modalCloseTitle;

@synthesize items;

@synthesize completionBlock;

@synthesize method;

- (id)init
{
    self = [super init];
    if (self)
    {
        modalCloseTitle = @"Close";
        items = [@[] mutableCopy];
        
        
    }
    return self;
}

#pragma mark - Business method

- (NSString *)serviceURL
{
    return [XBPayment sharedInstance].isSandboxMode ? @"https://api-3t.sandbox.paypal.com/nvp" : @"https://api-3t.paypal.com/nvp";
}

- (void)startWithCompletionBlock:(XBPPaypalExpressCheckoutCompletion)completion
{
    completionBlock = completion;
    [self startSetExpressCheckout];
    method = eMEC;
}

- (void)startSetExpressCheckout
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [@{@"METHOD": @"SetExpressCheckout",
                                     @"returnUrl": apiReturnURL,
                                     @"cancelUrl": apiCancelURL} mutableCopy];
    
    [params addEntriesFromDictionary:[[XBPayment sharedInstance] params]];
    
    for (int i = 0; i < [items count]; i ++)
    {
        XBPaypalItem *item = items[i];
        [params addEntriesFromDictionary:[item paramsForIndex:i]];
    }
    
    if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Start SetExpressCheckout: %@", params);
    [self showHUD:XBText(@"Preparing", @"XBPayment")];
    AFHTTPRequestOperation *operation = [manager POST:[self serviceURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSDictionary *result = [operation.responseString nvObject];
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Done  SetExpressCheckout: %@", result);
        self.apiToken = result[@"TOKEN"];
        [self openBrowser];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        completionBlock(nil, error);
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Error SetExpressCheckout: %@", error);
    }];
    
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
}

- (void)startGetExpressCheckoutDetails
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [@{@"METHOD": @"GetExpressCheckoutDetails",
                                     @"TOKEN": self.apiToken} mutableCopy];
    
    [params addEntriesFromDictionary:[[XBPayment sharedInstance] params]];
    
    for (int i = 0; i < [items count]; i ++)
    {
        XBPaypalItem *item = items[i];
        [params addEntriesFromDictionary:[item paramsForIndex:i]];
    }
    if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Start GetExpressCheckout: %@", params);
    [self showHUD:XBText(@"Getting information", @"XBPayment")];
    
    AFHTTPRequestOperation *operation = [manager POST:[self serviceURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSDictionary *result = [operation.responseString nvObject];
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Done  GetExpressCheckout: %@", result);
        self.apiSenderEmail = result[@"EMAIL"];
        completionBlock(result, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        completionBlock(nil, error);
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Error GetExpressCheckout: %@", error);
    }];
    
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
}

- (void)startDoExpressCheckoutPayment
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [@{@"METHOD": @"DoExpressCheckoutPayment",
                                     @"TOKEN": self.apiToken,
                                     @"PAYERID": self.apiPayerID} mutableCopy];
    
    [params addEntriesFromDictionary:[[XBPayment sharedInstance] params]];
    
    for (int i = 0; i < [items count]; i ++)
    {
        XBPaypalItem *item = items[i];
        [params addEntriesFromDictionary:[item paramsForIndex:i]];
    }
    
    [self showHUD:XBText(@"Performing", @"XBPayment")];
    if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Start DoExpressCheckout: %@", params);
    
    AFHTTPRequestOperation *operation = [manager POST:[self serviceURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSDictionary *result = [operation.responseString nvObject];
        
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Done  DoExpressCheckout: %@", result);
        [self startGetExpressCheckoutDetails];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        completionBlock(nil, error);
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Error  DoExpressCheckout: %@", error);
    }];
    
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
}

#pragma mark - Billing Agreement

- (void)startBillingAgreementWithCompletionBlock:(XBPPaypalExpressCheckoutCompletion)completion
{
    completionBlock = completion;
    [self startSetMECBillingAgreement];
    method = eMECBilling;
}

- (void)startSetMECBillingAgreement
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [@{@"METHOD": @"SetExpressCheckout",
                                     @"returnUrl": apiReturnURL,
                                     @"cancelUrl": apiCancelURL,
                                     @"PAYMENTREQUEST_0_PAYMENTACTION": @"AUTHORIZATION",
                                     @"PAYMENTREQUEST_0_AMT": @"0",
                                     @"PAYMENTREQUEST_0_CURRENCYCODE": @"USD",
                                     @"L_BILLINGTYPE0": @"MerchantInitiatedBilling",
                                     @"L_BILLINGAGREEMENTDESCRIPTION0": [XBPayment sharedInstance].brandname} mutableCopy];
    
    [params addEntriesFromDictionary:[[XBPayment sharedInstance] params]];
    
    if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Start SetExpressCheckout Billing: %@", params);
    [self showHUD:XBText(@"Preparing", @"XBPayment")];
    AFHTTPRequestOperation *operation = [manager POST:[self serviceURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSDictionary *result = [operation.responseString nvObject];
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Done  SetExpressCheckout Billing: %@", result);
        self.apiToken = result[@"TOKEN"];
        [self openBrowser];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        completionBlock(nil, error);
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Error SetExpressCheckout Billing: %@", error);
    }];
    
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
}

- (void)startDoMECBillingAgreement
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [@{@"METHOD": @"CreateBillingAgreement",
                                     @"TOKEN": self.apiToken} mutableCopy];
    
    [params addEntriesFromDictionary:[[XBPayment sharedInstance] params]];
    
    if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Start DoExpressCheckout Billing: %@", params);
    
    [self showHUD:XBText(@"Performing", @"XBPayment")];
    AFHTTPRequestOperation *operation = [manager POST:[self serviceURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHUD];
        NSDictionary *result = [operation.responseString nvObject];
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Done  DoExpressCheckout Billing: %@", result);
        self.apiBillingAgreementID = result[@"BILLINGAGREEMENTID"];
        [self startGetExpressCheckoutDetails];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        completionBlock(nil, error);
        if ([XBPayment sharedInstance].isDebugMode) NSLog(@"Error DoExpressCheckout Billing: %@", error);
    }];
    
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
}

- (void)openBrowser
{
    NSString *url;
    if ([XBPayment sharedInstance].isSandboxMode)
    {
        url = [NSString stringWithFormat:@"https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=%@", self.apiToken];
    }
    else
    {
        url = [NSString stringWithFormat:@"https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=%@", self.apiToken];
    }
    webBrowser = [[XBPWebViewViewController alloc] initWithNibName:@"XBPWebViewViewController" bundle:[XBPayment bundle]];
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


#pragma mark - WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString rangeOfString:self.apiReturnURL].location != NSNotFound)
    {
        NSString *paramsString = [[urlString componentsSeparatedByString:@"?"] lastObject];
        NSDictionary *params = [paramsString nvObject];
        self.apiPayerID = params[@"PayerID"];
        
        switch (method) {
            case eMEC:
                [self startDoExpressCheckoutPayment];
                break;
                
            case eMECBilling:
                [self startDoMECBillingAgreement];
                break;
                
            default:
                break;
        }
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
        
    }
    return YES;
}

@end
