//
//  WebViewController.m
//  MapApp
//
//  Created by Aditya Narayan on 11/17/15.
//  Copyright © 2015 turntotech.io. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (instancetype) initWithURL:(NSURL *)url
{
  self = [super init];
  self.url = url;
  
  NSLog(@"Initialized webViewController");
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.wkViewConfig = [[WKWebViewConfiguration alloc] init];
  self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:self.wkViewConfig];
  self.webView.navigationDelegate = self;
  [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
  self.webView.frame = self.view.frame;
  [self.view addSubview:self.webView];
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
