//
//  TYNetworkCenter.h
//  Legend
//
//  Created by yons on 17/6/6.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYNetworkingConst.h"
#import "TYNetworkingConst.h"
#import "TYResponseDisposeProtocal.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TYConfig;
@class TYRequest;

// 网络状态通知
//FOUNDATION_EXPORT NSString *const AFNetworkingReachabilityDidChangeNotification;
//FOUNDATION_EXPORT NSString *const AFNetworkingReachabilityNotificationStatusItem;

typedef void (^TYConfigBlock)(TYConfig *config);

typedef void (^TYRequestConfigBlock)(TYRequest *request);

@interface TYNetworkCenter : NSObject

#pragma mark **************** Class method ****************

+ (instancetype)center;

+ (instancetype)sharedCenter;

+ (NSString *)sendRequest:(TYRequestConfigBlock)configBlock
        completionHandler:(TYCompletionHandler)completionHandler;

+ (NSString *)context:(NSObject *)context
          sendRequest:(TYRequestConfigBlock)configBlock
    completionHandler:(TYCompletionHandler)completionHandler;

+ (NSString *)sendRequest:(TYRequestConfigBlock)configBlock
                  dispose:(id<TYResponseDisposeProtocal>)dispose;

+ (NSString *)context:(NSObject *)context
          sendRequest:(TYRequestConfigBlock)configBlock
              dispose:(id<TYResponseDisposeProtocal>)dispose;

#pragma mark ================ cancel ================

+ (void)cancelRequest:(NSString *)identifier;

+ (id)getRequest:(nullable NSString *)identifier;

/**
 *  请求上下文释放时，取消上下文上的所有请求
 *
 *  @param context 请求上下文
 */
+ (void)cancelRequestByContext:(nullable NSObject *)context;

/**
 *  开启检测网络情况
 *  需要注意的是，这个方法会调用到网络；
    在实现软件首次进入获取网络权限的实现中，如果想要控制权限获取弹窗的时机，
    需要注意该方法的调用
 */
+ (void)startMonitoringNetworkReachability;

+ (void)setReachabilityStatusChangeBlock:(nullable void (^)(TYNetworkReachabilityStatus status))block;

#pragma mark ================ 网络状态 ================

+ (TYNetworkReachabilityStatus)reachabilityStatus;

+ (BOOL)isNetworkReachable;

#pragma mark **************** Instance method ****************

- (void)setupConfig:(TYConfigBlock)configHandle;

- (NSString *)sendRequest:(TYRequestConfigBlock)configBlock
        completionHandler:(TYCompletionHandler)completionHandler;

- (NSString *)context:(NSObject *)context
          sendRequest:(TYRequestConfigBlock)configBlock
    completionHandler:(TYCompletionHandler)completionHandler;

/**
 *  发出请求，由 `id<TYResponseDisposeProtocal>` 处理请求结果
 *
 *  @param configBlock 回调 `AGRequest` 进行参数设置
 *  @param dispose     `id<TYResponseDisposeProtocal>` 处理者
 *
 *  @return 任务标识
 */
- (NSString *)sendRequest:(TYRequestConfigBlock)configBlock
                  dispose:(id<TYResponseDisposeProtocal>)dispose;

/**
 *  发出请求，由 `id<TYResponseDisposeProtocal>` 处理请求结果
 *
 *  @param context     请求上下文
 *  @param configBlock 回调 `AGRequest` 进行参数设置
 *  @param dispose     `id<TYResponseDisposeProtocal>` 处理者
 *
 *  @return 任务标识
 */
- (NSString *)context:(NSObject *)context
          sendRequest:(TYRequestConfigBlock)configBlock
              dispose:(id<TYResponseDisposeProtocal>)dispose;

#pragma mark -

/**
 *  网络发生变化时，自动控制请求：1，最大并发数
 */
//- (void)autoControllSessionWhenNetworkChanged;

#pragma mark -
- (TYNetworkReachabilityStatus)reachabilityStatus;

- (BOOL)isNetworkReachable;

@end

NS_ASSUME_NONNULL_END
