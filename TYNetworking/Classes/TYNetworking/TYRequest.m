//
//  AGRequest.m
//  Legend
//
//  Created by yons on 17/6/5.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYRequest.h"
#import "TYConfig.h"
#import "NSObject+LGIdentify.h"
#import <MJExtension/MJExtension.h>

static CGFloat kDefaultTimeOutInterval = 60.f;

@implementation TYRequest

+ (instancetype)request {
    return [[[self class] alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // default value
        _timeoutInterval = kDefaultTimeOutInterval;

        _useGeneralServer = YES;
        _useGeneralHeaders = YES;
        _useGeneralParameters = YES;
        _useConfigTimeoutInterval = YES;

        _httpRequestdType = TYNetworkRequestNormal;
        _httpMethodType = TYNetworkHttpMethodTypeGET;

        _requestSerializerType = TYNetworkRequestSerializerRAW;
        _responseSerializerType = TYNetworkResponseSerializerRAW;

        _cancelTaskWhenContextDealloc = YES;
    }
    return self;
}

#pragma mark -

- (void)setAuthorizationHeaderFieldWithUserName:(NSString *)userName
                                       passWord:(NSString *)passWord {
    NSAssert([userName isKindOfClass:[NSString class]], @"userName 必须是一个 `NSString` 类型");
    NSAssert([passWord isKindOfClass:[NSString class]], @"passWord 必须是一个 `NSString` 类型");
    self.userName = userName;
    self.passWord = passWord;
}

#pragma mark -

- (void)formateContext:(NSObject *)context {
    NSString *identfiy = [context lg_identify];
    if (identfiy == nil) {
        identfiy = [context lg_bindWithDefaultIdentify];
    }
    [self setValue:identfiy forKey:@"contextIdentify"];
    // `description` 的信息如果包含了 frame，bounds（UIView），
    // 在改变 frame 后获取到的值则发生了变化，因此不是用 `description`
    // [self setValue:[context description] forKey:@"context"];
}

- (BOOL)isEqualToContext:(NSObject *)context {
    if ([self.contextIdentify isEqualToString:[context lg_identify]]) {
        return YES;
    }
    return NO;
}

- (void)config:(TYConfig *)config {
    // add general user info to the request object.
    if (self.userInfo == nil && config.generalUserInfo) {
        self.userInfo = config.generalUserInfo;
    }

    // add general parameters to the request object.
    if (self.useGeneralParameters && config.generalParameters.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:config.generalParameters];
        if (self.parameters.count > 0) {
            [parameters addEntriesFromDictionary:self.parameters];
        }
        self.parameters = parameters;
    }

    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers addEntriesFromDictionary:self.HTTPRequestHeaders];

    if (config.configUserAgent) {
        NSDictionary *userAgent = config.configUserAgent();
        if (userAgent.allKeys.count > 0) {
            [headers addEntriesFromDictionary:userAgent];
        }
    }

    // add general headers to the request object.
    if (self.useGeneralHeaders && config.generalHeaders.count > 0) {
        [headers addEntriesFromDictionary:config.generalHeaders];
    }
    self.HTTPRequestHeaders = headers;

    if (self.baseURL == nil && config.generalServer.length > 0) {
        self.baseURL = [NSURL URLWithString:config.generalServer];
    }

    // process url for the request object.
    if (self.url.length == 0) {
        if (self.server.length == 0 && self.useGeneralServer && config.generalServer.length > 0) {
            self.server = config.generalServer;
        }
        if (self.api.length > 0) {
            NSURL *baseURL = [NSURL URLWithString:self.server];
            // ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected.
            if ([[baseURL path] length] > 0 && ![[baseURL absoluteString] hasSuffix:@"/"]) {
                baseURL = [baseURL URLByAppendingPathComponent:@""];
            }
            self.url = [[NSURL URLWithString:self.api relativeToURL:baseURL] absoluteString];
        } else {
            self.url = self.server;
        }
    }
    NSAssert(self.url.length > 0, @"The request url can't be null.");

    if (config.timeoutInterval > 0.f && self.useConfigTimeoutInterval) {
        self.timeoutInterval = config.timeoutInterval;
    }

    if (self.userName == nil &&
        self.passWord == nil &&
        config.userName.length > 0 &&
        config.passWord.length > 0) {
        [self setAuthorizationHeaderFieldWithUserName:config.userName
                                             passWord:config.passWord];
    }
}

- (NSString *)description {
    return [[self mj_keyValues] description];
}

@end
