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

@interface ZCServiceListener ()<GCDAsyncSocketDelegate>
/** 服务器socket */
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
/** 客户端sockets */
@property (nonatomic, strong) NSMutableArray *clientSockets;

@end

@implementation ZCServiceListener

- (NSMutableArray *)clientSockets
{
    if (!_clientSockets) {
        _clientSockets = [NSMutableArray array];
    }
    return _clientSockets;
}

- (void)start
{
    //创建服务器socket，只负责监听请求
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    self.serverSocket = serverSocket;
    
    //开启监听
    NSError *error;
    [serverSocket acceptOnPort:2333 error:&error];
    
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
    
    if ([str containsString:@"\n"]) {
        
        str = [[NSString alloc] initWithData:didReadData encoding:NSUTF8StringEncoding];
        
        str = [str substringWithRange:NSMakeRange(0, str.length - 1)];
        
        NSString *method = [str componentsSeparatedByString:@"_"][0];
        
        if ([method isEqualToString:@"FEA"]) {
            
            NSString *feature = [str substringWithRange:NSMakeRange(method.length + 1, str.length - method.length - 1)];
 
            NSString *ID = [[ZCClassifier sharedInstance] classFeature:feature classifierType:ZCClassifierTypeNearestNeighbor];
            
            if (ID == nil) str = @"特征值匹配失败，请检查上传的特征值！";
            else str = [NSString stringWithFormat:@"库中最接近结果为：%@",ID];
            
        } else if ([method isEqualToString:@"ID"]) {
            
            NSString *feature = [str substringWithRange:NSMakeRange(method.length + 1, str.length - method.length - 1)];
            
            NSString *ID = [feature componentsSeparatedByString:@"_"][0];
            
            feature = [feature substringWithRange:NSMakeRange(ID.length + 1, feature.length - ID.length - 1)];
            
            if ([[ZCClassifier sharedInstance] featureIsCorrectFormat:feature]) {
                
                ZCPersons *persons = [ZCPersons sharedInstance];
                
                [persons addFeature:feature personID:ID];
                
                [persons saveData];
                
                str = @"特征上传成功！";
            } else {
                str = @"特征格式不正确！";
            }
        }
        else {
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

@end
