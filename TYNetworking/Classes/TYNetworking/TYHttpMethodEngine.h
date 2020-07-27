//
//  AGRequestMethodEngine.h
//  Legend
//
//  Created by yons on 17/6/5.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYNetworkingConst.h"
#import <Foundation/Foundation.h>

@interface TYHttpMethodEngine : NSObject

+ (instancetype)sharedEngine;

- (NSString *)httpMethod:(TYNetworkHttpMethodType)methodType;

#pragma mark ================ Class method ================

+ (NSString *)httpMethod:(TYNetworkHttpMethodType)methodType;

@end
