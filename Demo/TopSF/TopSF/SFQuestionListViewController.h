//
//  SFQuestionListViewController.h
//  TopSF
//
//  Created by jiajun on 9/27/12.
//  Copyright (c) 2012 SegmentFault.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFQuestionListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// 公共方法，刷新数据
- (void)refresh;

@end
