//
//  PeriodicalData.m
//  Magazine_V2
//
//  Created by Ken on 13-12-4.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "PeriodicalData.h"
#import "ASIHTTPRequest.h"
#import "GSAlert.h"
#import "MeiJiaHeader.h"
#import "ASIDownloadCache.h"

@implementation PeriodicalData
@synthesize Year,Month,Periodical,Title,LabelTitle,Ppath,FrontCoverName,FrontCoverURL,TopicXMLURL,ResourcePath,FolderName,PeriodicalTag;


/**
 *  description: 判断图片本地路径是否存在，不存在则下载图片
 *  @param 参数一: 图片在服务器上的URL
 *  @paran 参数二: 图片存在Documents文件夹中的路径
 */
-(void)downloadFileFrom:(NSString *)URL intoPath:(NSString * )path{

    
    NSURL * url = [NSURL URLWithString:URL];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
//    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [request setDownloadDestinationPath:path];
//    [request setCachePolicy:ASIUseDefaultCachePolicy];
    //支持断点续传
    [request setAllowResumeForFileDownloads:YES];
    request.delegate = self;
    request.timeOutSeconds = 60;

    NSLog(@"文件下载中...");
    [request startSynchronous];
    int statusCode = [request responseStatusCode];
    NSString *statusMessage = [request responseStatusMessage];
    NSLog(@"statusMessage = %@",statusMessage);
    NSLog(@"statusCode = %d",statusCode);
    switch (statusCode) {
        case 200:
            NSLog(@"文件下载成功");
            break;
        case 404:
            NSLog(@"服务器没有找到你指定的路径");
            [GSAlert showAlertWithTitle:@"文件下载失败"];
            break;
        case 500:
            NSLog(@"服务器端出错");
            [GSAlert showAlertWithTitle:@"文件下载失败"];
            break;
        default:
            break;
    }
}


-(void)downloadImageFrom:(NSString *)URLString intoPath:(NSString *)path ByCreatFolder:(NSString *)_FolderName{
    //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //并给文件起个文件名
//    NSString *DownloadDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:FolderName];
    NSString * DownloadDir = [NSString stringWithFormat:@"%@/%@",kCachesFolderPath,_FolderName];
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:DownloadDir withIntermediateDirectories:YES attributes:nil error:nil];
    [self downloadFileFrom:URLString intoPath:path];
    
}


@end
