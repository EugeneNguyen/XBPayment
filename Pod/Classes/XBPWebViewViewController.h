//
//  XBPWebViewViewController.h
//  Pods
//
//  Created by Binh Nguyen Xuan on 3/9/15.
//
//

#import <UIKit/UIKit.h>

@interface XBPWebViewViewController : UIViewController
{
    
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, assign) id<UIWebViewDelegate> delegate;
@property (nonatomic, retain) NSURL * url;

@end
