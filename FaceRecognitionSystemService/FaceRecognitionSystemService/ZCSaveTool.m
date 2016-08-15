//
//  ZCSaveTool.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/1.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCSaveTool.h"
#import "ZCPerson.h"
#import "ZCPersons.h"
#import "ZCConst.h"

@implementation ZCSaveTool

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

- (void)savePersons:(ZCPersons *)persons
{
    NSMutableArray *dataArr = [NSMutableArray array];
    
    for (ZCPerson *person in persons.persons) {
        NSDictionary *dict = @{@"ID":person.ID,
                               @"LBP":person.LBP,
                               @"MLBP":person.MLBP};
        
        [dataArr addObject:dict];
    }
    
    [dataArr writeToFile:ZCDataPath atomically:YES];
}

- (NSMutableArray *)loadPersons
{
    NSMutableArray *persons = [NSMutableArray array];
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:ZCDataPath];
    
    for (NSDictionary *dict in arr) {
        
        NSMutableArray *LBP = nil;
        NSMutableArray *MLBP = nil;
        
        if (dict[@"LBP"]) {
            LBP = [NSMutableArray arrayWithArray:dict[@"LBP"]];
        }
        
        if (dict[@"MLBP"]) {
            MLBP = [NSMutableArray arrayWithArray:dict[@"MLBP"]];
        }
        
        ZCPerson *person = [[ZCPerson alloc] initWithID:dict[@"ID"] LBP:LBP MLBP:MLBP];
        
        [persons addObject:person];
    }
    return persons;
}



@end
