//
//  NSObject+PModel.m
//  PModelTransformer
//
//  Created by hzw598 on 2016/11/8.
//  Copyright © 2016年 dg11185. All rights reserved.
//

#import "NSObject+PModel.h"
#import <objc/runtime.h>

@implementation NSObject (PModel)

/**
 *  模型属性名与JSON数据的对应属性名
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_modelKeyByJSONKey {
    return nil;
}

/**
 *  模型属性名与自定义类的映射
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_modelKeyClassDictionary {
    return nil;
}

/**
 *  模型属性名与自定义类的映射（数组）
 *
 *  @return 映射字典NSDictionary
 */
+ (NSDictionary *)pm_arrayKeyClassDictionary {
    return nil;
}

/**
 *  获取模型属性名列表
 *
 *  @return 属性名列表NSArray
 */
+ (NSArray<NSString *> *)pm_propertyNameArray {
    
    Class clazz = [self class];
    NSString *clazzName = NSStringFromClass(clazz);
    //递归截止
    if ([clazzName isEqualToString:@"NSObject"]) {
        return @[];
    }
    
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList(clazz, &count);
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    //遍历类属性
    for (unsigned int i=0; i<count; i++) {
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        [propertyArray addObject:propertyName];
    }
    
    free(propertyList);
    
    //递归遍历父类属性
    Class superClazz = [self superclass];
    [propertyArray addObjectsFromArray:[superClazz pm_propertyNameArray]];
    
    return propertyArray;
}

/**
 *  json转model（属性名与json字典键名不对应，需要映射）
 *
 *  @param jsonDictionary          需要转换的json字典数据
 *  @param mapKeyDictionary        数据模型属性名与json字典数据对应键名
 *  @param keyClassDictionary      数据模型属性名对应的类名
 *  @param keyClassArrayDictionary 数据模型属性名对应的类名（数组）
 *
 *  @return instancetype
 */
+ (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary
                      mapKeyDictionary:(NSDictionary *)mapKeyDictionary
                    keyClassDictionary:(NSDictionary *)keyClassDictionary
               keyClassArrayDictionary:(NSDictionary *)keyClassArrayDictionary
{
    //对象
    NSObject<PModelKeyPathMapProtocol> *objc = [[self alloc] init];
    
    [mapKeyDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = jsonDictionary[obj];
        //如果包含组合类对象（数组）
        if (value && [value isKindOfClass:[NSArray class]] && keyClassArrayDictionary) {
            NSString *clazzName = keyClassArrayDictionary[key];
            if (clazzName) {
                Class clazz = NSClassFromString(clazzName);
                NSArray *modelArray = [clazz arrayWithJSONArray:value];
                value = [modelArray copy];
            }
        } else if (value && [value isKindOfClass:[NSDictionary class]] && keyClassDictionary) {
            //如果包含单个组合类对象
            NSString *clazzName = keyClassDictionary[key];
            if (clazzName) {
                Class clazz = NSClassFromString(clazzName);
                NSObject<PModelKeyPathMapProtocol> *model = [clazz initWithJSONDictionary:value];
                value = model;
            }
        }
        if (value) {
            [objc setValue:value forKey:key];
        }
    }];
    
    return objc;
}

/**
 *  json转model （属性名与json字典键名一一对应，不需要映射）
 *
 *  @param jsonDictionary          需要转换的json字典数据
 *  @param modelKeys               数据模型属性名列表
 *  @param keyClassDictionary      数据模型属性名对应的类名
 *  @param keyClassArrayDictionary 数据模型属性名对应的类名（数组）
 *
 *  @return instancetype
 */
+ (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary
                             modelKeys:(NSArray *)modelKeys
                    keyClassDictionary:(NSDictionary *)keyClassDictionary
               keyClassArrayDictionary:(NSDictionary *)keyClassArrayDictionary
{
    //对象
    NSObject<PModelKeyPathMapProtocol> *objc = [[self alloc] init];
    
    [modelKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = jsonDictionary[obj];
        //如果包含组合类对象（数组）
        if (value && [value isKindOfClass:[NSArray class]] && keyClassArrayDictionary) {
            NSString *clazzName = keyClassArrayDictionary[obj];
            if (clazzName) {
                Class clazz = NSClassFromString(clazzName);
                NSArray *modelArray = [clazz arrayWithJSONArray:value];
                value = [modelArray copy];
            }
        } else if (value && [value isKindOfClass:[NSDictionary class]] && keyClassDictionary) {
            //如果包含单个组合类对象
            NSString *clazzName = keyClassDictionary[obj];
            if (clazzName) {
                Class clazz = NSClassFromString(clazzName);
                NSObject<PModelKeyPathMapProtocol> *model = [clazz initWithJSONDictionary:value];
                value = model;
            }
        }
        if (value) {
            [objc setValue:value forKey:obj];
        }
    }];
    
    return objc;
}

/**
 *  json转model
 *
 *  @param jsonDictionary json字典数据
 *
 *  @return instancetype
 */
