//
//  ZCClassifier.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 2016/8/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
// 分类器类型
typedef enum : NSUInteger {
    ZCClassifierTypeNearestNeighbor = 0,
} ZCClassifierType;

@interface ZCClassifier : NSObject
//单例模式（返回单例对象）
+ (instancetype)sharedInstance;

/**
 分类特征

 @param feature 特征
 @param classifierType 分类方法
 @return 分类结果
 */
- (NSString *)classFeature:(NSString *)feature classifierType:(ZCClassifierType)classifierType;

/**
 判断特征格式是否符合标准

 @param feature 特征（字符串格式）
 @return YES 符合 NO 不符合
 */
- (BOOL)featureIsCorrectFormat:(NSString *)feature;

@end
