//
//  ZCClassifier.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 2016/8/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ZCClassifierTypeNearestNeighbor = 0,
} ZCClassifierType;

@interface ZCClassifier : NSObject

+ (instancetype)sharedInstance;

- (NSString *)classFeature:(NSString *)feature classifierType:(ZCClassifierType)classifierType;

- (BOOL)featureIsCorrectFormat:(NSString *)feature;

@end
