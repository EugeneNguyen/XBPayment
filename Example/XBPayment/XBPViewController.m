//
//  XBPViewController.m
//  XBPayment
//
//  Created by eugenenguyen on 03/08/2015.
//  Copyright (c) 2014 eugenenguyen. All rights reserved.
//

#import "XBPViewController.h"
#import <XBPayment.h>

@interface XBPViewController ()
{
    
}

@property (nonatomic, retain) XBPaypalExpressCheckout *express;
@property (nonatomic, retain) XBPaypalPreApproval *preApproval;

@end

@implementation XBPViewController
@synthesize express;
@synthesize preApproval;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressExpressCheckout:(id)sender
{
    express = [[XBPaypalExpressCheckout alloc] init];
    
    express.apiReturnURL = @"http://libre.com.vn";
    express.apiCancelURL = @"http://libre.com.vn";
    
    express.basedController = self;
    express.isModal = NO;
    
    XBPaypalItem *item1 = [XBPaypalItem new];
    item1.name = @"items test 1";
    item1.amount = 100;
    item1.seller = @"xuanbinh911@gmail.com";
    item1.paymentAction = @"SALE";
    [express.items addObject:item1];
    
    [express startBillingAgreementWithCompletionBlock:^(NSDictionary *result, NSError *error) {
        
    }];
}

- (IBAction)didPressPreApproval:(id)sender
{
    preApproval = [[XBPaypalPreApproval alloc] init];
    preApproval.apiReturnURL = @"http://libre.com.vn";
    preApproval.apiCancelURL = @"http://libre.com.vn";
    
    preApproval.apiStartDate = [NSDate date];
    preApproval.apiDurationInSecond = 3600 * 24 * 30;
    preApproval.apiMaxAmountPerPayment = 500;
    preApproval.apiMaxNumberOfPayments = 50;
    
    preApproval.basedController = self;
    preApproval.isModal = NO;
    
    [preApproval startWithCompletionBlock:^(NSDictionary *result, NSError *error) {
        NSLog(@"%@", preApproval.apiSenderEmail);
    }];
}

@end
