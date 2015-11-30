//
//  WebViewController.h
//  MapApp
//
//  Created by Aditya Narayan on 11/17/15.
//  Copyright © 2015 turntotech.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController <WKNavigationDelegate>
- (instancetype) initWithURL:(NSURL *)url;

@property (strong,nonatomic) WKWebView *webView;
@property (nonatomic, retain) WKWebViewConfiguration *wkViewConfig;
@property (nonatomic, strong) NSURL * url;

@end
