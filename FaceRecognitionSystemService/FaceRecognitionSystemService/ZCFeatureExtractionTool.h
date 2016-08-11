//
//  ZCFeatureExtractionTool.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/24.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ZCFeatureExtractMethodLBP  = 0,
    ZCFeatureExtractMethodMLBP = 1,
} ZCFeatureExtractMethod;

@interface ZCFeatureExtractionTool : NSObject


+ (instancetype)sharedInstance;

- (void)trainImageUseMethod:(ZCFeatureExtractMethod)method floder:(NSString *)path;

- (NSString *)featureExtractUseMethod:(ZCFeatureExtractMethod)method imagePath:(NSString *)imagePath;;

@end
