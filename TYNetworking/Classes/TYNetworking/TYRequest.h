//
//  TYRequest.h
//  Legend
//
//  Created by yons on 17/6/5.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYNetworkingConst.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TYConfig;

@interface TYRequest : NSObject

+ (instancetype)request;

// 请求的表示
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 The server address for request, eg. "http://example.com/v1/", if `nil` (default) and the `useGeneralServer` property is `YES` (default), the `generalServer` of XMCenter is used.
 */
@property (nonatomic, copy, nullable) NSString *server;

/**
 The API interface path for request, eg. "foo/bar", `nil` by default.
 */
@property (nonatomic, copy, nullable) NSString *api;

@property (nonatomic, copy, nullable) NSString *url;

@property (nonatomic, copy, nullable) NSURL *baseURL;

/**
 Timeout interval for request, `60` seconds by default.
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *parameters;

@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *HTTPRequestHeaders;

@property (nonatomic, strong, nullable) NSDictionary *userInfo;

/**
 *  发起请求的上下文，当上下文被释放的时候，上下文上的 `AGRequest` cancelTaskWhenContextDealloc == YES 的任务都会取消
 */
@property (nonatomic, strong, readonly) NSString *contextIdentify;

/**
 *  上下文释放的时候，如果请求没有完成，是否取消. YES by default
 */
@property (nonatomic, assign) BOOL cancelTaskWhenContextDealloc;

//!< Whether or not to use `generalServer` of XMCenter when request `server` is `nil`, `YES` by default.
@property (nonatomic, assign) BOOL useGeneralServer;
//!< Whether or not to append `generalHeaders` of XMCenter to request `headers`, `YES` by default.
@property (nonatomic, assign) BOOL useGeneralHeaders;
//!< Whether or not to append `generalParameters` of XMCenter to request `parameters`, `YES` by default.
@property (nonatomic, assign) BOOL useGeneralParameters;

// !<Whether or not to use `config` of AGConfig, `YES` by default.
@property (nonatomic, assign) BOOL useConfigTimeoutInterval;

@property (nonatomic, assign) TYNetworkRequestType httpRequestdType;

@property (nonatomic, assign) TYNetworkHttpMethodType httpMethodType;

/**
 Parameter serialization type for request, `TYNetworkRequestSerializerRAW` by default, see `TYNetworkRequestSerializerType` enum for details.
 */
@property (nonatomic, assign) TYNetworkRequestSerializerType requestSerializerType;

/**
 Response data serialization type for request, `TYNetworkResponseSerializerRAW` by default, see `TYNetworkResponseSerializerJSON` enum for details.
 */
@property (nonatomic, assign) TYNetworkResponseSerializerType responseSerializerType;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *passWord;

- (void)setAuthorizationHeaderFieldWithUserName:(NSString *)userName
                                       passWord:(NSString *)passWord;

#pragma mark -

- (void)formateContext:(NSObject *)context;

- (BOOL)isEqualToContext:(NSObject *)context;

- (void)config:(TYConfig *)config;

@end

NS_ASSUME_NONNULL_END
