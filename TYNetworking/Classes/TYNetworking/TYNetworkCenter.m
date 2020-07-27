//
//  AGNetworkCenter.m
//  Legend
//
//  Created by yons on 17/6/6.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYNetworkCenter.h"
#import "AFNetworkReachabilityManager.h"
#import "TYConfig.h"
#import "TYRequest.h"
#import "TYResponseDisposeEngine.h"
#import "TYSessionEngine.h"

@interface TYNetworkCenter ()

@property (nonatomic, strong) TYConfig *config;
@property (nonatomic, strong) TYSessionEngine *sessionEngine;

@end

@implementation TYNetworkCenter

+ (instancetype)center {
    return [[[self class] alloc] init];
}

+ (instancetype)sharedCenter {
    static TYNetworkCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [self center];
    });
    return center;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.config = [[TYConfig alloc] init];
        self.sessionEngine = [TYSessionEngine sharedEngine];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AFNetworkingReachabilityDidChangeNotification
                                                  object:nil];
}

#pragma mark -

- (void)setupConfig:(TYConfigBlock)configHandle {
    TYNetworkExecuteBlock(configHandle, self.config);
    if (self.config.sessionEngine) {
        self.sessionEngine = self.config.sessionEngine;
    }
    self.sessionEngine.useDefaultConcurrentQueue = self.config.useDefaultConcurrentQueue;
    if (self.config.completionQueue) {
        self.sessionEngine.completionQueue = self.config.completionQueue;
    }

#ifndef DEBUG
    self.config.consoleLog = NO;
#endif
}

- (NSString *)sendRequest:(TYRequestConfigBlock)configBlock
        completionHandler:(TYCompletionHandler)completionHandler {
    TYRequest *request = [TYRequest request];
    TYNetworkExecuteBlock(configBlock, request);

    [request config:self.config];
    [self ag_sendRequest:request completionHandler:completionHandler];
    return request.identifier;
}

- (NSString *)context:(NSObject *)context
          sendRequest:(TYRequestConfigBlock)configBlock
    completionHandler:(TYCompletionHandler)completionHandler {

    if (context == nil) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                             code:NSURLErrorCancelled
                                         userInfo:@{ @"NSLocalizedDescription": @"cancelled" }];
        // 取消时的 error
        //        error:Error Domain=NSURLErrorDomain Code=-999 "cancelled"
        //        UserInfo={NSErrorFailingURLKey=http://www.congacademy.com/knowledge/subject/1/all/0, NSLocalizedDescription=cancelled, NSErrorFailingURLStringKey=http://www.congacademy.com/knowledge/subject/1/all/0}

        completionHandler(nil, error);
        return nil;
    }
    TYRequest *request = [TYRequest request];
    [request formateContext:context];
    TYNetworkExecuteBlock(configBlock, request);

    [request config:self.config];
    [self ag_sendRequest:request completionHandler:completionHandler];
    return request.identifier;
}

- (NSString *)sendRequest:(TYRequestConfigBlock)configBlock
                  dispose:(id<TYResponseDisposeProtocal>)dispose {
    return [self sendRequest:configBlock
           completionHandler:^(id _Nullable responseObject, NSError *_Nullable error) {
               [[TYResponseDisposeEngine sharedEngine] configDispose:dispose];
               [[TYResponseDisposeEngine sharedEngine] configResponse:^(id<TYResponseDisposeProtocal> dispose) {
                   dispose.completion(responseObject, error);
               }];
           }];
}

- (NSString *)context:(NSObject *)context
          sendRequest:(TYRequestConfigBlock)configBlock
              dispose:(id<TYResponseDisposeProtocal>)dispose {

    return [self context:context
              sendRequest:configBlock
        completionHandler:^(id _Nullable responseObject, NSError *_Nullable error) {
            [[TYResponseDisposeEngine sharedEngine] configDispose:dispose];
            [[TYResponseDisposeEngine sharedEngine] configResponse:^(id<TYResponseDisposeProtocal> dispose) {
                dispose.completion(responseObject, error);
            }];
        }];
}

#pragma mark -

//- (void)autoControllSessionWhenNetworkChanged {
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AFNetworkingReachabilityDidChangeNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(networkingReachabilityDidChange:)
//                                                 name:AFNetworkingReachabilityDidChangeNotification
//                                               object:nil];
//}

#pragma mark -

- (TYNetworkReachabilityStatus)reachabilityStatus {
    //    return TYNetworkReachabilityStatusReachableViaWWAN; // test
    return [self.sessionEngine reachabilityStatus];
}

- (BOOL)isNetworkReachable {
    return self.sessionEngine.reachabilityStatus != TYNetworkReachabilityStatusNotReachable;
}

