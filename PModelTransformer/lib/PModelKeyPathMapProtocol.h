//
//  PModelKeyPathMapProtocol.h
//  PModelTransformer
//
//  Created by 周爱林 on 2016/11/8.
//  Copyright © 2016年 dg11185. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PModelKeyPathMapProtocol <NSObject>

@optional
/**
 *  模型属性名与JSON数据的对应属性名
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_modelKeyToJSONKey;

/**
 *  模型属性名与自定义类的映射
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_modelKeyClassDictionary;

/**
 *  模型属性名与自定义类的映射（数组）
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_arrayKeyClassDictionary;

@end
