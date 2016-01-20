//
//  SubViewCell.h
//  iFree_iOS
//
//  Created by JackWong on 15/12/10.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"

typedef void(^ApplicationSelectBlock)(NSInteger index);
@interface SubViewCell : UITableViewCell

@property (nonatomic, strong) SubjectModel *model;
@property (nonatomic, copy) ApplicationSelectBlock applicationSelectionBlock;

@end
