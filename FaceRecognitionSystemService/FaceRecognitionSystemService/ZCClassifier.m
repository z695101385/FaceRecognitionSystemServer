//
//  ZCClassifier.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 2016/8/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCClassifier.h"
#import "ZCPersons.h"
#import "ZCPerson.h"

@implementation ZCClassifier

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

- (NSString *)classFeature:(NSString *)feature classifierType:(ZCClassifierType)classifierType
{
    NSString *name = nil;
    switch (classifierType) {
        case 0:
            name = [self useNearestNeighborClassifier:feature];
            break;
        
    }
    return name;
}

- (NSString *)useNearestNeighborClassifier:(NSString *)feature
{
    ZCPersons *persons = [ZCPersons sharedInstance];
    
    NSMutableArray *personsArr = persons.persons;
    
    NSString *method = [feature componentsSeparatedByString:@"_"][0];
    
    feature = [feature substringWithRange:NSMakeRange(method.length + 1, feature.length - method.length - 1)];
    
    CGFloat E = MAXFLOAT;
    NSString *ID = nil;
    
    for (ZCPerson *p in personsArr) {
        
        NSMutableArray *feaArr = [p performSelector:NSSelectorFromString(method) withObject:nil];
        
        if (!feaArr.count) continue;
        
        for (NSString *fea in feaArr) {
            
            CGFloat cE = [self feature:fea compareFeature:feature];
            
            if (E == -1) return nil;
            
            if (cE < E) {
                E = cE;
                ID = p.ID;
            }
        }
    }
    
    return ID;
}

- (CGFloat)feature:(NSString *)fea0 compareFeature:(NSString *)fea1
{
    NSMutableArray *fea0Arr = [self numberFeatureFromString:fea0];
    NSMutableArray *fea1Arr = [self numberFeatureFromString:fea1];
    
    if (fea0Arr.count != fea1Arr.count) return -1;
    
    CGFloat E = 0;
    
    for (NSInteger i = 0; i < fea0Arr.count; i++) {
        E += ABS([fea0Arr[i] floatValue] - [fea1Arr[i] floatValue]);
    }
    
    return E;
}

- (NSMutableArray *)numberFeatureFromString:(NSString *)feature
{
    NSArray *arr = [feature componentsSeparatedByString:@"_"];
    
    if (!arr.count) return nil;
    
    NSMutableArray *feaArr = [NSMutableArray array];
    
    for (NSString *f in arr) {
        [feaArr addObject:[NSNumber numberWithFloat:[f floatValue]]];
    }
    
    return feaArr;
}

- (BOOL)featureIsCorrectFormat:(NSString *)feature
{
    NSString *method = [feature componentsSeparatedByString:@"_"][0];
    
    if (![method isEqualToString:@"FEA"]) return NO;
    
    NSString *fea = [feature substringWithRange:NSMakeRange(method.length + 1, feature.length - method.length - 1)];
    
    method = [fea componentsSeparatedByString:@"_"][0];
    
    if ([method isEqualToString:@"LBP"] || [method isEqualToString:@"MLBP"]) return YES;
    
    return NO;
}
@end
