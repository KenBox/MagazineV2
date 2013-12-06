//
//  PeriodicalData.h
//  Magazine_V2
//
//  Created by Ken on 13-12-4.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeriodicalData : NSObject
@property (nonatomic,strong) NSString * Year;//2013
@property (nonatomic,strong) NSString * Month;//11
@property (nonatomic,strong) NSString * Periodical;//1|2|3当月期刊号
@property (nonatomic,strong) NSString * Title;//服务器对应的Title
@property (nonatomic,strong) NSString * FolderName;//对应本地Caches目录下的文件夹名称
@property (nonatomic,strong) NSString * PeriodicalTag;//对应Cell中imageView的tag
@property (nonatomic,strong) NSString * LabelTitle;//2013年11月第1刊
@property (nonatomic,strong) NSString * FrontCoverName;//sfrontcover_1385377980.jpg
@property (nonatomic,strong) NSString * Ppath;//2013/201311/201311_1/201311_1.xml
@property (nonatomic,strong) NSString * FrontCoverURL;//http://localhost:8080/naill/upload/2013/201311/201311_1/ThumbPackage/sfrontcover_1385377980.jpg
@property (nonatomic,strong) NSString * ResourcePath;//.../Library/Caches/2013_11_1/xxx.jpg|xxx.xml
@property (nonatomic,strong) NSString * TopicXMLURL;//http://localhost:8080/naill/upload/2013/201311/201311_1/201311_1.xml

-(void)downloadFileFrom:(NSString *)URLString intoPath:(NSString * )path;
-(void)downloadImageFrom:(NSString *)URLString intoPath:(NSString *)path ByCreatFolder:(NSString *)_FolderName;
@end
