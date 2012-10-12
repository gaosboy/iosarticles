//
//  ExpressDelegte.h
//  Example
//
//  Created by 於 卓慧 on 12-10-11.
//  Copyright (c) 2012年 qiugonglue.com. All rights reserved.
//

@protocol ExpressDelegate <NSObject>

@required
- (void)send:(id)something to:(NSString*)address;

@optional
- (void)letOtherSidePaySend:(id)something to:(NSString*)address;

@end
