//
//  SFWebViewController.m
//  TopSF
//
//  Created by jiajun on 9/27/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import "SFWebViewController.h"

@interface SFWebViewController ()

@property (strong, nonatomic) UIWebView                 *webView;
@property (strong, nonatomic) UIToolbar                 *toolBar;

// 初始化View最下方的ToolBar
- (void)initToolBar;
// webView事件完成后，刷新ToolBar
- (void)reloadToolBar;

// webView的四种操作
- (void)goBack;
- (void)goForward;
- (void)refresh;
- (void)stop;

// webView各种状态的回调方法
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

// 取消当前页面
- (void)dismiss;

@end

@implementation SFWebViewController

@synthesize toolBar                                     = _toolBar;
@synthesize webView                                     = _webView;
@synthesize url                                         = _url;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (nil == self.webView) {
        // 初始化webView，与初始化TableView相似。高度小49像素，为底部的ToolBar。
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.view.bounds.size.height - 49.0f)];
        self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        self.webView.multipleTouchEnabled = NO;
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        self.webView.autoresizesSubviews = YES;
        
        [self.view addSubview:self.webView];
    }
    
    // 初始化底部ToolBar
    [self initToolBar];
    
    // 开始加载页面请求
	[self loadRequest];
}

- (void)loadRequest {
    if (self.url) {
        // 构造一个HTTP请求，并开始加载
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [self.webView loadRequest:requestObj];
    }
}

#pragma mark - toolBar

- (void)initToolBar {
	if (nil == self.toolBar) {
		self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, self.webView.bounds.size.height, 320.0f, 49.0f)];
		self.toolBar.tintColor = [UIColor darkGrayColor];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goBackItem.png"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(goBack)];
        UIBarButtonItem *fowardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goForwardItem.png"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(goForward)];
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                     target:self
                                                                                     action:@selector(refresh)];
        UIBarButtonItem *stopItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                  target:self
                                                                                  action:@selector(stop)];
        backItem.enabled = NO;
        fowardItem.enabled = NO;
        refreshItem.enabled = NO;
        stopItem.enabled = YES;
        
        [self.toolBar setItems:[NSArray arrayWithObjects:
                                backItem,
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil],
                                fowardItem,
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil],
                                refreshItem,
                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil],
                                stopItem,
                                nil
                                ]];
        
        [self.view addSubview:self.toolBar];
    }
}

- (void)reloadToolBar {
	if (self.webView.canGoBack) {
		[[[self.toolBar items] objectAtIndex:0] setEnabled:YES];
	}
	else {
		[[[self.toolBar items] objectAtIndex:0] setEnabled:NO];
	}
	
	if (self.webView.canGoForward) {
		[[[self.toolBar items] objectAtIndex:2] setEnabled:YES];
	}
	else {
		[[[self.toolBar items] objectAtIndex:2] setEnabled:NO];
	}
    
	if (self.webView.loading) {
		[[[self.toolBar items] objectAtIndex:6] setEnabled:YES];
		[[[self.toolBar items] objectAtIndex:4] setEnabled:NO];
	}
	else {
		[[[self.toolBar items] objectAtIndex:6] setEnabled:YES];
		[[[self.toolBar items] objectAtIndex:4] setEnabled:YES];
	}
}

#pragma mark - action

- (void)goBack {
	[self.webView goBack];
}

- (void)goForward {
	[self.webView goForward];
}

- (void)refresh {
	[self.webView reload];
}

- (void)stop {
    if (self.webView.loading) {
        [self.webView stopLoading];
    }
    else {
        [self dismiss];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self reloadToolBar];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self reloadToolBar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self reloadToolBar];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
