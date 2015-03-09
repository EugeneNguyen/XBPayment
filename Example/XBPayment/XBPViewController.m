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

@end

@implementation XBPViewController
@synthesize express;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [express startSetExpressCheckout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
