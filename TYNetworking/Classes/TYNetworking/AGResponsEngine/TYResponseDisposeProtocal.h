//
//  TYResponseDisposeProtocal.h
//  Legend
//
//  Created by yons on 17/6/7.
//  Copyright © 2017年 congacademy. All rights reserved.
//

/**
 实现这个协议的类，请添加相应需要的属性
 
 // 成功回调
 @property (nonatomic, copy) TYSuccessBlock success;
 
 // 错误回调
 @property (nonatomic, copy) TYFinishedBlock failure;
 
 // 请求结果的数据解析的目标模型类名
 @property (nonatomic, strong) NSString *responseObjClassName;
 
 */

#import "TYNetworkingConst.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TYResponseDisposeProtocal <NSObject>

@required

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
- (void)success:(TYSuccessBlock)success failure:(TYFailureBlock)failure;

/**
 *  回调的处理
 *
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 *  @param finish 请求结束的回调
 */
- (void)success:(TYSuccessBlock)success failure:(TYFailureBlock)failure finish:(nullable TYFinishedBlock)finish;

@optional

/**
 *  设置请求结果的数据解析的目标模型类名
 *
 *  @param className 类名
 */
- (void)responseDataClassName:(NSString *)className;

/**
 *  请求成功后，获取到的数据序列化处理
 *
 *  @return 序列化后的对象
 */
- (id)serializationResponseData:(id _Nullable)responseObject;

@end

NS_ASSUME_NONNULL_END
