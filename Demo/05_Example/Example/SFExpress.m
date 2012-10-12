//
//  SFExpress.m
//  Example
//
//  Created by 於 卓慧 on 12-10-11.
//  Copyright (c) 2012年 qiugonglue.com. All rights reserved.
//

#import "SFExpress.h"

@implementation SFExpress

- (void)send:(id)something to:(NSString *)address {
    NSLog(@"我们用＊飞机＊把您的%@送到%@",something,address);
}

- (void)letOtherSidePaySend:(id)something to:(NSString *)address {
    NSLog(@"我们用＊飞机＊把您的%@送到%@,这个订单采用货到付款",something,address);
}

@end
