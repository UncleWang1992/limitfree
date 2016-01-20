//
//  ApplicationView.h
//  iFree_iOS
//
//  Created by JackWong on 15/12/10.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"

@interface ApplicationView : UIView

@property (nonatomic, strong) SubModel *model;
- (void)resetPostion;
@end
