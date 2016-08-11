//
//  ZCPersons.h
//  ZCServer
//
//  Created by 张晨 on 2016/8/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCPerson.h"

@interface ZCPersons : NSObject

/** 数据库 */
@property (nonatomic, strong) NSMutableArray *persons;

+ (instancetype)sharedInstance;

- (ZCPerson *)personWithID:(NSString *)ID;

- (void)addFeature:(NSString *)feature personID:(NSString *)ID;

- (void)saveData;

@end
