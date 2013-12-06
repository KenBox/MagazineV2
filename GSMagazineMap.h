//
//  GSMagazineMap.h
//  GSMagazinePublish
//
//  Created by 蒋 宇 on 12-12-25.
//  Copyright (c) 2012年 zheng jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
@interface GSMagazineMap : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    ASINetworkQueue *queue;
    BOOL forceClose;
}

//杂志导航MAP
@property (strong, nonatomic) NSMutableArray *map;
//杂志html路径
@property (strong, nonatomic) NSMutableArray *localHtmlArray;

//用于识别相对目录的上级目录
@property (strong, nonatomic) NSString *suffixPath;
//期刊目录
@property (strong, nonatomic) NSString *magazineNumber;
//本地html路径的数组
@property (strong, nonatomic) NSMutableArray *htmlPathArray;
+(GSMagazineMap *) sharedInstance;
- (void)getMapFromXmlSourece:(NSURL *)xmlUrl getXmlNumber:(NSString *)xmlNumber;
- (NSString *)getMagazineNumber:(NSString *)topicPath;
- (NSString *)getTopicDownloadURL:(NSString *)contentPath;
//下载zip包
- (void) downloadZipSource:(NSString *)number;
//下载取消
- (void)cancelDownloadAllQueues;

@end
