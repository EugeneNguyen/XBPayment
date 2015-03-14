//
//  XBPWebViewViewController.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import "XBPWebViewViewController.h"

@interface XBPWebViewViewController ()

@end

@implementation XBPWebViewViewController
@synthesize webView;
@synthesize delegate;
@synthesize url;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
