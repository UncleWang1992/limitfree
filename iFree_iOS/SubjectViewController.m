
//
//  SubjectViewController.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/9.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "SubjectViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import "SubjectModel.h"
#import "SubViewCell.h"
#import "ApplicationDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SubjectViewController () <UITableViewDelegate>
@end

@implementation SubjectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _appTableView.tableHeaderView = nil;
}
- (void)perpareToLoadData:(BOOL)isMore {
    NSInteger page = 1;
    NSString *urlString = nil;
    if (isMore) {
        if (_dataArray.count%10 != 0) {
            return;
        }
        page = _dataArray.count/10 + 1;
    }
    urlString = [NSString stringWithFormat:self.requestURL,page];
    [self loadDataFormNetWithURL:urlString isMore:isMore];
}

- (void)loadDataFormNetWithURL:(NSString *)urlString isMore:(BOOL)isMore {
    // 显示 loading 提示框
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!isMore) {
            [_dataArray removeAllObjects];
            [_appTableView reloadData];
        }
        NSArray *modelArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dict in modelArray) {
            SubjectModel *subjectModel = [[SubjectModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:subjectModel];
        }
        [_appTableView reloadData];
        
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_appTableView.mj_footer endRefreshing]:[_appTableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_appTableView.mj_footer endRefreshing]:[_appTableView.mj_header endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    SubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[SubViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        // 设置选中风格
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SubjectModel *model = _dataArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    
    cell.applicationSelectionBlock = ^(NSInteger index){
        SubModel *subModel = model.applications[index];
        ApplicationDetailViewController *applicationDetail = [ApplicationDetailViewController new];
        applicationDetail.title = @"应用详情";
        applicationDetail.hidesBottomBarWhenPushed = YES;
        applicationDetail.applicationID = subModel.applicationId;
        [weakSelf.navigationController pushViewController:applicationDetail animated:YES];
    };
    
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 350;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)addNavgationItemWithTitle:(NSString *)title aSelector:(SEL)aSelector isLeft:(BOOL)isLeft {
    
    
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
