//
//  TYNetworkTest.m
//  Legend
//
//  Created by yons on 17/6/7.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYNetworkTest.h"
#import "TYNetworking.h"

#import <MJExtension.h>

@implementation TYNetworkTest

- (instancetype)init {
    self = [super init];
    if (self) {
#pragma mark ================ 测试请求上下文释放时取消请求任务 ================
//        for (NSUInteger index = 0; index < 50; index++) {
//            [[TYNetworkCenter sharedCenter] context:self
//                sendRequest:^(TYRequest *request) {
//                    request.url = @"http://www.congacademy.com/knowledge/subject/1/all/0";
//                    TYNetworkLog(@"配置 %lu", index);
//                }
//                completionHandler:^(id _Nullable responseObject, NSError *_Nullable error) {
//                    //                TYNetworkLog(@"responseObject: %lu, responseObject: %d, error:%@", index, responseObject != nil, error);
//                    NSLog(@"%@", [NSThread currentThread]);
//                }];
//        }

        id<TYResponseDisposeProtocal> dispose = [TYResponseDefaultDispose new];
        for (NSUInteger index = 0; index < 50; index++) {
            [TYNetworkCenter context:self
                         sendRequest:^(TYRequest *_Nonnull request) {
                             request.url = @"https://3g.163.com/touch/reconstruct/article/list/BA10TA81wangning/10-2.html";
                             request.cancelTaskWhenContextDealloc = index % 2;
                         }
                             dispose:dispose];
        }
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [TYNetworkCenter cancelRequestByContext:self];
}

+ (void)test {

// 1，基本请求
//    TYRequest *request = [[TYRequest alloc] init];
//    request.url = @"http://www.congacademy.com/knowledge/subject/1/all/0";
//    request.httpMethodType = TYNetworkHttpMethodTypeGET;
//    [[TYSessionEngine sharedEngine] operationRequest:request
//                                   completionHandler:^(id _Nullable responseObject, NSError *_Nullable error) {
//                                       TYNetworkLog(@"responseObject = %@", responseObject);
//                                   }];

#pragma mark -

    // 配置全局请求参数
    [[TYNetworkCenter sharedCenter] setupConfig:^(TYConfig *config) {
        config.generalServer = @"http://www.congacademy.com/";
        config.consoleLog = NO;
        config.sessionQueueCountMaxWhenWWAN = 1;
        config.sessionQueueCountMaxWhenWifi = 1;
        config.timeoutInterval = 20.f;

        // 使用默认的并发队列
        //        config.useDefaultConcurrentQueue = YES;
        // 使用自己创建的队列
        //        config.completionQueue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);
    }];
    [TYNetworkCenter startMonitoringNetworkReachability];
//    [[TYNetworkCenter sharedCenter] autoControllSessionOperationMaxQueueCount];

//    [[TYNetworkCenter sharedCenter] sendRequest:^(TYRequest *request) {
//        request.url = @"http://www.congacademy.com/knowledge/subject/1/all/0";
//    }
//        completionHandler:^(id _Nullable responseObject, NSError *_Nullable error) {
//            TYNetworkLog(@"responseObject = %@", responseObject);
//        }];

#pragma mark ================ 测试并发量 ================
// 参看回调在那几个线程中完成
//    for (NSUInteger index = 0; index < 1000; index++) {
//        [[TYNetworkCenter sharedCenter] sendRequest:^(TYRequest *request) {
//            request.url = @"http://www.congacademy.com/knowledge/subject/1/all/0";
//            TYNetworkLog(@"配置 %lu", index);
//        }
//            completionHandler:^(id _Nullable responseObject, NSError *_Nullable error) {
//                TYNetworkLog(@"responseObject = %lu", index);
//            }];
//    }

#pragma mark ================ 请求结果处理 ================

    id<TYResponseDisposeProtocal> dispose = [TYResponseDefaultDispose new];
    [dispose success:^(id _Nullable responseObject) {
        
        TYNetworkLog(@"success: %@", [responseObject mj_JSONString]);
    }
        failure:^(id _Nullable responseObject, NSError *_Nullable error) {
            TYNetworkLog(@"failure: %@ %@", responseObject, error);
        }];

    [[TYNetworkCenter sharedCenter] sendRequest:^(TYRequest *_Nonnull request) {
        request.url = @"https://3g.163.com/touch/reconstruct/article/list/BA10TA81wangning/10-2.html";
    }
                                        dispose:dispose];
}

@end
