//
//  ZCPersons.m
//  ZCServer
//
//  Created by 张晨 on 2016/8/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCPersons.h"
#import "ZCSaveTool.h"

@implementation ZCPersons

static id _instace;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}


- (void)saveData
{
    [[ZCSaveTool sharedInstance] savePersons:self];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.persons = [[ZCSaveTool sharedInstance] loadPersons];
    }
    return self;
}

- (ZCPerson *)personWithID:(NSString *)ID
{

    for (ZCPerson *person in self.persons) {
        if ([ID isEqualToString:person.ID]) {
            return person;
        }
    }
    
    ZCPerson *person = [[ZCPerson alloc] initWithID:ID LBP:nil MLBP:nil];
    
    [self.persons addObject:person];
    
    return person;
}

- (void)addFeature:(NSString *)feature personID:(NSString *)ID
{
    ZCPerson *person = [self personWithID:ID];
    
    [person addFeature:feature];
}

@end
