//
//  NSObject+LGDealloc.m
//  Legend
//
//  Created by againXu on 2017/6/27.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "UIViewController+TYDealloc.h"
#import "NSObject+LGRuntime.h"
#import "TYNetworkCenter.h"

@implementation UIViewController (TYDealloc)

+ (void)load {
    NSArray *selStringsArray = @[
        @"dealloc",
    ];
    [self lg_swizzleInstanceMethodList:selStringsArray prefix:@"ty_"];
}

/**
 *  分类中统一处理取消请求
 */
- (void)ty_dealloc {
    [TYNetworkCenter cancelRequestByContext:self];
    TYNetworkLog(@"ty_dealloc: %@", self);
    [self ty_dealloc];
}

@end
