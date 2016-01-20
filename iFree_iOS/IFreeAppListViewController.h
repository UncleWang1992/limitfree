//
//  IFreeAppListViewController.h
//  iFree_iOS
//
//  Created by JackWong on 15/12/9.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "IFreeBaseViewController.h"
@class AFHTTPRequestOperationManager;
@interface IFreeAppListViewController : IFreeBaseViewController {
    //数据源
    NSMutableArray *_dataArray;
    
    UITableView *_appTableView;
    
    //网络请求类
    AFHTTPRequestOperationManager *_manager;

}

/**
 *  分类使用的 ID
 */
@property (nonatomic, copy) NSString *categoryID;
/**
 *  每个页面对应的请求地址
 */
@property (nonatomic, copy) NSString *requestURL;

/**
 *  每个页面对应的类别
 */
@property (nonatomic, copy) NSString *categoryType;


- (void)loadDataFormNetWithURL:(NSString *)urlString isMore:(BOOL)isMore;
@end
