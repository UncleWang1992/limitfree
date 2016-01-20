//
//  IFreeBaseViewController.h
//  iFree_iOS
//
//  Created by JackWong on 15/12/9.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFreeBaseViewController : UIViewController
- (void)addNavgationItemWithTitle:(NSString *)title aSelector:(SEL)aSelector isLeft:(BOOL)isLeft;
@end
