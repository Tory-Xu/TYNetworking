//
//  AGConfig.m
//  Legend
//
//  Created by yons on 17/6/6.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYConfig.h"

@implementation TYConfig

- (void)setAuthorizationHeaderFieldWithUserName:(NSString *)userName
                                       passWord:(NSString *)passWord {
    NSAssert([userName isKindOfClass:[NSString class]], @"userName 必须是一个 `NSString` 类型");
    NSAssert([passWord isKindOfClass:[NSString class]], @"passWord 必须是一个 `NSString` 类型");
    self.userName = userName;
    self.passWord = passWord;
}

- (void)setConfigUserAgent:(TYConfigUserAgentBlock)configUserAgent {
    _configUserAgent = configUserAgent;
}

@end
