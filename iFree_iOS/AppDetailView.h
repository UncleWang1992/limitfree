//
//  AppDetailView.h
//  iFree_iOS
//
//  Created by JackWong on 15/12/11.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailModel.h"

typedef enum : NSUInteger {
    AppDetailButtonShare,
    AppDetailButtonFavourite,
    AppDetailButtonDownLoad,
} AppDetailButtonType;

@class AppDetailView;
@protocol DetailButtonClickDelegate <NSObject>
- (void)buttonClick:(AppDetailView *)detailView clickButonType:(AppDetailButtonType)clickButonType;
@end

@interface AppDetailView : UIView
@property (nonatomic, weak) id<DetailButtonClickDelegate> delegate;

/**
 *  数据源
 */
@property (nonatomic, strong) DetailModel *model;
/**
 *  视图的高
 */
@property (nonatomic, assign, readonly) CGFloat viewHeight;

/**
 *  设置而收藏按钮的 title
 *
 *  @param isFavourete 是否收藏
 */
- (void)setFavouriteButton:(BOOL)isFavourete;

@end
