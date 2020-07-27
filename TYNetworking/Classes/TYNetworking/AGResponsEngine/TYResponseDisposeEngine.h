//
//  TYResponseDisposeEngine.h
//  Legend
//
//  Created by yons on 17/6/7.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYResponseDisposeProtocal.h"
#import <Foundation/Foundation.h>

typedef void (^TYResponseConfigBlock)(id<TYResponseDisposeProtocal> dispose);

@interface TYResponseDisposeEngine : NSObject

+ (instancetype)engine;

+ (instancetype)sharedEngine;

/**
 *  设置处理者
 *
 *  @param dispose id<TYResponseDisposeProtocal>
 */
- (void)configDispose:(id<TYResponseDisposeProtocal>)dispose;

/**
 *  传递处理者处理的数据
 */
- (void)configResponse:(TYResponseConfigBlock)block;

@end
