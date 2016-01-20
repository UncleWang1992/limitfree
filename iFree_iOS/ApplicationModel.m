//
//  ApplicationModel.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/9.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "ApplicationModel.h"

@implementation AppModel

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description":@"desc"}];
    
}

@end

@implementation ApplicationModel

@end
