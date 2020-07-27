//
//  TYResponseDefaultDispose.m
//  Legend
//
//  Created by yons on 17/6/7.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYResponseDefaultDispose.h"
#import <MJExtension/MJExtension.h>

@implementation TYResponseDefaultDispose

- (void)dealloc {
    TYNetworkLog(@"***************** TYResponseDefaultDispose dealloc *****************");
}

- (void)setRequestContext:(NSObject *)context {
    self.context = context;
}

- (TYCompletionHandler)completion {
    return ^(id _Nullable responseObject, NSError *_Nullable error) {

        if ([self respondsToSelector:@selector(serializationResponseData:)]) {
            responseObject = [self serializationResponseData:responseObject];
        }

        if (error) {
            //            TYNetworkLog(@"error info：{\n%@\n}", error);
            TYNetworkLog(@"\n**************** request error ****************** \n%@\n%@\n%@\n****************** End ******************\n", error.userInfo[@"NSLocalizedDescription"], error.userInfo[@"NSErrorFailingURLKey"], error.userInfo[@"com.alamofire.serialization.response.error.response"]);

            TYNetworkExecuteBlock(self.failure, responseObject, error);
        } else {

            // 请求结果的错误处理
            // ...

            TYNetworkExecuteBlock(self.success, responseObject);
        }

        TYNetworkExecuteBlock(self.finish, responseObject, error);
    };
}

- (void)success:(TYSuccessBlock _Nullable)success failure:(TYFailureBlock _Nullable)failure {
    [self success:success failure:failure finish:nil];
}

- (void)success:(TYSuccessBlock _Nullable)success failure:(TYFailureBlock _Nullable)failure finish:(TYFinishedBlock _Nullable)finish {
    self.success = success;
    self.failure = failure;
    self.finish = finish;
}

#pragma mark ================ optional ================

- (void)responseDataClassName:(NSString *)className {
    self.responseObjClassName = className;
}

- (id)serializationResponseData:(id)responseObject {
    if (self.responseObjClassName) {
        return [[NSClassFromString(self.responseObjClassName) class] mj_objectWithKeyValues:responseObject];
    }
    return responseObject;
}

@end
