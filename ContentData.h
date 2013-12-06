//
//  ContentData.h
//  Magazine_V2
//
//  Created by Ken on 13-12-5.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentData : NSObject

@property (nonatomic,strong) NSString * FolderName;//201311_1
@property (nonatomic,strong) NSString * CoverPath;//2012/201212/201212_1/frontcover/sfrontcover_1385378256.html
@property (nonatomic,strong) NSMutableArray * ThumbName;//1385378000557.jpg
@property (nonatomic,strong) NSMutableArray * ThumbURL;//
@property (nonatomic,strong) NSMutableArray * TopicPath;//2013/201311/201311_1/2013_11_1385378000557/2013_11_1385378000557.html
@property (nonatomic,strong) NSMutableArray * ZipURL;//localhost:8080/naill/upload/2013/201311/201311_1/frontcover.zip
@property (nonatomic,strong) NSMutableArray * TopicZipPath;//2013/201311/201311_1/2013_11_1385378000557.zip
@property (nonatomic,strong) NSMutableArray * resourcePath;//..../Library/Caches/2013_11_1/xxx.jpg|xxx.xml
@property (nonatomic,strong) NSMutableArray * ThumbPath;//..../Library/Caches/2013_11_1/xxx.jpg|xxx.xml


-(void)downloadFileFrom:(NSString *)URL intoPath:(NSString * )path;
    
-(void)downloadFileFrom:(NSString *)URLString intoPath:(NSString *)path ByCreatFolder:(NSString *)FolderName;

-(void)unzipImage:(NSString * )FileName WithZipDir:(NSString *)ZipDir;

@end
