//
//  NSObject+PModel.h
//  PModelTransformer
//
//  Created by 周爱林 on 2016/11/8.
//  Copyright © 2016年 dg11185. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PModelKeyPathMapProtocol.h"

@interface NSObject (PModel) <PModelKeyPathMapProtocol>

/**
 *  获取模型属性名列表
 *
 *  @return 属性名列表NSArray
 */
+ (NSArray<NSString *> *)pm_propertyNameArray;

/**
 *  json转model（一对一）
 *
 *  @param jsonDictionary json字典数据
 *
 *  @return instancetype
 */
+ (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

/**
 *  json转model（多对多）
 *
 *  @param jsonArray json字典数据列表
 *
 *  @return NSArray
 */
+ (NSArray *)arrayWithJSONArray:(NSArray *)jsonArray;

/**
 *  将对象转化为键值对信息
 *
 *  @return 键值对
 */
- (NSDictionary *)pm_toDictionry;

@end