+ (instancetype)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    
    if (!jsonDictionary) {
        return nil;
    }
    
    //对象属性列表与json数据的键映射
    NSDictionary *mapKeyDictionary = [self pm_modelKeyByJSONKey];
    //获取类的组合类对象的对应键名
    NSDictionary *keyClassDictionary = [[self class] pm_modelKeyClassDictionary];
    //获取类的组合类对象（数组）的对应键名
    NSDictionary *keyClassArrayDictionary = [[self class] pm_arrayKeyClassDictionary];
    
    //如果有映射属性（自定义映射)
    if (mapKeyDictionary) {
        return [self initWithJSONDictionary:jsonDictionary
                           mapKeyDictionary:mapKeyDictionary
                         keyClassDictionary:keyClassDictionary
                    keyClassArrayDictionary:keyClassArrayDictionary];
    } else {
        //如果没有映射属性（即不需要自定义映射，model与json的键名一一对应）
        NSArray *modelKeys = [self pm_propertyNameArray];
        return [self initWithJSONDictionary:jsonDictionary
                           modelKeys:modelKeys
                  keyClassDictionary:keyClassDictionary
             keyClassArrayDictionary:keyClassArrayDictionary];
    }
}

/**
 *  json转model（多对多）
 *
 *  @param jsonArray json字典数据列表
 *
 *  @return NSArray
 */
+ (NSArray *)arrayWithJSONArray:(NSArray *)jsonArray {
    if (!jsonArray || jsonArray.count == 0) {
        return @[];
    }
    
    NSMutableArray *modelArray = [NSMutableArray arrayWithCapacity:jsonArray.count];
    
    //对象属性列表与json数据的键映射
    NSDictionary *mapKeyDictionary = [self pm_modelKeyByJSONKey];
    //获取类的组合类对象的对应键名
    NSDictionary *keyClassDictionary = [[self class] pm_modelKeyClassDictionary];
    //获取类的组合类对象（数组）的对应键名
    NSDictionary *keyClassArrayDictionary = [[self class] pm_arrayKeyClassDictionary];
    
    
    if (mapKeyDictionary) {
        for (NSDictionary *jsonDictionary in jsonArray) {
            NSObject<PModelKeyPathMapProtocol> *objc = [self initWithJSONDictionary:jsonDictionary
                                                                   mapKeyDictionary:mapKeyDictionary
                                                                 keyClassDictionary:keyClassDictionary
                                                            keyClassArrayDictionary:keyClassArrayDictionary];
            [modelArray addObject:objc];
        }
    } else {
        NSArray *modelKeys = [self pm_propertyNameArray];
        for (NSDictionary *jsonDictionary in jsonArray) {
            NSObject<PModelKeyPathMapProtocol> *objc = [self initWithJSONDictionary:jsonDictionary
                                                                          modelKeys:modelKeys
                                                                 keyClassDictionary:keyClassDictionary
                                                            keyClassArrayDictionary:keyClassArrayDictionary];
            [modelArray addObject:objc];
        }
    }
    
    return modelArray;
}

/**
 *  将对象转化为键值对信息
 *
 *  @return 键值对
 */
- (NSDictionary *)pm_toDictionry {
    //获取类的属性列表
    NSArray *modelKeys = [[self class] pm_propertyNameArray];
    
    //获取类的组合类对象的对应键名
    NSDictionary *keyClassDictionary = [[self class] pm_modelKeyClassDictionary];
    //获取类的组合类对象（数组）的对应键名
    NSDictionary *keyClassArrayDictionary = [[self class] pm_arrayKeyClassDictionary];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //逐个属性列表转化成键值对
    [modelKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = [self valueForKey:obj];
        if (!value) {
            value = [NSNull null];
        } else {
            //如果包含组合类对象（数组）
            if (keyClassArrayDictionary && [value isKindOfClass:[NSArray class]]) {
                NSString *clazzName = keyClassArrayDictionary[obj];
                if (clazzName) {
                    //直接强制转换为数组对象
                    NSArray *modelArray = (NSArray *)value;
                    NSMutableArray *modelDictionaryArray = [NSMutableArray arrayWithCapacity:modelArray.count];
                    //将数组对象逐个转化为dictionary
                    for (NSObject<PModelKeyPathMapProtocol> *model in modelArray) {
                        [modelDictionaryArray addObject:[model pm_toDictionry]];
                    }
                    value = [modelDictionaryArray copy];
                }
            } else if (keyClassDictionary) {
                //如果包含单个组合类对象
                NSString *clazzName = keyClassDictionary[obj];
                if (clazzName) {
                    //将对象转化为dictionary
                    NSObject<PModelKeyPathMapProtocol> *model = (NSObject<PModelKeyPathMapProtocol> *)value;
                    NSDictionary *modelDictionary = [model pm_toDictionry];
                    value = [modelDictionary copy];
                }
            }
        }
        
        [dict setObject:value forKey:obj];
    }];
    
    return dict;
}

@end
