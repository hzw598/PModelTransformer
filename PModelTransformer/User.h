//
//  User.h
//  IPModelTransformer
//
//  Created by 周爱林 on 2016/11/8.
//  Copyright © 2016年 dg11185. All rights reserved.
//

#import <Foundation/Foundation.h>

@class School;

@interface User : NSObject

@property (nonatomic) NSInteger ids;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger age;
@property (nonatomic, copy) NSArray *schools;

@end
