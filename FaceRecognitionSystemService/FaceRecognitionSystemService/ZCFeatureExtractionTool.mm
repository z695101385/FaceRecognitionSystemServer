//
//  ZCFeatureExtractionTool.m
//  FaceRecognitionSystem
//
//  Created by 张晨 on 16/6/24.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCFeatureExtractionTool.h"
#import "opencv2/opencv.hpp"
#import <CoreGraphics/CoreGraphics.h>
#import "ZCPersons.h"

@interface ZCFeatureExtractionTool ()

/** faceImage */
@property (nonatomic,strong) NSString *imagePath;

@property(nonatomic) IplImage *IplImage;

@end

@implementation ZCFeatureExtractionTool

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

- (void)trainImageUseMethod:(ZCFeatureExtractMethod)method floder:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *allPath =[manager subpathsAtPath:path];
    
    NSString *imagePath;
    
    ZCPersons *persons = [ZCPersons sharedInstance];
    
    for (NSString *filePath in allPath) {
        
        if ([[filePath pathExtension] isEqualToString:@"png"] || [[filePath pathExtension] isEqualToString:@"bmp"] || [[filePath pathExtension] isEqualToString:@"jepg"] || [[filePath pathExtension] isEqualToString:@"jpg"])
        {
            imagePath = [path stringByAppendingPathComponent:filePath];
            
            NSString *feature = [self featureExtractUseMethod:method imagePath:imagePath];
            
            NSString *ID = [[filePath lastPathComponent] componentsSeparatedByString:@"-"][0];

            NSLog(@"%@",ID);
            
            [persons addFeature:feature personID:ID];
        }
    }
    
    [persons saveData];
}

- (NSString *)featureExtractUseMethod:(ZCFeatureExtractMethod)method imagePath:(NSString *)imagePath
{
    self.imagePath = imagePath;
    
    if (_IplImage) {
        
        NSString *fea = nil;
        
        switch (method) {
            case 0:
                fea = [self LBP];
                break;
            case 1:
                fea = [self MLBP];
                break;
        }
        
        return fea;
    }
    
    return nil;
}

-(void)setImagePath:(NSString *)imagePath
{
    IplImage *iplimage = cvLoadImage([imagePath UTF8String]);
    
    IplImage *grayImg = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 1); //先转为灰度图
    
    cvCvtColor(iplimage, grayImg, CV_BGRA2GRAY);
    
    _IplImage = cvCreateImage(cvSize(64,64), IPL_DEPTH_8U, 1);
    
    cvResize(grayImg, _IplImage);
    
    cvReleaseImage(&grayImg);
    cvReleaseImage(&iplimage);
    
}

- (void)dealloc
{
    cvReleaseImage(&_IplImage);
}

- (NSString *)LBP
{
    NSMutableString *fea = [NSMutableString stringWithString:@"FEA_LBP"];
    
    
    for(int j = 1; j < _IplImage->width - 1; j++)
    {
        for(int i = 1; i < _IplImage->height - 1; i++)
        {
            uchar neighborhood[8] = {0};
            neighborhood[7] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j-1);
            neighborhood[6] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j);
            neighborhood[5] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j+1);
            neighborhood[4] = CV_IMAGE_ELEM(_IplImage, uchar, i, j-1);
            neighborhood[3] = CV_IMAGE_ELEM(_IplImage, uchar, i, j+1);
            neighborhood[2] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j-1);
            neighborhood[1] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j);
            neighborhood[0] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j+1);
            uchar center = CV_IMAGE_ELEM( _IplImage, uchar, i, j);
            uchar temp=0;
            
            for(int k=0;k<8;k++)
            {
                temp += (neighborhood[k] >= center)<<k;
            }
            
            [fea appendFormat:@"_%d",temp];
        }
    }
    
    return [fea copy];
}

- (NSString *)MLBP
{
    NSMutableString *fea = [NSMutableString stringWithString:@"FEA_MLBP"];
    
    
    for(int j = 1; j < _IplImage->width - 1; j++)
    {
        for(int i = 1; i < _IplImage->height - 1; i++)
        {
            uchar neighborhood[8] = {0};
            neighborhood[7] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j-1);
            neighborhood[6] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j);
            neighborhood[5] = CV_IMAGE_ELEM(_IplImage, uchar, i-1, j+1);
            neighborhood[4] = CV_IMAGE_ELEM(_IplImage, uchar, i, j-1);
            neighborhood[3] = CV_IMAGE_ELEM(_IplImage, uchar, i, j+1);
            neighborhood[2] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j-1);
            neighborhood[1] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j);
            neighborhood[0] = CV_IMAGE_ELEM(_IplImage, uchar, i+1, j+1);
            uchar center = CV_IMAGE_ELEM( _IplImage, uchar, i, j);
            uchar temp=0;
            
            for(int k=0;k<8;k++)
            {
                temp += (neighborhood[k] >= center)<<k;
            }
            
            [fea appendFormat:@"_%d",temp];
        }
    }
    
    return [fea copy];
}

void LBP(IplImage* src, IplImage* dst)
{
    int width=src->width;
    int height=src->height;
    for(int j=1;j<width-1;j++)
    {
        for(int i=1;i<height-1;i++)
        {
            uchar neighborhood[8]={0};
            neighborhood[7] = CV_IMAGE_ELEM( src, uchar, i-1, j-1);
            neighborhood[6] = CV_IMAGE_ELEM( src, uchar, i-1, j);
            neighborhood[5] = CV_IMAGE_ELEM( src, uchar, i-1, j+1);
            neighborhood[4] = CV_IMAGE_ELEM( src, uchar, i, j-1);
            neighborhood[3] = CV_IMAGE_ELEM( src, uchar, i, j+1);
            neighborhood[2] = CV_IMAGE_ELEM( src, uchar, i+1, j-1);
            neighborhood[1] = CV_IMAGE_ELEM( src, uchar, i+1, j);
            neighborhood[0] = CV_IMAGE_ELEM( src, uchar, i+1, j+1);
            uchar center = CV_IMAGE_ELEM( src, uchar, i, j);
            uchar temp=0;
            
            for(int k=0;k<8;k++)
            {
                temp+=(neighborhood[k]>=center)<<k;
            }
            CV_IMAGE_ELEM( dst, uchar, i, j)=temp;
        }
    }  
}

@end
