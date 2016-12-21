//
//  User.m
//  IPModelTransformer
//
//  Created by hzw598 on 2016/11/8.
//  Copyright © 2016年 dg11185. All rights reserved.
//

#import "User.h"

@implementation User

/**
 *  模型属性名与JSON数据的对应属性名
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_modelKeyByJSONKey {
    return @{
             @"ids":@"id"
             };
}

/**
 *  模型属性名与自定义类的映射
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_arrayKeyClassDictionary {
    //schools是属性，School是类名
    return @{
             @"schools":@"School"
             };
}

@end
