//
//  LGTest.m
//  Legend
//
//  Created by againXu on 2017/6/15.
//  Copyright © 2017年 congacademy. All rights reserved.
//

#import "TYNetworkRateCheck.h"

#import <ifaddrs.h>
#include <net/if.h>

@interface TYNetworkRateCheck ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) long long int iRate;
@property (nonatomic, assign) long long int oRate;

@property (nonatomic, strong) UILabel *rateLabel;

@end

@implementation TYNetworkRateCheck

+ (instancetype)shareInstance {
    static TYNetworkRateCheck *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[[self class] alloc] init];
    });
    return obj;
}

+ (void)check {
    [[TYNetworkRateCheck shareInstance] start];
}

- (void)start {
    self.timer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(getByteRate)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [self.timer invalidate];
    self.timer = nil;
    [self.rateLabel removeFromSuperview];
}

// 获取下行速度
- (void)getByteRate {
    __block long long int iRate = 0;
    __block long long int oRate = 0;
    [self getInterfaceBytes:^(long long iBytes, long long oBytes) {
        iRate = iBytes;
        oRate = oBytes;
    }];

    //格式化一下
    NSString *iRateStr = [self formatNetWork:iRate - self.iRate];
    NSString *oRateStr = [self formatNetWork:oRate - self.oRate];

    //保存上一秒的下行总流量
    self.iRate = iRate;
    self.oRate = oRate;

    self.rateLabel.text = [NSString stringWithFormat:@" ↓%@ \n ↑%@ ", iRateStr, oRateStr];
    CGSize size = [self.rateLabel sizeThatFits:CGSizeMake(100, 40)];
    self.rateLabel.frame = CGRectMake(0, 0, size.width, size.height);
    self.rateLabel.center = CGPointMake(110, 15);
    if (self.rateLabel.superview == nil) {
        [[UIApplication sharedApplication].delegate.window addSubview:self.rateLabel];
    }
}

//获取数据流量详情
- (void)getInterfaceBytes:(void (^)(long long int iBytes, long long int oBytes))byte {

    struct ifaddrs *ifa_list = 0, *ifa;

    if (getifaddrs(&ifa_list) == -1) {

        return byte(0, 0);
    }

    uint32_t iBytes = 0; //下行

    uint32_t oBytes = 0; //上行

    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {

        if (AF_LINK != ifa->ifa_addr->sa_family)

            continue;

        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))

            continue;

        if (ifa->ifa_data == 0)

            continue;

        if (strncmp(ifa->ifa_name, "lo", 2)) {

            struct if_data *if_data = (struct if_data *) ifa->ifa_data;

            iBytes += if_data->ifi_ibytes;

            oBytes += if_data->ifi_obytes;
        }
    }

    freeifaddrs(ifa_list);

    //返回下行的总流量
    byte(iBytes, oBytes);
}

//格式化方法
- (NSString *)formatNetWork:(long long int)rate {
    if (rate < 1024) {
        return [NSString stringWithFormat:@"%lldB/s", rate];
    } else if (rate >= 1024 && rate < 1024 * 1024) {

        return [NSString stringWithFormat:@"%.1fKB/s", (double) rate / 1024];
    } else if (rate >= 1024 * 1024 && rate < 1024 * 1024 * 1024) {

        return [NSString stringWithFormat:@"%.2fMB/s", (double) rate / (1024 * 1024)];
    } else {
        return @"10Kb/秒";
    };
}

- (UILabel *)rateLabel {
    if (_rateLabel == nil) {
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.layer.cornerRadius = 5.f;
        _rateLabel.layer.masksToBounds = YES;
        _rateLabel.backgroundColor = [UIColor redColor];
        _rateLabel.font = [UIFont systemFontOfSize:10];
        _rateLabel.textColor = [UIColor whiteColor];
        _rateLabel.textAlignment = NSTextAlignmentCenter;
        _rateLabel.numberOfLines = 2;
    }
    return _rateLabel;
}

@end
