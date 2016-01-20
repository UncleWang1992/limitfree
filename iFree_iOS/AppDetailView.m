//
//  AppDetailView.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/11.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "AppDetailView.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>

#define DESCFONT [UIFont systemFontOfSize:12]

@implementation AppDetailView {
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_typeLabel;
    UIScrollView *_picScrollView;
    UILabel *_descLabel;
    
    UIButton *_shareButton;
    UIButton *_favouriteButton;
    UIButton *_downButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customViews];
    }
    return self;
}

- (void)customViews {
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:239 / 255.0 alpha:1.0];
    _iconImageView = [UIImageView new];
    [self addSubview:_iconImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:_titleLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor grayColor];
    _priceLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_priceLabel];
    
    _typeLabel = [UILabel new];
    _typeLabel.textColor = [UIColor grayColor];
    _typeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_typeLabel];
    
    
    _picScrollView = [UIScrollView new];
    [self addSubview:_picScrollView];
    
    _descLabel = [UILabel new];
    _descLabel.font = DESCFONT;
    _descLabel.numberOfLines = 0;
    _descLabel.textColor = [UIColor grayColor];
    [self addSubview:_descLabel];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_shareButton];
    
    _favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_favouriteButton setTitle:@"收藏" forState: UIControlStateNormal];
    [_favouriteButton addTarget:self action:@selector(favouriteAction:) forControlEvents:UIControlEventTouchUpInside];
    [_favouriteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_favouriteButton];
    
    
    _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downButton addTarget:self action:@selector(dowButtoAction:) forControlEvents:UIControlEventTouchUpInside];
    [_downButton setTitle:@"下载" forState: UIControlStateNormal];
    [_downButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_downButton];
    
    
}
- (void)shareAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClick:clickButonType:)]) {
        [_delegate buttonClick:self
                clickButonType:AppDetailButtonShare];
    }
    
}
- (void)favouriteAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClick:clickButonType:)]) {
        [_delegate buttonClick:self
                clickButonType:AppDetailButtonFavourite];
    }
}

- (void)dowButtoAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClick:clickButonType:)]) {
        [_delegate buttonClick:self
                clickButonType:AppDetailButtonDownLoad];
    }
    
}


- (void)setModel:(DetailModel *)model {
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil];
    _titleLabel.text = model.name;
    
    _priceLabel.text = [NSString stringWithFormat:@"￥%@ 免费中",model.currentPrice];
    _typeLabel.text = [NSString stringWithFormat:@"类型:%@ 评分%@",model.categoryName,model.starCurrent];
    _descLabel.text = model.desc;
    
    [self setViewFrames];
}
- (void)setViewFrames {
    
    CGFloat leftPadding = 10;
    CGFloat topPadding = 10;
    CGFloat padding = 10;
    
    _iconImageView.frame = CGRectMake(leftPadding, topPadding, 60, 60);
    
    CGFloat titleWidth = width(self) - maxX(_iconImageView) - 2*padding;
    
    _titleLabel.frame = CGRectMake(maxX(_iconImageView) + padding, topPadding/2, titleWidth, 20);
    
    _priceLabel.frame = CGRectMake(minX(_titleLabel), maxY(_titleLabel) + padding, titleWidth, 15);
    
    _typeLabel.frame = CGRectMake(minX(_titleLabel), maxY(_priceLabel) + padding, titleWidth, 15);
    
    CGFloat btnWidth = width(self)/3.0;
    CGFloat btnHeight = btnWidth/2.0;
    _shareButton.frame = CGRectMake(0, maxY(_iconImageView) + padding, btnWidth, btnHeight);
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"Detail_btn_left"] forState:UIControlStateNormal];
    _favouriteButton.frame = CGRectMake(maxX(_shareButton), minY(_shareButton), btnWidth, btnHeight);
    [_favouriteButton setBackgroundImage:[UIImage imageNamed:@"Detail_btn_middle"] forState:UIControlStateNormal];
    _downButton.frame = CGRectMake(maxX(_favouriteButton), minY(_shareButton), btnWidth, btnHeight);
    [_downButton setBackgroundImage:[UIImage imageNamed:@"Detail_btn_right"] forState:UIControlStateNormal];
    
    CGFloat scrollViewHeight = 100;
    _picScrollView.frame = CGRectMake(0, maxY(_downButton), width(self), scrollViewHeight);
    
    NSInteger imageCount = _model.photos.count;
    CGFloat scrollPadding  = 10;
    CGFloat imageWidth = (width(self) - 6*scrollPadding)/5.0;
    CGFloat imageHeight = scrollViewHeight - 2*scrollPadding;
    for (int i = 0; i < imageCount; i++) {
        UIImageView *imgeView = [[UIImageView alloc] init];
        imgeView.frame  = CGRectMake((scrollPadding+imageWidth)*i+scrollPadding, scrollPadding, imageWidth, imageHeight);
        PhotoModel *photoModel = _model.photos[i];
        [imgeView sd_setImageWithURL:[NSURL URLWithString:photoModel.smallUrl] placeholderImage:nil];
        [_picScrollView addSubview:imgeView];
    }
    _picScrollView.contentSize = CGSizeMake(imageCount*(scrollPadding + imageWidth) + scrollPadding, scrollViewHeight);
    
    CGSize descSize = [self sizeWithText:_model.desc maxSize:CGSizeMake(width(self) - 2*padding, CGFLOAT_MAX) font:DESCFONT];
    _descLabel.frame = CGRectMake(padding, maxY(_picScrollView), width(self) - 2*padding, descSize.height);
    
    _viewHeight = maxY(_descLabel) + padding;
    
}

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

- (void)setFavouriteButton:(BOOL)isFavourete {
    [_favouriteButton setTitle:isFavourete?@"已收藏":@"收藏" forState:UIControlStateNormal];
}

@end
