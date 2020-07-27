//
//  TestModel.h
//  Legend
//
//  Created by yons on 17/6/7.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSString *codeMessage;
@property (nonatomic, strong) NSDictionary *result;

@end
