//
//  TYResponseDefaultDispose.h
//  Legend
//
//  Created by yons on 17/6/7.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYResponseDisposeProtocal.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYResponseDefaultDispose : NSObject <TYResponseDisposeProtocal>

@property (nonatomic, weak) NSObject *context;
@property (nonatomic, copy) TYSuccessBlock success;
@property (nonatomic, copy) TYFailureBlock failure;
@property (nonatomic, copy) TYFinishedBlock finish;

@property (nonatomic, strong) NSString *responseObjClassName;

/**
 *  设置请求的上下文
 *  上下文的作用：
 网络请求回来，可以统一的对 上下文对象 做错误的处理
 */
- (void)setRequestContext:(NSObject *)context;

/**
 *  请求完成的回调
 *
 *  @return 请求完成的回调
 */
- (TYCompletionHandler)completion;

/**
 *  回调的处理
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
- (void)success:(TYSuccessBlock _Nullable)success failure:(TYFailureBlock _Nullable)failure;

/**
 *  回调的处理
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 *  @param finish 请求结束的回调
 */
- (void)success:(TYSuccessBlock _Nullable)success failure:(TYFailureBlock _Nullable)failure finish:(TYFinishedBlock _Nullable)finish;

/**
 *  设置请求结果的数据解析的目标模型类名
 *
 *  @param className 类名
 */
- (void)responseDataClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
