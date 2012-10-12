//
//  SFAppDelegate.h
//  TopSF
//
//  Created by jiajun on 9/27/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFQuestionListViewController;

@interface SFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SFQuestionListViewController *viewController;

@end
