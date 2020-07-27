//
//  TYSessionEngine.h
//  Legend
//
//  Created by yons on 17/6/6.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYNetworkingConst.h"
#import <Foundation/Foundation.h>

@class TYRequest;

NS_ASSUME_NONNULL_BEGIN

@interface TYSessionEngine : NSObject

/**
 Whether or not use default concurrent queue `"com.xmnetworking.request.completion.callback.queue"`. If `NO` (default), use `completionQueue`
 */
@property (nonatomic, assign) BOOL useDefaultConcurrentQueue;

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
@property (nonatomic, strong, nullable) dispatch_queue_t completionQueue;

+ (instancetype)engine;

+ (instancetype)sharedEngine;

- (void)operationRequest:(TYRequest *)request completionHandler:(TYCompletionHandler)completionHandler;

#pragma mark ================ 取消任务 ================

- (TYRequest *)cancelRequestByIdentifier:(NSString *)identifier;

- (TYRequest *)getRequestByIdentifier:(NSString *)identifier;

- (NSArray<TYRequest *> *)cancelRequestByContext:(id)context;

- (NSArray<TYRequest *> *)getRequestByContext:(id)context;

//- (void)sessionOperationMaxQueueCount:(NSUInteger)queueCount;

#pragma mark ================ NetworkReachability ================

- (void)startMonitoringNetworkReachability;

- (void)setReachabilityStatusChangeBlock:(nullable void (^)(TYNetworkReachabilityStatus status))block;

- (TYNetworkReachabilityStatus)reachabilityStatus;

@end

FOUNDATION_EXPORT NSUInteger const AGSessinEngineSessionQueueDefaulMaxCount;

NS_ASSUME_NONNULL_END
