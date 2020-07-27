//
//  AGSessionEngine.m
//  Legend
//
//  Created by yons on 17/6/6.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYSessionEngine.h"

#import "TYHttpMethodEngine.h"
#import "TYRequest.h"

//#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

static dispatch_queue_t ag_request_completion_callback_queue() {
    static dispatch_queue_t _ag_request_completion_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ag_request_completion_queue = dispatch_queue_create("com.networking.request.completion.callback.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return _ag_request_completion_queue;
}

NSUInteger const AGSessinEngineSessionQueueDefaulMaxCount = 1;

static NSString *const AGSessionEngineLockName = @"com.ag.networking.session.engine.lock";

#pragma mark ================ AGRequest Binding ================

@implementation NSObject (BindingXMRequest)

static NSString *const kAGRequestBindingKey = @"kAGRequestBindingKey";

- (void)ag_bindingRequest:(TYRequest *)request {
    objc_setAssociatedObject(self, (__bridge CFStringRef) kAGRequestBindingKey, request, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TYRequest *)ag_bindingRequest {
    TYRequest *request = objc_getAssociatedObject(self, (__bridge CFStringRef) kAGRequestBindingKey);
    return request;
}

@end

@interface TYSessionEngine ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) AFHTTPRequestSerializer *afHTTPRequestSerializer;
@property (nonatomic, strong) AFJSONRequestSerializer *afJSONRequestSerializer;
@property (nonatomic, strong) AFPropertyListRequestSerializer *afPListRequestSerializer;

@property (nonatomic, strong) AFHTTPResponseSerializer *afHTTPResponseSerializer;
@property (nonatomic, strong) AFJSONResponseSerializer *afJSONResponseSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *afXMLResponseSerializer;
@property (nonatomic, strong) AFPropertyListResponseSerializer *afPListResponseSerializer;

@property (readwrite, nonatomic, strong) NSLock *lock;

@end

@implementation TYSessionEngine

+ (instancetype)engine {
    return [[[self class] alloc] init];
}

+ (instancetype)sharedEngine {
    static TYSessionEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [self engine];
    });
    return engine;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
        self.lock.name = AGSessionEngineLockName;
    }
    return self;
}

#pragma mark -

- (void)operationRequest:(TYRequest *)request completionHandler:(TYCompletionHandler)completionHandler {
    switch (request.httpRequestdType) {
        case TYNetworkRequestNormal: {
            [self ag_dataTaskWithRequest:request completionHandler:completionHandler];
            break;
        }
        case TYNetworkRequestUpload: {
            break;
        }
        case TYNetworkRequestDownload: {
            break;
        }
        default:
            NSAssert(NO, @"UnKnow request type");
            break;
    }
}

- (TYRequest *)cancelRequestByIdentifier:(NSString *)identifier {
    if (identifier == nil || identifier.length == 0) return nil;

    [self.lock lock];
    NSArray *tasks = self.sessionManager.tasks;
    __block TYRequest *request = nil;
    if (tasks.count > 0) {
        [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
            if ([task.ag_bindingRequest.identifier isEqualToString:identifier]) {
                request = task.ag_bindingRequest;
                [task cancel];
                *stop = YES;
            }
        }];
    }
    [self.lock unlock];
    return request;
}

- (TYRequest *)getRequestByIdentifier:(NSString *)identifier {
    if (identifier.length == 0) return nil;

    [self.lock lock];
    NSArray *tasks = self.sessionManager.tasks;
    __block TYRequest *request = nil;
    [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
        if ([task.ag_bindingRequest.identifier isEqualToString:identifier]) {
            request = task.ag_bindingRequest;
            *stop = YES;
        }
    }];
    [self.lock unlock];
    return request;
}

- (NSArray<TYRequest *> *)cancelRequestByContext:(NSObject *)context {
    if (context == nil) {
        return nil;
    }

    [self.lock lock];
    NSArray *tasks = self.sessionManager.tasks;
    __block NSMutableArray *cancelRequests = [NSMutableArray array];
    if (tasks.count > 0) {
        [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
            TYRequest *request = task.ag_bindingRequest;
            if ([request isEqualToContext:context] && request.cancelTaskWhenContextDealloc) {
                [cancelRequests addObject:request];
                [task cancel];
                TYNetworkLog(@"\n*********************************************\n 取消了上下文(%@)上未完成的请求：{\n%@\n}\n*********************************************\n", context, request);
            }
        }];
    }
    [self.lock unlock];
    //    TYNetworkLog(@"取消了上下文上未完成的请求数：{ %ld }", cancelRequests.count);
    return cancelRequests;
}

