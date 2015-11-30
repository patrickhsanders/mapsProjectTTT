//
//  WebSiteViewController.h
//  Google
//
//  Created by Patrick Sanders on 29.11.15.
//  Copyright © 2015 turntotech. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;

@interface WebSiteViewController : UIViewController <WKNavigationDelegate>

@property (strong, nonatomic) IBOutlet WKWebView *webView;
@property (strong, nonatomic) WKWebViewConfiguration *wkViewConfig;
@property (strong, nonatomic) NSURL *url;

@end
