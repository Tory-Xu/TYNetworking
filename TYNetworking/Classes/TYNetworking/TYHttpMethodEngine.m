//
//  AGRequestMethodEngine.m
//  Legend
//
//  Created by yons on 17/6/5.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYHttpMethodEngine.h"

@interface TYHttpMethodEngine ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *requestMethods;

@end

@implementation TYHttpMethodEngine

+ (instancetype)sharedEngine {
    static TYHttpMethodEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[[self class] alloc] init];
    });
    return engine;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethods[@(TYNetworkHttpMethodTypeGET)] = @"GET";
        self.requestMethods[@(TYNetworkHttpMethodTypePOST)] = @"POST";
        self.requestMethods[@(TYNetworkHttpMethodTypeDELETE)] = @"DELETE";
        self.requestMethods[@(TYNetworkHttpMethodTypeHEAD)] = @"HEAD";
        self.requestMethods[@(TYNetworkHttpMethodTypePUT)] = @"PUT";
        self.requestMethods[@(TYNetworkHttpMethodTypePATCH)] = @"PATCH";
    }
    return self;
}

- (NSString *)httpMethod:(TYNetworkHttpMethodType)methodType {
    return self.requestMethods[@(methodType)];
}

#pragma mark ================ Class method ================

+ (NSString *)httpMethod:(TYNetworkHttpMethodType)methodType {
    return [[TYHttpMethodEngine sharedEngine] httpMethod:methodType];
}

#pragma mark ================ Accessor ================

- (NSMutableDictionary<NSNumber *, NSString *> *)requestMethods {
    if (_requestMethods == nil) {
        _requestMethods = [[NSMutableDictionary<NSNumber *, NSString *> alloc] init];
    }
    return _requestMethods;
}

@end