- (NSArray<TYRequest *> *)getRequestByContext:(id)context {
    if (context == nil) {
        return nil;
    }

    [self.lock lock];
    NSArray *tasks = self.sessionManager.tasks;
    __block NSMutableArray *cancelRequests = [NSMutableArray array];
    [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL *stop) {
        TYRequest *request = task.ag_bindingRequest;
        if ([request isEqualToContext:context] && request.cancelTaskWhenContextDealloc) {
            [cancelRequests addObject:request];
            *stop = YES;
        }
    }];
    [self.lock unlock];
    return cancelRequests;
}

- (void)sessionOperationMaxQueueCount:(NSUInteger)queueCount {
    self.sessionManager.operationQueue.maxConcurrentOperationCount = queueCount;
}

#pragma mark ================ NetworkReachability ================

- (void)startMonitoringNetworkReachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)setReachabilityStatusChangeBlock:(nullable void (^)(TYNetworkReachabilityStatus status))block {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        TYNetworkExecuteBlock(block, (TYNetworkReachabilityStatus) status);
    }];
}

- (TYNetworkReachabilityStatus)reachabilityStatus {
    return (TYNetworkReachabilityStatus)[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

#pragma mark - private

- (void)ag_dataTaskWithRequest:(TYRequest *)request
             completionHandler:(TYCompletionHandler)completionHandler {

    NSString *httpMethod = [TYHttpMethodEngine httpMethod:request.httpMethodType];
    NSAssert(httpMethod.length > 0, @"The HTTP method not found.");

    NSError *serializationError = nil;

    // 中文字符处理
    // baseUrl 处理
    NSString *URLString = [[NSURL URLWithString:[request.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                  relativeToURL:request.baseURL] absoluteString];
    AFHTTPRequestSerializer *httpRequestSerializer = [self ag_getRequestSerializer:request];

    if (request.userName.length > 0 && request.passWord.length > 0) {
        [httpRequestSerializer setAuthorizationHeaderFieldWithUsername:request.userName
                                                              password:request.passWord];
    }

    NSMutableURLRequest *urlRequest = [httpRequestSerializer requestWithMethod:httpMethod
                                                                     URLString:URLString
                                                                    parameters:request.parameters
                                                                         error:&serializationError];

    if (serializationError) {
        if (completionHandler) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                completionHandler(nil, serializationError);
            });
        }
        return;
    }

    [self ag_setHTTPRequestHeaders:urlRequest WithRequest:request];

    urlRequest.timeoutInterval = request.timeoutInterval;

    NSURLSessionDataTask *dataTask = nil;
    __weak __typeof(self) weakSelf = self;
    dataTask = [self.sessionManager dataTaskWithRequest:urlRequest uploadProgress:nil
                                       downloadProgress:nil
                                      completionHandler:^(NSURLResponse * _Nonnull response,
                                                          id  _Nullable responseObject,
                                                          NSError * _Nullable error) {
                                          __strong __typeof(weakSelf) strongSelf = weakSelf;
                                          [strongSelf ag_serializerResponse:response
                                                             responseObject:responseObject
                                                                      error:error
                                                                    request:request
                                                          completionHandler:completionHandler];
                                      }];

    [self ag_setIdentifierForReqeust:request taskIdentifier:dataTask.taskIdentifier];
    [dataTask ag_bindingRequest:request];
    [dataTask resume];
}

- (void)ag_setHTTPRequestHeaders:(NSMutableURLRequest *)urlRequest WithRequest:(TYRequest *)request {
    [request.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull value, BOOL *_Nonnull stop) {
        [urlRequest setValue:value forHTTPHeaderField:key];
    }];
}

- (void)ag_serializerResponse:(NSURLResponse *)response
               responseObject:(id)responseObject
                        error:(NSError *)error
                      request:(TYRequest *)request
            completionHandler:(TYCompletionHandler)completionHandler {

    NSError *serializationError = nil;
    if (request.responseSerializerType != TYNetworkResponseSerializerRAW) {
        AFHTTPResponseSerializer *responseSerializer = [self ag_getResponseSerializer:request];
        responseObject = [responseSerializer responseObjectForResponse:response data:responseObject error:&serializationError];
    }
    if (completionHandler) {
        if (serializationError) {
            completionHandler(nil, serializationError);
        } else {
            completionHandler(responseObject, error);
        }
    }
}

