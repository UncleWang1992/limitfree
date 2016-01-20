//
//  IFreeAppListViewController.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/9.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "IFreeAppListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import "KillAllDefine.h"
#import "ApplicationModel.h"
#import "AppTableViewCell.h"
#import "UIView+Common.h"
#import "SearchViewController.h"
#import "NSString+Common.h"
#import "CategoryViewController.h"
#import "ApplicationDetailViewController.h"
// 缓存类
#import "JWCache.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface IFreeAppListViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, CategoryDelegate> {
    }
@end

@implementation IFreeAppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _categoryID = @"0";
    [self addNavgationItemWithTitle:@"分类" aSelector:@selector(categoryAction) isLeft:YES];
    [self addNavgationItemWithTitle:@"设置" aSelector:@selector(settingAction) isLeft:NO];
    [self createTableView];
    [self createSearchBar];
    // 初始化我们网络请求
    [self initRequestManager];
}

- (void)initRequestManager {
    if (_manager == nil) {
        _manager = [AFHTTPRequestOperationManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
}

- (void)categoryAction {
    NSLog(@"%s %@",__func__,self.categoryType);
    
    CategoryViewController *catetoryViewController = [CategoryViewController new];
    
    catetoryViewController.delegate = self;
//    catetoryViewController.categoryBlock = ^(NSString *categoryId) {
//        NSLog(@"哈哈我拿到 id 了 我要刷新了%@",categoryId);
//        _categoryID = categoryId;
//        [_appTableView.mj_header beginRefreshing];
//    };
    
    catetoryViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:catetoryViewController animated:YES];
}
// CategoryViewController 的代理方法
- (void)categoryViewDidSelect:(CategoryViewController *)categoryView categoryID:(NSString *)categoryID {
    _categoryID = categoryID;
    [_appTableView.mj_header beginRefreshing];
}
- (void)settingAction {
    NSLog(@"%s",__func__);
}

- (void)createTableView {
    
    if (_appTableView == nil) {
        _appTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _appTableView.delegate = self;
        _appTableView.dataSource = self;
        [self.view addSubview:_appTableView];
    }
    
    _appTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    _appTableView.separatorColor = [UIColor redColor];
    //隐藏下面的线
    _appTableView.tableFooterView = [UIView new];
    
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"下拉刷新");
        [self perpareToLoadData:NO];
    }];
    
    _appTableView.mj_header = header;

    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter  footerWithRefreshingBlock:^{
        NSLog(@"加载更多");
        [self perpareToLoadData:YES];
    }];
    _appTableView.mj_footer = footer;
    [_appTableView.mj_header beginRefreshing];
    
    
    
}

- (void)createSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width(_appTableView), 44.0)];
    searchBar.placeholder = @"60万款应用,搜搜看";
    searchBar.delegate = self;
    _appTableView.tableHeaderView = searchBar;
    
    
}

#pragma mark - 网络请求数据

- (void)perpareToLoadData:(BOOL)isMore {
    NSInteger page = 1;
    NSString *urlString = nil;
    if (isMore) {
        if (_dataArray.count%10 != 0) {
            return;
        }
        page = _dataArray.count/10 + 1;
    }
    if ([_categoryType isEqualToString:kLimitType] || [_categoryType isEqualToString:kReduceType] || [_categoryType isEqualToString:kFreeType]) {
        
        urlString = [NSString stringWithFormat:_requestURL,page,_categoryID];
        
    }else {
        urlString = [NSString stringWithFormat:_requestURL,page];
    }
    [self loadDataFormNetWithURL:urlString isMore:isMore];
}
/**
 *  网络请求数据
 *
 *  @param urlString
 *  @param isMore
 */
- (void)loadDataFormNetWithURL:(NSString *)urlString isMore:(BOOL)isMore {
    //显示 loading 提示框
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSData *cacheData = [JWCache objectForKey:MD5Hash(urlString)];
    if (cacheData) {
        ApplicationModel *model = [[ApplicationModel alloc] initWithData:cacheData error:nil];
        if (isMore) {
            [_dataArray addObjectsFromArray:model.applications];
        }else {
            [_dataArray removeAllObjects];
            [_appTableView reloadData];
            _dataArray = model.applications;
        }
        [_appTableView reloadData];
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_appTableView.mj_footer endRefreshing]:[_appTableView.mj_header endRefreshing];
        return;
    }
    [_manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ApplicationModel *model = [[ApplicationModel alloc] initWithData:responseObject error:nil];
        if (isMore) {
            [_dataArray addObjectsFromArray:model.applications];
        }else {
            [_dataArray removeAllObjects];
            [_appTableView reloadData];
            _dataArray = model.applications;
        }
        [_appTableView reloadData];
        isMore?[_appTableView.mj_footer endRefreshing]:[_appTableView.mj_header endRefreshing];
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        // 把数据进行缓存
        [JWCache setObject:responseObject forKey:MD5Hash(urlString)];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 隐藏 loading 提示框
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        isMore?[_appTableView.mj_footer endRefreshing]:[_appTableView.mj_header endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    AppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AppTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 设置选中风格
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row%2) {
        cell.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:239/255.0 alpha:1.0];
    }else {
        cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0  blue:242/255.0  alpha:1.0];
    }
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s",__func__);
    //TODO:详情页面
    //FIXME: 详情界面
    AppModel *model = _dataArray[indexPath.row];
    ApplicationDetailViewController *application = [ApplicationDetailViewController new];
    application.applicationID = model.applicationId;
    application.hidesBottomBarWhenPushed = YES;
    application.title = @"应用详情";
    [self.navigationController pushViewController:application animated:YES];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    [searchBar setShowsCancelButton:YES animated:YES];

    for (UIView *view in [searchBar.subviews[0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setTitle:@"取消" forState:UIControlStateNormal];
        }
    }

    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    
//    [@"" isEqual:<#(id)#>]
//    [@"" isEqualToString:<#(nonnull NSString *)#>]
//    
//    @"" == @""
//    
//    [@"" isKindOfClass:<#(__unsafe_unretained Class)#>];
//    [@"" isMemberOfClass:<#(__unsafe_unretained Class)#>];
    if (searchBar.text.length > 0) {
        SearchViewController *searchViewController = [SearchViewController new];
        if ([_categoryType isEqualToString:kLimitType]) {
            searchViewController.requestURL = SEARCH_LIMIT_URL;
        }else if ([_categoryType isEqualToString:kReduceType]) {
            searchViewController.requestURL = SEARCH_REDUCE_URL;
        }else if ([_categoryType isEqualToString:kFreeType]) {
            searchViewController.requestURL = SEARCH_FREE_URL;
        }else if ([_categoryType isEqualToString:kHotType]) {
            searchViewController.requestURL = SEARCH_HOT_URL;
        }

        //在地址遇到中文或特殊字符的时候,需要转码,服务端会有对应的解码
        searchViewController.searchText = URLEncodedString(searchBar.text);
        //push的时候会把 tabbar 隐藏掉
        searchViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchViewController animated:YES];
    }
    [searchBar resignFirstResponder];
    searchBar.text = @"";
 
    
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
