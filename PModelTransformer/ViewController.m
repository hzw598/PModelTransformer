//
//  ViewController.m
//  PModelTransformer
//
//  Created by 周爱林 on 2016/11/8.
//  Copyright © 2016年 dg11185. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "PModelTransformer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *jsonDictionary = @{@"id":@1, @"name":@"Allen", @"age":@18, @"schools":@[@{@"id":@1, @"name":@"ccnu", @"city":@"wuhan"},@{@"id":@2, @"name":@"csnu", @"city":@"guangzhou"}]};
    
    User *user = [User initWithJSONDictionary:jsonDictionary];
    NSLog(@"user = %@", [user pm_toDictionry]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
