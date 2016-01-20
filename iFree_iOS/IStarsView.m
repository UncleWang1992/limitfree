//
//  IStarsView.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/9.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "IStarsView.h"

@implementation IStarsView {
    UIImageView *_foregroundView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customeViews];
    }
    return self;
}

- (void)customeViews {
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 23)];
    backgroundView.image = [UIImage imageNamed:@"StarsBackground"];
    [self addSubview:backgroundView];
    
    _foregroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _foregroundView.contentMode = UIViewContentModeLeft;
    _foregroundView.clipsToBounds = YES;
    _foregroundView.image = [UIImage imageNamed:@"StarsForeground"];
    [self addSubview:_foregroundView];
}

- (void)setLeveal:(double)leveal {
    _foregroundView.frame = CGRectMake(0, 0, 65*(leveal/5.00), 23);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
