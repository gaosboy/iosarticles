//
//  Customer.h
//  Example
//
//  Created by 於 卓慧 on 12-10-11.
//  Copyright (c) 2012年 qiugonglue.com. All rights reserved.
//


#import "ExpressDelegate.h"

@interface Customer : NSObject

- (void)sendSomething;

@property (nonatomic,strong) id<ExpressDelegate> express;
@property (nonatomic,strong) id something;
@property (nonatomic,strong) NSString *address;
@end
