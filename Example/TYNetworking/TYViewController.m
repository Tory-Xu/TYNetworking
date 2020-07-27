//
//  TYViewController.m
//  TYNetworking
//
//  Created by 756165690@qq.com on 09/01/2019.
//  Copyright (c) 2019 756165690@qq.com. All rights reserved.
//

#import "TYViewController.h"
#import "TYNetworkTest.h"

#import "TYViewControllerMultiRequest.h"

@interface TYViewController ()

@end

@implementation TYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setupUi];
//    [TYNetworkTest test];
}

- (void)jumpToMultiRequestVc {
    TYViewControllerMultiRequest *vc = [[TYViewControllerMultiRequest alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupUi {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *jumpBtn = [UIButton buttonWithType:0];
    jumpBtn.backgroundColor = [UIColor blueColor];
    [jumpBtn setTitle:@"进入页面发起多个请求" forState:UIControlStateNormal];
    jumpBtn.frame = CGRectMake(100, 100, 100, 44);
    [jumpBtn sizeToFit];
    [jumpBtn addTarget:self action:@selector(jumpToMultiRequestVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jumpBtn];

}

@end
