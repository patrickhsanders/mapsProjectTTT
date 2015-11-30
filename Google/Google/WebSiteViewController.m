//
//  WebSiteViewController.m
//  Google
//
//  Created by Patrick Sanders on 29.11.15.
//  Copyright © 2015 turntotech. All rights reserved.
//

#import "WebSiteViewController.h"

@implementation WebSiteViewController

- (instancetype)init{
    self = [super init];
    self.webView = [[WKWebView alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.view.backgroundColor = [[UIColor alloc] initWithWhite:.97 alpha:1];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 69)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Website";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    navItem.leftBarButtonItem = leftButton;
    
    navBar.items = @[ navItem ];
    
    self.wkViewConfig = [[WKWebViewConfiguration alloc] init];
    //self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width, self.view.bounds.size.height-69) configuration:self.wkViewConfig];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width, self.view.bounds.size.height-69)];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.webView.frame = self.view.frame;
    [self.view addSubview:self.webView];
    [self.view addSubview:navBar];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
