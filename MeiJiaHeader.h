//
//  MeiJiaHeader.h
//  MagazineProject
//
//  Created by shangdejigou on 13-11-28.
//  Copyright (c) 2013年 LiuLiLi. All rights reserved.
//

#ifndef MeiJiaApp_MeiJiaHeader_h
#define MeiJiaApp_MeiJiaHeader_h

//--------------------------------文件存放路径--------------------------

//公网上的服务器，有网络，真机时使用
#define kBaseHttpURL @"http://218.4.19.242:8089"
//陈健公网服务器地址
//#define kBaseHttpURL @"http://42.121.0.245:8080"
//本地电脑上的服务器，无网络，模拟器时使用
//#define kBaseHttpURL @"http://localhost:8080"

//项目名称和项目中存放 数据的目录
#define kResouceFlieName @"naill/upload"
//项目中总的配置文件名称 List.xml
#define KListXMLName @"List.xml"

//程序总的 List.xml
//http://localhost:8080/naill/upload/List.xml
#define KListXMLDownloadURL [NSString stringWithFormat:@"%@/%@/%@",kBaseHttpURL,kResouceFlieName,KListXMLName]


#define kCachesFolderPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] //Caches文件夹
#define KDocumentFolderPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] //Documents文件夹
#define kTmpFolderPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Tmp"] //tmp文件夹

//#define kResouceFlieName @"shishang"

#define KLoadingImageName @"loading_Bg.png"
#define KLoadingFileName @"WelcomeImages_magazine"

//#define kResouceUseFolderPath [kCachesFolderPath stringByAppendingPathComponent:KLoadingFileName]
#define kResouceUseFolderPath [kCachesFolderPath stringByAppendingPathComponent:kResouceFlieName] //资源使用目录 Library/Caches/jianfengzazhi
#define kResouceDownloadFolderPath [kTmpFolderPath stringByAppendingPathComponent:kResouceFlieName]	//资源临时存放目录
#define kResouceDownloadURL [NSString stringWithFormat:@"%@/%@", kBaseHttpURL, kResouceFlieName]



#define KLoadingImageDownloadURL [NSString stringWithFormat:@"%@/%@/%@",kBaseHttpURL,KLoadingFileName,KLoadingImageName] //http://mz.glavesoft.com/WelcomeImages_magazine/loading_bg.png
//[kBaseHttpURL stringByAppendingPathComponent:kResouceFlieName]	//用这种方式http：//会变成http：/
//sina weibo key
#define kAppKey             @"2527883662"
#define kAppSecret          @"d6e639fba11bb9097cfe50d787997515"
#define kAppRedirectURI     @"http://www.sina.com"

#ifndef __OPTIMIZE__
#    define NSLog(...) NSLog(__VA_ARGS__)
#else
#    define NSLog(...) {}
#endif


#endif
