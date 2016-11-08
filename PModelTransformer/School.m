//
//  School.m
//  IPModelTransformer
//
//  Created by 周爱林 on 2016/11/8.
//  Copyright © 2016年 dg11185. All rights reserved.
//

#import "School.h"

@implementation School

/**
 *  模型属性名与JSON数据的对应属性名
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_modelKeyToJSONKey {
    return @{
             @"ids":@"id",
             @"name":@"name",
             @"city":@"city"
             };
}

@end