//
//  TYViewControllerMultiRequest.m
//  TYNetworking_Example
//
//  Created by Tory on 2019/9/8.
//  Copyright © 2019 756165690@qq.com. All rights reserved.
//

#import "TYViewControllerMultiRequest.h"

#import <TYNetworking/TYNetworking.h>
#import <MJExtension/MJExtension.h>


@interface TYViewControllerMultiRequest ()

@end

@implementation TYViewControllerMultiRequest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"多个请求";
    self.view.backgroundColor = [UIColor whiteColor];
    

    UIButton *requestBtn = [UIButton buttonWithType:0];
    requestBtn.backgroundColor = [UIColor blueColor];
    [requestBtn setTitle:@"发起多个请求" forState:UIControlStateNormal];
    requestBtn.frame = CGRectMake(100, 100, 100, 44);
    [requestBtn sizeToFit];
    [requestBtn addTarget:self action:@selector(startRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:requestBtn];
}

- (void)startRequest {
    
    NSArray *urlList = @[@"https://www.jianshu.com/p/fb017bef35c9",
                         @"https://developer.apple.com/download/more/",
                         @"https://www.google.com/search?q=xcode+%E6%A8%A1%E6%8B%9F%E5%99%A8%E8%AE%BE%E7%BD%AE%E5%BC%B1%E7%BD%91&oq=xcode+%E6%A8%A1%E6%8B%9F%E5%99%A8%E8%AE%BE%E7%BD%AE%E5%BC%B1%E7%BD%91&aqs=chrome..69i57.7897j0j0&sourceid=chrome&ie=UTF-8",
                         @"https://www.jianshu.com/p/c53440f5df15",
                         @"https://blog.csdn.net/potato512/article/details/56291215",
                         @"https://www.jianshu.com/p/df115ffc1076",
                         @"https://git-lfs.github.com/",
                         @"https://blog.csdn.net/gang544043963/article/details/71511958",
                         @"https://ronghaopger.github.io/2017/12/iOS%E8%A7%A6%E6%8E%A7%E5%93%8D%E5%BA%94%E4%B8%AD%E9%82%A3%E4%BA%9B%E6%B2%A1%E6%9C%89%E7%BB%86%E6%83%B3%E8%BF%87%E7%9A%84%E9%97%AE%E9%A2%98/",
                         @"https://developer.apple.com/download/more/",
                         @"https://developer.apple.com/download/more/",
                         @"https://developer.apple.com/download/more/",
                         @"https://developer.apple.com/download/more/"];
    
    int count = 10;
    NSLog(@"开启 %d 个请求", count);
    
    for (int i = 0; i < count; i++) {
        id<TYResponseDisposeProtocal> dispose = [TYResponseDefaultDispose new];
        [dispose success:^(id _Nullable responseObject) {
            TYNetworkLog(@"请求 %d success: %@", i, [responseObject mj_JSONString]);
        }
                 failure:^(id _Nullable responseObject, NSError *_Nullable error) {
                     TYNetworkLog(@"请求 %d failure: %@ %@", i, responseObject, error);
                 }];
        
        [[TYNetworkCenter sharedCenter] context:self
                                    sendRequest:^(TYRequest *_Nonnull request) {
                                        
                                        
             request.url = urlList[i];
//            request.url = @"https://3g.163.com/touch/reconstruct/article/list/BA10TA81wangning/10-2.html";
        }
                                            dispose:dispose];
        // 退出控制器，控制器释放时取消未完成当前请求
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)dealloc {
    NSLog(@"%s dealloc", __func__);
}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
