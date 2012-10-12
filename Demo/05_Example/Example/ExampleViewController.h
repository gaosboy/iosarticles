//
//  ExampleViewController.h
//  Example
//
//  Created by 於 卓慧 on 12-10-11.
//  Copyright (c) 2012年 qiugonglue.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExampleViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end
