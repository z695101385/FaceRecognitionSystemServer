//
//  ZCPerson.h
//  ZCServer
//
//  Created by 张晨 on 2016/8/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCPerson : NSObject

/** ID */
@property (nonatomic, strong) NSString *ID;

/** LBP */
@property (nonatomic, strong) NSMutableArray *LBP;

/** MLBP */
@property (nonatomic, strong) NSMutableArray *MLBP;

- (instancetype)initWithID:(NSString *)ID LBP:(NSMutableArray *)LBP MLBP:(NSMutableArray *)MLBP;

- (void)addLBP:(NSString *)LBP;

- (void)addMLBP:(NSString *)MLBP;

- (void)addFeature:(NSString *)feature;
@end
