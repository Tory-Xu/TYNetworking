//
//  NSObject+LGIdentify.h
//  Legend
//
//  Created by yons on 17/7/11.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LGIdentify)

/**
 *  使用默认标识绑定
 *  当前事件作为默认标识进行绑定，事件进去到毫秒
 */
- (NSString *)lg_bindWithDefaultIdentify;

/**
 *  为对象绑定默认标识
 */
- (void)lg_setIdentify:(NSString *)identify;

- (NSString *)lg_identify;

@end