- (AFHTTPRequestSerializer *)ag_getRequestSerializer:(TYRequest *)request {
    switch (request.requestSerializerType) {
        case TYNetworkRequestSerializerRAW: {
            return self.afHTTPRequestSerializer;
            break;
        }
        case TYNetworkRequestSerializerJSON: {
            return self.afJSONRequestSerializer;
            break;
        }
        case TYNetworkRequestSerializerPlist: {
            return self.afPListRequestSerializer;
            break;
        }
        default:
            NSAssert(NO, @"Unknown request serializer type.");
            break;
    }
}

- (AFHTTPResponseSerializer *)ag_getResponseSerializer:(TYRequest *)request {
    switch (request.responseSerializerType) {
        case TYNetworkResponseSerializerJSON: {
            return self.afJSONResponseSerializer;
            break;
        }
        case TYNetworkResponseSerializerRAW: {
            return self.afHTTPResponseSerializer;
            break;
        }
        case TYNetworkResponseSerializerPlist: {
            return self.afPListResponseSerializer;
            break;
        }
        case TYNetworkResponseSerializerXML: {
            return self.afXMLResponseSerializer;
            break;
        }
        default:
            NSAssert(NO, @"Unknown response serializer type.");
            break;
    }
}

#pragma mark -

- (void)ag_setIdentifierForReqeust:(TYRequest *)request
                    taskIdentifier:(NSUInteger)taskIdentifier {
    NSString *identifier = [NSString stringWithFormat:@"%lu", (unsigned long) taskIdentifier];
    // identifier 是只读的，使用 kvc 赋值
    [request setValue:identifier forKey:@"_identifier"];
}

#pragma mark ================ Accessor ================

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = self.afHTTPRequestSerializer;
        _sessionManager.responseSerializer = self.afHTTPResponseSerializer;
        if (self.useDefaultConcurrentQueue) {
            _sessionManager.completionQueue = ag_request_completion_callback_queue();
        } else if (self.completionQueue) {
            _sessionManager.completionQueue = self.completionQueue;
        }
    }
    return _sessionManager;
}

- (AFHTTPRequestSerializer *)afHTTPRequestSerializer {
    if (!_afHTTPRequestSerializer) {
        _afHTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _afHTTPRequestSerializer;
}

- (AFJSONRequestSerializer *)afJSONRequestSerializer {
    if (!_afJSONRequestSerializer) {
        _afJSONRequestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _afJSONRequestSerializer;
}

- (AFPropertyListRequestSerializer *)afPListRequestSerializer {
    if (!_afPListRequestSerializer) {
        _afPListRequestSerializer = [AFPropertyListRequestSerializer serializer];
    }
    return _afPListRequestSerializer;
}

- (AFHTTPResponseSerializer *)afHTTPResponseSerializer {
    if (!_afHTTPResponseSerializer) {
        _afHTTPResponseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _afHTTPResponseSerializer;
}

- (AFJSONResponseSerializer *)afJSONResponseSerializer {
    if (!_afJSONResponseSerializer) {
        _afJSONResponseSerializer = [AFJSONResponseSerializer serializer];
        // Append more other commonly-used types to the JSON responses accepted MIME types.
        _afJSONResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json;charset&#x3D;UTF-8",
                                                                                 @"text/json",
                                                                                 @"text/javascript",
                                                                                 @"text/html",
                                                                                 @"text/plain",
                                                                                 nil];
    }
    return _afJSONResponseSerializer;
}

- (AFXMLParserResponseSerializer *)afXMLResponseSerializer {
    if (!_afXMLResponseSerializer) {
        _afXMLResponseSerializer = [AFXMLParserResponseSerializer serializer];
    }
    return _afXMLResponseSerializer;
}

- (AFPropertyListResponseSerializer *)afPListResponseSerializer {
    if (!_afPListResponseSerializer) {
        _afPListResponseSerializer = [AFPropertyListResponseSerializer serializer];
    }
    return _afPListResponseSerializer;
}

@end
