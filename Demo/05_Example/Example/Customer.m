//
//  Customer.m
//  Example
//
//  Created by 於 卓慧 on 12-10-11.
//  Copyright (c) 2012年 qiugonglue.com. All rights reserved.
//

#import "Customer.h"


@implementation Customer

- (void)dealloc {
    self.express = nil;
}

- (void)sendSomething {
    
    if ([self.express respondsToSelector:@selector(letOtherSidePaySend:to:)]) {
        [self.express letOtherSidePaySend:self.something to:self.address];
    } else {
        [self.express send:self.something to:self.address];
    }
}

@end
