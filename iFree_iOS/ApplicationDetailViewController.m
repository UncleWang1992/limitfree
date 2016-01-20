//
//  ApplicationDetailViewController.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/11.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "ApplicationDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "KillAllDefine.h"
#import "DetailModel.h"
#import "AppDetailView.h"
#import "UIView+Common.h"
#import "DBManager.h"
#import <UMengSocial/UMSocial.h>
//邮件
#import <MessageUI/MessageUI.h>

@interface ApplicationDetailViewController ()<DetailButtonClickDelegate, MFMailComposeViewControllerDelegate> {
    UIScrollView *_scrollView;
    //详情页面
    AppDetailView *_detailView;
}

@end

@implementation ApplicationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0];
    [self createScrollView];
    [self loadDataFromeNet];
    
}

- (void)loadDataFromeNet {
    NSString *url = [NSString stringWithFormat:kDetailUrl,_applicationID];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DetailModel *model = [[DetailModel alloc] initWithData:responseObject error:nil];
        _detailView.model = model;
        [self resetScrollViewFrame];
        [self refreshDetailUI];
        NSLog(@"%@",model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)refreshDetailUI {
    DetailModel *model = _detailView.model;
    BOOL isExistRecord = [[DBManager sharedManager] isExistAppForAppId:model.applicationId recordType:model.categoryName];
    [_detailView setFavouriteButton:isExistRecord];
    
}

- (void)resetScrollViewFrame {
    
    _detailView.frame = CGRectMake(10, 10, width(_scrollView) - 20, _detailView.viewHeight);
    NSLog(@"%f",width(_scrollView));
    _scrollView.contentSize = CGSizeMake(width(self.view), _detailView.viewHeight);
    NSLog(@"%@",NSStringFromCGSize(_scrollView.contentSize));
}

- (void)createScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    // 取消延时响应
    _scrollView.delaysContentTouches = NO;
    [self.view addSubview:_scrollView];
    
    _detailView = [[AppDetailView alloc] initWithFrame:CGRectMake(10, 10, width(_scrollView) - 20, 0)];
    _detailView.delegate = self;
    [_scrollView addSubview:_detailView];
    
    
}
- (void)createActionSheet {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"微博" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"566a8c10e0f55aaf97001744"
                                          shareText:@"你要分享的文字"
                                         shareImage:[UIImage imageNamed:@"account_candou"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                           delegate:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            //指定发送给谁
            [mailController setToRecipients:@[@"1517@abc.com", @"10086@sb.com"]];
            //抄送给谁
            [mailController setCcRecipients:@[@"me@iluckly.com"]];
            // 设置主题
            [mailController setSubject:@"这个 APP 真棒,美女很多"];
            // 设置内容
            [mailController setMessageBody:[NSString stringWithFormat:@"我们的应用妹子比较多,快来下载吧!下载地址:%@", _detailView.model.itunesUrl] isHTML:NO];
            // 添加附件
            [mailController addAttachmentData:UIImagePNGRepresentation([UIImage imageNamed:@"account_candou"])
                                     mimeType:@"image/png" fileName:@"icon.png"];
            mailController.mailComposeDelegate = self;
            [self presentViewController:mailController
                               animated:YES
                             completion:^{
                                 
                             }];
            
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:action1];
    [controller addAction:action2];
    [controller addAction:action3];
    [self presentViewController:controller animated:YES completion:^{
        NSLog(@"视图弹出完毕");
    }];
    
}
// 邮件代理方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"邮件取消发送");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"保存邮件");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)buttonClick:(AppDetailView *)detailView clickButonType:(AppDetailButtonType)clickButonType {
    switch (clickButonType) {
        case AppDetailButtonShare: {
            [self createActionSheet];
        }
            break;
        case AppDetailButtonFavourite: {
            
            DetailModel *model = _detailView.model;
            //从数据库是否有收藏记录
            BOOL isExistRecord = [[DBManager sharedManager] isExistAppForAppId:model.applicationId recordType:model.categoryName];
            /**
             *  如果收藏过了,在点击即取消收藏
             */
            if (isExistRecord) {
                [[DBManager sharedManager] deleteModelForAppId:model.applicationId recordType:model.categoryName];
            }else {
                [[DBManager sharedManager] insertModel:model recordType:model.categoryName];
            }
            BOOL isExistRecord1 = [[DBManager sharedManager] isExistAppForAppId:model.applicationId recordType:model.categoryName];
            [_detailView setFavouriteButton:isExistRecord1];
        }
            break;
        case AppDetailButtonDownLoad:{
            //打开 appstore 对应的应用界面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-yang-erdemo-yin-le-xie/id735858889?mt=8"]];
        }
            break;
            
        default:
            break;
    }
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
