//
//  SFWebViewController.h
//  TopSF
//
//  Created by jiajun on 9/27/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFWebViewController : UIViewController <UIWebViewDelegate>

// 当前要载入页面的URL
@property (strong, nonatomic) NSString                  *url;

// 加载页面请求
- (void)loadRequest;

@end
