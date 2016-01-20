//
//  ApplicationView.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/10.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "ApplicationView.h"
#import "IStarsView.h"
#import "UIView+Common.h"
#import <UIImageView+WebCache.h>
@implementation ApplicationView {
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    IStarsView *_istartView;
    UIImageView *_downLoadImageView;
    UILabel *_downsLabel;
    
  
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customViews];
    }
    return self;
}

- (void)customViews {
    _iconImageView = [UIImageView new];
    [self addSubview:_iconImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_titleLabel];
    
    _istartView = [IStarsView new];
    [self addSubview:_istartView];
    
    _downLoadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topic_Download"]];
    [self addSubview:_downLoadImageView];
    
    _downsLabel = [UILabel new];
    _downsLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_downsLabel];
    
}
- (void)setModel:(SubModel *)model {
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil];
    
    _titleLabel.text = model.name;
    
    [_istartView setLeveal:[model.starOverall doubleValue]];
    
    _downsLabel.text = model.downloads;
    
  
}

- (void)resetPostion {
    CGFloat leftPadding = 0;
    CGFloat topPadding = 0;
    CGFloat padding = 10;
    
    _iconImageView.frame = CGRectMake(leftPadding, topPadding, 40, 40);
    _titleLabel.frame = CGRectMake(maxX(_iconImageView) + padding, topPadding, width(self) - width(_iconImageView) - padding*2, 15);

    
    _istartView.frame = CGRectMake(maxX(_iconImageView) + padding, maxY(_titleLabel) + padding, 65, 23);
    
    _downLoadImageView.frame = CGRectMake(maxX(_istartView) + padding, (height(self)-6)/2, 5, 6);
    
    _downsLabel.frame = CGRectMake(maxX(_downLoadImageView) + padding/2, minY(_downLoadImageView)-3, width(self)- maxX(_downLoadImageView) - padding, 12);
    
    
}

@end
