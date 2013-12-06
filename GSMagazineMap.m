//
//  GSMagazineMap.m
//  GSMagazinePublish
//
//  Created by 蒋 宇 on 12-12-25.
//  Copyright (c) 2012年 zheng jie. All rights reserved.
//

#import "GSMagazineMap.h"
#import "GDataXMLNode.h"

#import "GSPageInfo.h"
#import "MeiJiaHeader.h"
#import "FileOperation.h"
#import "ZipArchive.h"


@implementation GSMagazineMap
@synthesize map;
@synthesize suffixPath;
@synthesize magazineNumber;
@synthesize htmlPathArray;

+(GSMagazineMap *) sharedInstance {
    static dispatch_once_t pred;
    static GSMagazineMap *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[GSMagazineMap alloc] init];
    });
    
    return shared;
}


-(void) getMapFromXmlSourece:(NSURL *) xmlUrl getXmlNumber:(NSString *)xmlNumber{
    NSData *xmlData = nil;
    xmlData = [NSData dataWithContentsOfURL:xmlUrl];
    if (self.map != nil) {
        [self.map removeAllObjects];
    }
    if (self.localHtmlArray != nil) {
        [self.localHtmlArray removeAllObjects];
    }
    self.map = [[NSMutableArray alloc] init];
    self.localHtmlArray = [[NSMutableArray alloc] init];
    //获取每期的期刊号
    self.magazineNumber = xmlNumber;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    GDataXMLElement *rootElement = [doc rootElement];
    
    NSArray * contents = [rootElement elementsForName:@"contents"];
    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GDataXMLElement *content = obj;

        //封面
        NSArray *coverpages = [content elementsForName:@"CoverPage"];
        [coverpages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GDataXMLElement *coverPage = obj;
            GSPageInfo *per = [[GSPageInfo alloc] init];
            per.page_pageName = [[coverPage attributeForName:@"PageName"] stringValue];
            per.page_thumbName = [[coverPage attributeForName:@"ThumbName"] stringValue];
            per.page_pagePath = [[[[coverPage attributeForName:@"CoverPath"] stringValue] stringByReplacingOccurrencesOfString:@"\\\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            
            NSMutableArray *coverArray = [[NSMutableArray alloc] init];
            [coverArray addObject:per];
            
            NSString *coverPath = [self getLocalPathURL:per.page_pagePath];
            NSMutableArray *coverPathArray = [[NSMutableArray alloc] init];
            [coverPathArray addObject:coverPath];
            //封面下的页
            NSArray *coverSubPages = [coverPage elementsForName:@"Page"];
            [coverSubPages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GDataXMLElement *coverSubPage = obj;
                GSPageInfo *subPer = [[GSPageInfo alloc] init];
                subPer.page_pageName = [[coverSubPage attributeForName:@"PageName"] stringValue];
                subPer.page_pagePath = [[[[coverSubPage attributeForName:@"PagePath"] stringValue] stringByReplacingOccurrencesOfString:@"\\\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                [coverArray addObject:subPer];
                
                NSString *coverSubPath = [self getLocalPathURL:subPer.page_pagePath];
                [coverPathArray addObject:coverSubPath];
            }];
            [self.map addObject:coverArray];

            [self.localHtmlArray addObject:coverPathArray];
        }];
        //目录
        NSArray *catalogs = [content elementsForName:@"Catalog"];
        [catalogs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GDataXMLElement *catalog = obj;
            GSPageInfo *catalogPage = [[GSPageInfo alloc] init];
            catalogPage.page_pageName = [[catalog attributeForName:@"PageName"] stringValue];
            catalogPage.page_thumbName = [[catalog attributeForName:@"ThumbName"] stringValue];
            catalogPage.page_pagePath = [[[[catalog attributeForName:@"CataPath"] stringValue] stringByReplacingOccurrencesOfString:@"\\\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            NSMutableArray *catalogArray = [[NSMutableArray alloc] init];
            [catalogArray addObject:catalogPage];
            //目录本地路径
            NSString *catalogPath = [self getLocalPathURL:catalogPage.page_pagePath];
            NSMutableArray *catalogPathArray = [[NSMutableArray alloc] init];
            [catalogPathArray addObject:catalogPath];
            
            NSArray *catalogSubPages = [catalog elementsForName:@"Page"];
            [catalogSubPages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GSPageInfo *catalogSubPage = [[GSPageInfo alloc] init];
                catalogSubPage.page_pageName = [[catalog attributeForName:@"PageName"] stringValue];
                catalogSubPage.page_pagePath = [[[[catalog attributeForName:@"PagePath"] stringValue] stringByReplacingOccurrencesOfString:@"\\\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                [catalogArray addObject:catalogSubPage];
                //Caches//201101_201101(magazine_number)/frontcover/frontcover.html
                NSString *catalogSubPath = [self getLocalPathURL:catalogSubPage.page_pagePath];
                [catalogPathArray addObject:catalogSubPath];
            }];
            [self.map addObject:catalogArray];
            [self.localHtmlArray addObject:catalogPathArray];
        }];
         
         
        //Topic
        NSArray *topics = [content elementsForName:@"Topic"];
        [topics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GDataXMLElement *topic = obj;
            GSPageInfo *pageInfo = [[GSPageInfo alloc] init];
            pageInfo.page_pageName = [[topic attributeForName:@"TopicName"] stringValue];
            pageInfo.page_thumbName = [[topic attributeForName:@"ThumbName"] stringValue];
            NSLog(@"page_thumbName is %@",pageInfo.page_thumbName);
            NSString *pathTrans = [[[topic attributeForName:@"TopicPath"] stringValue] stringByReplacingOccurrencesOfString:@"\\\\" withString:@"/"];
            pageInfo.page_pagePath = [pathTrans stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            pageInfo.page_topicIntro = [[topic attributeForName:@"Intro"] stringValue];
            
            //topic array 主题第一页
            NSMutableArray *topicArray = [[NSMutableArray alloc] init];
            [topicArray addObject:pageInfo];
            
            //topic path array 保存每页的本地html地址
            NSString *topicPath = [self getLocalPathURL:pageInfo.page_pagePath];
            NSMutableArray *topicPathArray = [[NSMutableArray alloc] init];
            [topicPathArray addObject:topicPath];
            
            NSArray *pages = [topic elementsForName:@"Page"];
            [pages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                GDataXMLElement *page = obj;
                //主题下的分页
                GSPageInfo *topicPage = [[GSPageInfo alloc] init];
                topicPage.page_pageName = [[page attributeForName:@"PageName"] stringValue];
                topicPage.page_pagePath = [[[[page attributeForName:@"PagePath"] stringValue] stringByReplacingOccurrencesOfString:@"\\\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                [topicArray addObject:topicPage];
                
                NSString *topicPagePath = [self getLocalPathURL:topicPage.page_pagePath];
                [topicPathArray addObject:topicPagePath];
            }];
            [self.map addObject:topicArray];
            [self.localHtmlArray addObject:topicPathArray];
            NSLog(@"map is %@,localhtmlarray is %@",self.map,self.localHtmlArray);
        }];
    }];
    NSLog(@"map:%@  count is %d",self.map,[self.map count]);
}
//获取下载路径 zip包URL,以后方法独立 适合各对象调用
- (NSString *)getTopicDownloadURL:(NSString *)contentPath
{
    //预处理path url  2011/201101/201101_201101  25个
    //根据某期的xml文件名获取index
    //NSLog(@"magazinenumber is %@",self.magazineNumber);
    NSInteger index = [contentPath rangeOfString:self.magazineNumber].location;
    NSInteger length = [contentPath rangeOfString:self.magazineNumber].length;
    NSString *contentStr = [[NSString alloc] init];
    contentStr = [contentPath substringToIndex:index + length];
    return [NSString stringWithFormat:@"%@/%@",kResouceDownloadURL,contentStr];
}
//获取本地解压后的路径 caches/201201_1\201201_1_1\201201_1_1.html  （以后方法独立 适合各对象调用）
- (NSString *)getLocalPathURL:(NSString *)pathURL
{
    NSInteger index = [pathURL rangeOfString:self.magazineNumber].location;
    NSString *contentStr = [[NSString alloc] init];
    contentStr = [pathURL substringFromIndex:index];
    return [kCachesFolderPath stringByAppendingPathComponent:contentStr];
}
//设置每期的期刊号 （以后方法独立 适合各对象调用）
- (NSString *) getMagazineNumber:(NSString *)topicPath
{
    return [[[topicPath lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
}
//下载zip包 以后利用cachepolicy
- (void) downloadZipSource:(NSString *)number
{
    forceClose = NO;
    //初始化队列
    queue = [[ASINetworkQueue alloc] init];
    //支持高精度的进度追踪 暂时使用默认简单进度
    //[queue setShowAccurateProgress:YES];
    //启动
    [queue setMaxConcurrentOperationCount:5];
    //取消队列中下载失败就取消其他所有请求的情况。
    [queue setShouldCancelAllRequestsOnFailure:NO];
    //[queue go];
    //保存magazineNumber
    self.magazineNumber = number;
    //下载路径 Cahces/magazineNumber/page_path.zip
    for (NSInteger i=0; i < [self.map count]; i++) {
        NSArray *pageArray = [self.map objectAtIndex:i];
        //topic下的页数 包括cover和catalog
        for (NSInteger j = 0; j < [pageArray count]; j ++ ) {
            GSPageInfo *topicPage = [pageArray objectAtIndex:j];
            //根据 topicPage.page_pagePath 获取path路径 下载
            NSString *zipName = [[NSString alloc] init];
            zipName = [[topicPage.page_pagePath lastPathComponent] stringByReplacingOccurrencesOfString:@".html" withString:@".zip"];
            if (i == 0) {
                zipName = @"frontcover.zip";
            }
            NSLog(@"zipName is %@",zipName);
            //下载路径 .zip
            NSString *downloadURL = [NSString stringWithFormat:@"%@/%@",[self getTopicDownloadURL:topicPage.page_pagePath],zipName];
            NSLog(@"download zip url is :%@",downloadURL);
            
            //本地缓存路径 Caches/magazineNumber/tmpFolder/name.tmp
            [FileOperation createDirectoryAtPath:[[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:@"tmpFolder"]];
            NSString *tmpName = [[NSString alloc] init];
            tmpName = [zipName stringByReplacingOccurrencesOfString:@".zip" withString:@".tmp"];
            NSString *tmpURL = [[[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:@"tmpFolder"] stringByAppendingPathComponent:tmpName];
            //解压后的文件名
            NSString *unZipFolderName = [zipName stringByReplacingOccurrencesOfString:@".zip" withString:@""];
            //不存在解压后的文件名
            if (![FileOperation fileExistsAtPath:[[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:unZipFolderName]]) {
                NSLog(@"已存在zip文件");
                //创建网络请求;
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:downloadURL]];
                request.delegate = self;
                request.timeOutSeconds = 60;
                //下载到本地路径 Caches/magazineNumber/name.zip
                NSString *localURL = [[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:zipName];
                [request setDownloadDestinationPath:localURL];
                //设置本地缓存路径 Caches/magazineNumber/tmpFolder/name.tmp
                [request setTemporaryFileDownloadPath:tmpURL];
                //支持断点续传
                [request setAllowResumeForFileDownloads:YES];
                //下载进度 以后优化
                request.downloadProgressDelegate = self;
                request.userInfo = @{zipName : topicPage};
                [queue addOperation:request];
                [queue go];
            }
            //创建网络请求;
//            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:downloadURL]];
//            request.delegate = self;
//            //下载到本地路径 Caches/magazineNumber/name.zip
//            NSString *localURL = [[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:zipName];
//            [request setDownloadDestinationPath:localURL];
//            //设置本地缓存路径 Caches/magazineNumber/tmpFolder/name.tmp
//            [request setTemporaryFileDownloadPath:tmpURL];
//            //支持断点续传
//            [request setAllowResumeForFileDownloads:YES];
//            //下载进度 以后优化
//            request.downloadProgressDelegate = self;
//            request.userInfo = @{zipName : topicPage};
//            [queue addOperation:request];
        }
    }
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"complete!");
    NSLog(@"userInfo:%@, keys:%@",request.userInfo,[request.userInfo allKeys]);
    NSString *zipName = [[request.userInfo allKeys] objectAtIndex:0];
    //下载完成 解压zip
    //如果目标文件夹中存在zip文件就解压
    if ([FileOperation fileExistsAtPath:[[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:zipName]]) {
        [self unzipHtmlFile:zipName getMagazineNumber:self.magazineNumber];
        //[self deleteZipFile:zipName getMagazineNumber:self.magazineNumber];
        //解压好后发通知给当前页面，更新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_DOWNLOADSTATUS" object:@{@"downloadZipInfo" : zipName}];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败！%@",[request.userInfo allKeys]);
    [request.userInfo enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        GSPageInfo *pageInfo = obj;
        NSString *downloadURL = [NSString stringWithFormat:@"%@/%@",[self getTopicDownloadURL:pageInfo.page_pagePath],key];
        NSLog(@"下载失败的url：%@",downloadURL);
        /*
        if (forceClose == NO) {
            //不是用户强制关闭而导致下载失败的，重新下载失败的内容
            ASIHTTPRequest *request2 = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:downloadURL]];
            request2.delegate = self;
            //下载到本地路径 Caches/magazineNumber/name.zip
            NSString *localURL = [[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:key];
            [request setDownloadDestinationPath:localURL];
            //设置本地缓存路径 Caches/magazineNumber/tmpFolder/name.tmp
            NSString *tmpURL = [[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:@"tmpFolder"];
            [request2 setTemporaryFileDownloadPath:tmpURL];
            //支持断点续传
            [request2 setAllowResumeForFileDownloads:YES];
            //下载进度 以后优化
            request2.downloadProgressDelegate = self;
            request2.userInfo = @{key : pageInfo};
            [queue addOperation:request];
        }
         */
    }];

    
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
//    NSLog(@"responseHeaders is%@,request length is %f",responseHeaders,request.contentLength/1024.0/1024.0);

}
//每次request下载了更多数据时，这个函数会被调用
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    
}
//当下载的大小发生改变时，这个函数会被调用，传入的参数是你需要增加的大小
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    
}
//设置进度代理
- (void) setProgress:(float)newProgress
{
    UIProgressView * myProgress = [[UIProgressView alloc] init];
    [myProgress setProgress:newProgress];
    UILabel *lbPercent = [[UILabel alloc] init];
    lbPercent.text=[NSString stringWithFormat:@"%0.f%%",newProgress*100];
    NSLog(@"%@",lbPercent.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_DOWNLOADPROGRESS"
                                                        object:lbPercent.text];
    
    
}


//下载好了再解压文件unzip
- (void)unzipHtmlFile:(NSString *)unzipName getMagazineNumber:(NSString *)number
{
    //解压路径 magazineNumber目录下
    NSString *unzipPath = [[NSString alloc] init];
    unzipPath = [[kCachesFolderPath stringByAppendingPathComponent:number] stringByAppendingPathComponent:unzipName];
    NSString * str = [[[unzipName lastPathComponent] componentsSeparatedByString:@"."] objectAtIndex:0];
    NSLog(@"folder is %@",str);
    NSString  *unzipFolder = [[kCachesFolderPath stringByAppendingPathComponent:number] stringByAppendingPathComponent:str];
    //初始化解压器
    ZipArchive *unzip = [[ZipArchive alloc] init];
    //如果存在zip包就解压 [[zipName componentsSeparatedByString:@"."] objectAtIndex:0]
    if ([unzip UnzipOpenFile:unzipPath]) {
        //解压到本期目录内
        BOOL result = [unzip UnzipFileTo:unzipFolder overWrite:YES];
        if (result) {
            NSLog(@"解压成功!");
        }
    }

    [unzip UnzipCloseFile];
    
}
//解压好了删除原zip文件 Caches/期刊号/zip name
- (void)deleteZipFile:(NSString *)deleteZipName getMagazineNumber:(NSString *)number
{
    //删除文件路径
    NSString *deleteZipPath = [[NSString alloc] init];
    deleteZipPath = [[kCachesFolderPath stringByAppendingPathComponent:number] stringByAppendingPathComponent:deleteZipName];
    //下载好 存在 删除zip
    [FileOperation removeFileAtPath:deleteZipPath];
}
//停止下载所有队列
- (void)cancelDownloadAllQueues
{
    for (ASIHTTPRequest *req in [queue operations]) {
        NSLog(@"取消下载的请求是%@",req);
        [req clearDelegatesAndCancel];
        
    }
    forceClose = YES;
    /*
    //取消最后一个（顺序下载）
    [queue operations]
    [queue cancelAllOperations];
    NSLog(@"取消所有下载");
    //设置是用户退出的行为导致下载停止
    forceClose = YES;
    //调用下载失败的delegate
     */
    
}


@end
