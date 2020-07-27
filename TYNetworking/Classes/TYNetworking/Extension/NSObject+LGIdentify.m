//
//  NSObject+LGIdentify.m
//  Legend
//
//  Created by yons on 17/7/11.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "NSObject+LGIdentify.h"
#import <objc/runtime.h>

@implementation NSObject (LGIdentify)

NSDateFormatter *staticDataFormatter() {
    static NSDateFormatter *defaultFmt = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultFmt = [[NSDateFormatter alloc] init];
        defaultFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
    });
    return defaultFmt;
}

/**
 *  使用默认标识绑定
 */
- (NSString *)lg_bindWithDefaultIdentify {
    NSDate *nowDate = [NSDate date];
    NSString *identify = [staticDataFormatter() stringFromDate:nowDate];
    [self lg_setIdentify:identify];
    return identify;
}

/**
 *  为对象绑定默认标识
 */
- (void)lg_setIdentify:(NSString *)identify {
    objc_setAssociatedObject(self, @selector(lg_identify), identify, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)lg_identify {
    return objc_getAssociatedObject(self, _cmd);
}

@end
