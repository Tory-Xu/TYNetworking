//
//  TYResponseDisposeEngine.m
//  Legend
//
//  Created by yons on 17/6/7.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYResponseDisposeEngine.h"

@interface TYResponseDisposeEngine ()

@property (nonatomic, strong) id<TYResponseDisposeProtocal> dispose;

@end

@implementation TYResponseDisposeEngine

+ (instancetype)engine {
    return [[[self class] alloc] init];
}

+ (instancetype)sharedEngine {
    static TYResponseDisposeEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [self engine];
    });
    return engine;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark -

- (void)configDispose:(id<TYResponseDisposeProtocal>)dispose {
    self.dispose = dispose;
}

- (void)configResponse:(TYResponseConfigBlock)block {
    block(self.dispose);
}

@end
