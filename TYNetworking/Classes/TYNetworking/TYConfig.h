//
//  AGConfig.h
//  Legend
//
//  Created by yons on 17/6/6.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary * _Nonnull (^TYConfigUserAgentBlock)(void);

@class TYSessionEngine;

@interface TYConfig : NSObject

/**
 The general server address.
 */
@property (nonatomic, copy, nullable) NSString *generalServer;

/**
 The general parameters.
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *generalParameters;

/**
 The general headers.
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *generalHeaders;

@property (nonatomic, copy) TYConfigUserAgentBlock configUserAgent;
/**
 *  设置自己的 UserAgent 信息
 *
 *  @param configUserAgent `TYConfigUserAgentBlock`
 */
- (void)setConfigUserAgent:(TYConfigUserAgentBlock)configUserAgent;

/**
 The general user info.
 */
@property (nonatomic, strong, nullable) NSDictionary *generalUserInfo;

/**
 Timeout interval for request, `60` seconds by default.
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@property (nonatomic, assign) NSUInteger sessionQueueCountMaxWhenWifi;

@property (nonatomic, assign) NSUInteger sessionQueueCountMaxWhenWWAN;

/**
 Whether or not use default concurrent queue `"com.xmnetworking.request.completion.callback.queue"`. If `NO` (default), use `completionQueue`
 */
@property (nonatomic, assign) BOOL useDefaultConcurrentQueue;

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;

/**
 The global requests engine.
 */
@property (nonatomic, strong, nullable) TYSessionEngine *sessionEngine;

/**
 The console log BOOL value.
 */
@property (nonatomic, assign) BOOL consoleLog;

@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *passWord;

- (void)setAuthorizationHeaderFieldWithUserName:(NSString *)userName
                                       passWord:(NSString *)passWord;

@end

NS_ASSUME_NONNULL_END
