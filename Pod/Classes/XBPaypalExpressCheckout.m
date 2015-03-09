
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

@interface XBPaypalExpressCheckout () <UIWebViewDelegate>
{
    XBPWebViewViewController *webBrowser;
}

@property (nonatomic, retain) NSString *host;

@end

@implementation XBPaypalExpressCheckout

@synthesize apiCancelURL;
@synthesize apiReturnURL;
@synthesize apiToken;
@synthesize apiPayerID;

@synthesize basedController;
@synthesize isModal;
@synthesize modalCloseTitle;

@synthesize items;
@synthesize host;

@synthesize completionBlock;

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

- (void)startWithCompletionBlock:(XBPPaypalExpressCheckoutCompletion)completion
{
    completionBlock = completion;
    [self startSetExpressCheckout];
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
    
    AFHTTPRequestOperation *operation = [manager POST:@"https://api-3t.sandbox.paypal.com/nvp" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [self parseResult:operation.responseString];
        self.apiToken = result[@"TOKEN"];
        [self openBrowser];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
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
    
    AFHTTPRequestOperation *operation = [manager POST:@"https://api-3t.sandbox.paypal.com/nvp" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [self parseResult:operation.responseString];
        NSLog(@"%@", result);
        
        [self startDoExpressCheckoutPayment];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
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
    
    AFHTTPRequestOperation *operation = [manager POST:@"https://api-3t.sandbox.paypal.com/nvp" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result = [self parseResult:operation.responseString];
        completionBlock(result, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    }];
    
    operation.responseSerializer = [AFCompoundResponseSerializer serializer];
}

- (void)openBrowser
{
    NSString *url = [NSString stringWithFormat:@"https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&useraction=commit&token=%@", self.apiToken];
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

#pragma mark - TSMiniWebBrowserDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString rangeOfString:self.apiReturnURL].location != NSNotFound)
    {
        NSString *paramsString = [[urlString componentsSeparatedByString:@"?"] lastObject];
        NSDictionary *params = [self parseResult:paramsString];
        self.apiPayerID = params[@"PayerID"];
        
        [self startGetExpressCheckoutDetails];
        [webBrowser dismissViewControllerAnimated:YES completion:^{
            
        }];
        return NO;
    }
    else if ([urlString rangeOfString:self.apiCancelURL].location != NSNotFound)
    {
        
    }
    return YES;
}

#pragma mark - private method

- (NSDictionary *)parseResult:(NSString *)result
{
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [result componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        
        [queryStringDictionary setObject:value forKey:key];
    }
    return queryStringDictionary;
}

@end
