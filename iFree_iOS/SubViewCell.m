//
//  SubViewCell.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/10.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "SubViewCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+Common.h"
#import "ApplicationView.h"

@implementation SubViewCell {
    UILabel *_titleLabel;
    UIImageView *_coverImageView;
    UIImageView *_mmImageView;
    UITextView *_mmTextView;
      NSMutableArray *_applications;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _applications = [NSMutableArray array];
        [self customViews];
    }
    return self;
}

- (void)customViews {
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    
    _coverImageView = [UIImageView new];
    [self.contentView addSubview:_coverImageView];
    
    _mmImageView = [UIImageView new];
    [self.contentView addSubview:_mmImageView];
    
    _mmTextView = [UITextView new];
    [self.contentView addSubview:_mmTextView];
    
    for (int i = 0 ; i < 4; i++) {
        ApplicationView *application = [ApplicationView new];
        application.tag = 1000 + i;
        application.hidden = YES;
        [self.contentView addSubview:application];
        [_applications addObject:application];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
        [application addGestureRecognizer:recognizer];
    }
    
}

- (void)tapRecognizer:(UITapGestureRecognizer *)tapRecognizer {
    ApplicationView *view = (ApplicationView *)[tapRecognizer view];
    NSInteger index = view.tag - 1000;
    NSLog(@"%ld",index);
    if (_applicationSelectionBlock) {
        _applicationSelectionBlock(index);
    }
    
}

- (void)setModel:(SubjectModel *)model {
    _model = model;
    
    _titleLabel.text = model.title;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    [_mmImageView sd_setImageWithURL:[NSURL URLWithString:model.desc_img] placeholderImage:nil];
    _mmTextView.text = model.desc;
    NSInteger applicationCount = model.applications.count;
//    applicationCount = 2
    for (int i = 0; i < 4; i++ ) {
        ApplicationView *application = _applications[i];

        if (i < applicationCount) {
            application.model = model.applications[i];
            application.hidden = NO;
        }else {
            application.hidden = YES;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat leftPadding = 10;
    CGFloat topPadding = 10;
    CGFloat padding = 10;
    
    _titleLabel.frame = CGRectMake(leftPadding, topPadding, width(self.contentView) - 2*leftPadding, 30);
    
    _coverImageView.frame = CGRectMake(leftPadding, maxY(_titleLabel), 150, 220);
    
    _mmImageView.frame = CGRectMake(leftPadding, maxY(_coverImageView) + 2*topPadding, 50, 50);
    
    _mmTextView.frame = CGRectMake(maxX(_mmImageView) + padding, minY(_mmImageView), width(self.contentView) - maxX(_mmImageView) - 2*padding , 50);
    NSInteger applicationCount = _model.applications.count;
    for (int i = 0; i < applicationCount; i++) {
        ApplicationView *applicationV = _applications[i];
        if (i == 0) {
            applicationV.frame = CGRectMake(maxX(_coverImageView) + padding, minY(_coverImageView), width(self.contentView) - maxX(_coverImageView) - 2*padding , 55);
            [applicationV resetPostion];
        }else {
            ApplicationView *lastApplication = _applications[i-1];
            applicationV.frame = CGRectMake(maxX(_coverImageView) + padding, maxY(lastApplication), width(lastApplication), 55);
            
            //这不是lastApplication reset 应该是applicationV resetPostion
            [applicationV resetPostion];
        }
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
