//
//  AppTableViewCell.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/9.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "AppTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+Common.h"
#import "KillAllDefine.h"
#import "IStarsView.h"

@implementation AppTableViewCell {
    
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_middleLabel;
    UILabel *_priceLabel;
    UILabel *_shareLabel;
    IStarsView *_starsView;
    UILabel *_lineLabel;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customViews];
    }
    return self;
}

- (void)customViews {
    
    _iconImageView = [UIImageView new];
    _iconImageView.layer.cornerRadius = 10.0;
    _iconImageView.layer.masksToBounds = YES;

    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    
    _middleLabel = [UILabel new];
    _middleLabel.textColor = [UIColor grayColor];
    _middleLabel.font = [UIFont systemFontOfSize:13];
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor grayColor];
    
    _shareLabel = [UILabel new];
    _shareLabel.textColor = [UIColor grayColor];
    _shareLabel.font = [UIFont systemFontOfSize:13];
    
    _starsView = [IStarsView new];
    _lineLabel = [UILabel new];
    _lineLabel.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_middleLabel];
    [self.contentView addSubview:_priceLabel];
    [self.contentView addSubview:_shareLabel];
    [self.contentView addSubview:_starsView];
    [self.contentView addSubview:_lineLabel];
    
    
}

- (void)setModel:(AppModel *)model {
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
    _titleLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.lastPrice];
    if ([model.priceTrend isEqualToString:kLimitType]) {
        // 根据一个字符切割字符串
        NSArray *strings = [model.expireDatetime componentsSeparatedByString:@" "];
        if (strings.count == 2) {
         _middleLabel.text = [NSString stringWithFormat:@"剩余时间:%@", strings[1]];
        }
        _lineLabel.hidden = NO;
        
    }else if ([model.priceTrend isEqualToString:kReduceType]) {
         _middleLabel.text = [NSString stringWithFormat:@"现价:￥%@",model.currentPrice];
        _lineLabel.hidden = NO;
    }else if ([model.priceTrend isEqualToString:kFreeType]) {
        _middleLabel.text = [NSString stringWithFormat:@"评分:%@分",model.starCurrent];
        _lineLabel.hidden = YES;
    } else if ([model.priceTrend isEqualToString:kHotType]) {
        _middleLabel.text = [NSString stringWithFormat:@"评分:%@分",model.starCurrent];
        _lineLabel.hidden = YES;
    }else {
        _middleLabel.text = [NSString stringWithFormat:@"评分:%@分",model.starCurrent];
        _lineLabel.hidden = YES;
    }

    _shareLabel.text = [NSString stringWithFormat:@"分享: %@ 收藏: %@ 下载: %@",model.shares,model.favorites,model.downloads];
    
    [_starsView setLeveal:[model.starCurrent doubleValue]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftPadding = 14;
    CGFloat topPadding = 10;
    CGFloat padding = 10.0;
    _iconImageView.frame = CGRectMake(leftPadding, topPadding, 60, 60);
    
    _titleLabel.frame = CGRectMake(maxX(_iconImageView) + padding, topPadding, width(self.contentView) - maxX(_iconImageView) - 2*padding , 20);
     _priceLabel.frame = CGRectMake(width(self.contentView) - 40 - padding, maxY(_titleLabel) + padding, 40, 20);
    
    _lineLabel.frame = CGRectMake(0, 0, width(_priceLabel), 1);
    _lineLabel.center = _priceLabel.center;
    
   
    
    _middleLabel.frame = CGRectMake(minX(_titleLabel), maxY(_titleLabel) + padding/2, width(self.contentView) - minX(_titleLabel) - width(_priceLabel) - padding, 15);
    
    _shareLabel.frame = CGRectMake(leftPadding, maxY(_iconImageView) + padding, width(self.contentView) - 2*padding, 20);
    
    _starsView.frame = CGRectMake(minX(_titleLabel), maxY(_middleLabel), 65, 23);
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
