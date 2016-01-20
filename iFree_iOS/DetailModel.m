//
//  DetailModel.m
//  iFree_iOS
//
//  Created by JackWong on 15/12/11.
//  Copyright © 2015年 JackWong. All rights reserved.
//

#import "DetailModel.h"

@implementation PhotoModel
@end

@implementation DetailModel
+(JSONKeyMapper *)keyMapper{
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"desc"}];
}
@end
