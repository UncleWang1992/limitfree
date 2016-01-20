//
//  IFreeTabBarController.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/9.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "IFreeTabBarController.h"
#import "IFreeAppListViewController.h"
#import "KillAllDefine.h"
#import "AppDelegate.h"
#import "UIView+Common.h"

@interface IFreeTabBarController ()

@end

@implementation IFreeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self createSplashView];
}

- (void)createViewControllers {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"controllers" ofType:@"plist"];
    NSArray *vcArrays = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSArray *urlArray = @[kLimitUrl, kReduceUrl, kFreeUrl, kSubjectUrl, kHotUrl];
    
    NSArray *catagoryArray = @[kLimitType, kReduceType, kFreeType, kSubjectType, kHotType];
    // 创建存放控制器的数组
    NSMutableArray *controllers = [NSMutableArray new];
    int i = 0;
    for (NSDictionary *dict in vcArrays) {
        Class class = NSClassFromString(dict[@"className"]);
        IFreeAppListViewController *controller = [[class alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.tabBarItem.image = [UIImage imageNamed:dict[@"iconName"]];
        controller.title = dict[@"title"];
        
        controller.requestURL = urlArray[i];
        
        controller.categoryType = catagoryArray[i++];
        
        [controllers addObject:nav];
    }
    self.viewControllers = controllers;


}

- (void)createSplashView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight())];
    
    NSString *splashPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Defaultretein%d@2x",arc4random_uniform(7) + 1] ofType:@"png"];
    
    imageView.image = [[UIImage alloc] initWithContentsOfFile:splashPath];
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:3 animations:^{
        imageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
