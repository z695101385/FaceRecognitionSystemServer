//
//  ZCPerson.m
//  ZCServer
//
//  Created by 张晨 on 2016/8/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCPerson.h"

@implementation ZCPerson

- (NSMutableArray *)LBP
{
    if (!_LBP) {
        _LBP = [NSMutableArray array];
    }
    return _LBP;
}

- (NSMutableArray *)MLBP
{
    if (!_MLBP) {
        _MLBP = [NSMutableArray array];
    }
    return _MLBP;
}

- (instancetype)initWithID:(NSString *)ID LBP:(NSMutableArray *)LBP MLBP:(NSMutableArray *)MLBP
{
    self.ID = ID;
    
    _LBP = LBP;
    _MLBP = MLBP;
    
    return self;
}

- (void)addLBP:(NSString *)LBP
{
    [self.LBP addObject:LBP];
}

- (void)addMLBP:(NSString *)MLBP
{
    [self.MLBP addObject:MLBP];
}

- (void)addFeature:(NSString *)feature
{
    NSString *method = [feature componentsSeparatedByString:@"_"][0];
    
    if (![method isEqualToString:@"FEA"]) return;
    
    feature = [feature substringWithRange:NSMakeRange(method.length + 1, feature.length - method.length - 1)];
    
    method = [feature componentsSeparatedByString:@"_"][0];
    
    feature = [feature substringWithRange:NSMakeRange(method.length + 1, feature.length - method.length - 1)];
    
    NSMutableArray *feaArr = [self performSelector:NSSelectorFromString(method) withObject:nil];

    for (NSString *fea in feaArr) {
        if ([fea isEqualToString:feature]) return;
    }
    
    method = [NSString stringWithFormat:@"add%@:",method];
    
//    NSLog(@"%@",feature);
    
    [self performSelector:NSSelectorFromString(method) withObject:feature];
}
@end