#pragma mark **************** private ****************

- (void)ag_sendRequest:(TYRequest *)request
     completionHandler:(TYCompletionHandler)completionHandler {
    if (self.config.consoleLog) {
        if (request.httpRequestdType == TYNetworkRequestDownload) {
            //            NSLog(@"\n============ [XMRequest Info] ============\nrequest download url: %@\nrequest save path: %@ \nrequest headers: \n%@ \nrequest parameters: \n%@ \n==========================================\n", request.url, request.downloadSavePath, request.HTTPRequestHeaders, request.parameters);
        } else {
            TYNetworkLog(@"\n============ [XMRequest Info] ============\nrequest url: %@ \nrequest headers: \n%@ \nrequest parameters: \n%@ \n==========================================\n", request.url, request.HTTPRequestHeaders, request.parameters);
        }
    }

    // send the request through XMEngine.
    [self.sessionEngine operationRequest:request completionHandler:completionHandler];
}

#pragma mark -

- (void)cancelRequest:(NSString *)identifier {
    [self.sessionEngine cancelRequestByIdentifier:identifier];
}

- (id)getRequest:(NSString *)identifier {
    return [self.sessionEngine getRequestByIdentifier:identifier];
}

- (void)cancelRequestByContext:(NSObject *)context {
    [self.sessionEngine cancelRequestByContext:context];
}

#pragma mark -

#pragma mark ================ noti ================

//- (void)networkingReachabilityDidChange:(NSNotification *)noti {
//    AFNetworkReachabilityStatus netWorkStatus = [noti.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
//    NSUInteger maxCount = 0;
//    switch (netWorkStatus) {
//        case AFNetworkReachabilityStatusReachableViaWWAN: {
//            maxCount = self.config.sessionQueueCountMaxWhenWWAN;
//            break;
//        }
//        case AFNetworkReachabilityStatusReachableViaWiFi: {
//            maxCount = self.config.sessionQueueCountMaxWhenWifi;
//            break;
//        }
//        default:
//            break;
//    }
//
//    if (maxCount > 0) {
//        [self.sessionEngine sessionOperationMaxQueueCount:maxCount];
//    } else {
//        [self.sessionEngine sessionOperationMaxQueueCount:AGSessinEngineSessionQueueDefaulMaxCount];
//    }
//}

#pragma mark **************** Class method ****************

+ (NSString *)sendRequest:(TYRequestConfigBlock)configBlock
        completionHandler:(TYCompletionHandler)completionHandler {
    return [[TYNetworkCenter sharedCenter] sendRequest:configBlock completionHandler:completionHandler];
}

+ (NSString *)context:(NSObject *)context
          sendRequest:(TYRequestConfigBlock)configBlock
    completionHandler:(TYCompletionHandler)completionHandler {
    return [[TYNetworkCenter sharedCenter] context:context sendRequest:configBlock completionHandler:completionHandler];
}

+ (NSString *)sendRequest:(TYRequestConfigBlock)configBlock
                  dispose:(id<TYResponseDisposeProtocal>)dispose {
    return [[TYNetworkCenter sharedCenter] sendRequest:configBlock dispose:dispose];
}

+ (NSString *)context:(NSObject *)context
          sendRequest:(TYRequestConfigBlock)configBlock
              dispose:(id<TYResponseDisposeProtocal>)dispose {
    return [[TYNetworkCenter sharedCenter] context:context sendRequest:configBlock dispose:dispose];
}

#pragma mark ================ cancel ================

+ (void)cancelRequest:(NSString *)identifier {
    [[TYNetworkCenter sharedCenter] cancelRequest:identifier];
}

+ (id)getRequest:(NSString *)identifier {
    return [[TYNetworkCenter sharedCenter] getRequest:identifier];
}

+ (void)cancelRequestByContext:(NSObject *)context {
    [[TYNetworkCenter sharedCenter] cancelRequestByContext:context];
}

+ (void)startMonitoringNetworkReachability {
    [[TYNetworkCenter sharedCenter].sessionEngine startMonitoringNetworkReachability];
}

+ (void)setReachabilityStatusChangeBlock:(nullable void (^)(TYNetworkReachabilityStatus status))block {
    [[TYNetworkCenter sharedCenter].sessionEngine setReachabilityStatusChangeBlock:block];
}

#pragma mark ================ 网络状态 ================

+ (TYNetworkReachabilityStatus)reachabilityStatus {
//    return TYNetworkReachabilityStatusReachableViaWWAN;
    return [[TYNetworkCenter sharedCenter] reachabilityStatus];
}

+ (BOOL)isNetworkReachable {
    return [[TYNetworkCenter sharedCenter] isNetworkReachable];
}

@end
