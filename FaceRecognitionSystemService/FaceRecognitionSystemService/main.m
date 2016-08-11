//
//  main.m
//  FaceRecognitionSystemService
//
//  Created by 张晨 on 2016/8/11.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCServiceListener.h"
#import "ZCPersons.h"
#import "ZCFeatureExtractionTool.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //创建监听者
        ZCServiceListener *listener = [[ZCServiceListener alloc] init];
        //开启监听
        [listener start];
        
        //若需要训练图像，输入训练图像所在文件夹，并按要求命名图像：ID-序号.扩展名 eg:张三-01.png
        //        [[ZCFeatureExtractionTool sharedInstance] trainImageUseMethod:ZCFeatureExtractMethodLBP floder:@"/Users/zhangchen/Desktop/train"];
        
        //开启运行循环
        [[NSRunLoop mainRunLoop] run];
        
    }
    return 0;
}
