//
//  ZCServiceListener.m
//  ZCServer
//
//  Created by 张晨 on 2016/8/10.
//  Copyright © 2016年 zhangchen. All rights reserved.
//

#import "ZCServiceListener.h"
#import "GCDAsyncSocket.h"
#import "ZCClassifier.h"
#import "ZCPersons.h"
#import "ZCConst.h"

@interface ZCServiceListener ()<GCDAsyncSocketDelegate>
/** 服务器socket */
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
/** 客户端sockets */
@property (nonatomic, strong) NSMutableArray *clientSockets;
/** map */
@property (nonatomic, strong) NSDictionary *map;

@end

@implementation ZCServiceListener

- (NSMutableArray *)clientSockets
{
    if (!_clientSockets) {
        _clientSockets = [NSMutableArray array];
    }
    return _clientSockets;
}

- (NSDictionary *)map
{
    if (!_map) {
        _map = [NSDictionary dictionaryWithContentsOfFile:ZCMapPath];
    }
    return _map;
}

- (void)start
{
    //创建服务器socket，只负责监听请求
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    self.serverSocket = serverSocket;
    
    //开启监听
    NSError *error;
    [serverSocket acceptOnPort:port error:&error];
    
}

- (void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket
{
    //将收到的客户端socket保存下来
    [self.clientSockets addObject:clientSocket];
    
//    NSString *str = @"服务器连接成功...\n";
    
//    [clientSocket writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:0];
    
    [clientSocket readDataWithTimeout:30 tag:0];
    
    
    
}

- (void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag
{
    if (!clientSocket.userData) {
        clientSocket.userData = [NSMutableData data];
    }
    
    NSMutableData *didReadData = clientSocket.userData;
    
    [didReadData appendData:data];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([str containsString:@"\r\n"]) {
        
        str = [[NSString alloc] initWithData:didReadData encoding:NSUTF8StringEncoding];
        
        str = [str substringWithRange:NSMakeRange(0, str.length - 2)];
        
        NSString *method = [str componentsSeparatedByString:@"_"][0];
        
        NSString *map = self.map[method];
        
        if (map)
        {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            str = [self performSelector:NSSelectorFromString(map) withObject:str];
            #pragma clang diagnostic pop
            
        } else {
            str = @"指令无法解析";
        }
        
        [clientSocket writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:30 tag:0];
        
        clientSocket.userData = nil;
        
        [clientSocket disconnect];
    }
    
    [clientSocket readDataWithTimeout:30 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [self.clientSockets removeObject:sock];
}

- (NSString *)addFeature:(NSString *)str
{
    NSInteger length = str.length;
    
    if (length < 3) return @"特征格式不正确！";
    
    NSString *feature = [str substringWithRange:NSMakeRange(3, str.length - 3)];
    
    NSString *ID = [feature componentsSeparatedByString:@"_"][0];
    
    length = feature.length - ID.length - 1;
    
    if (length <= 0) return @"特征格式不正确！";
    
    feature = [feature substringWithRange:NSMakeRange(ID.length + 1, length)];
    
    if ([[ZCClassifier sharedInstance] featureIsCorrectFormat:feature]) {
        
        ZCPersons *persons = [ZCPersons sharedInstance];
        
        [persons addFeature:feature personID:ID];
        
        [persons saveData];
        
        return @"特征上传成功！";
        
    } else {
        
        return @"特征格式不正确！";
    }
}

- (NSString *)classFeature:(NSString *)str
{
    if ([[ZCClassifier sharedInstance] featureIsCorrectFormat:str]) {
        
        NSInteger length = str.length;
        
        if (length < 4) return @"特征格式不正确！";
        
        NSString *feature = [str substringWithRange:NSMakeRange(4, str.length - 4)];
        //在这里修改分类方法
        NSString *ID = [[ZCClassifier sharedInstance] classFeature:feature classifierType:ZCClassifierTypeNearestNeighbor];
        
        if (ID == nil) return @"特征值匹配失败，请检查上传的特征值！";
        else return [NSString stringWithFormat:@"库中最接近结果为：%@",ID];
        
    } else {
        
        return @"特征格式不正确！";
    }
}

@end
