//
//  ZCSaveTool.h
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/1.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZCPersons;

@interface ZCSaveTool : NSObject

+ (instancetype)sharedInstance;

- (void)savePersons:(ZCPersons *)persons;

- (NSMutableArray *)loadPersons;

@end
