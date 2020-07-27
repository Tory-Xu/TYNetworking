//
//  TestModel.m
//  Legend
//
//  Created by yons on 17/6/7.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TestModel.h"
#import <MJExtension/MJExtension.h>

@implementation TestModel

- (NSString *)description {
    return [[self mj_keyValues] description];
}

@end
