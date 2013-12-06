//
//  MagazineMap.m
//  Magazine_V2
//
//  Created by Ken on 13-12-5.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "MagazineMap.h"
#import "ContentData.h"
#import "GDataXMLNode.h"
#import "MeiJiaHeader.h"
@implementation MagazineMap
@synthesize TopicArray;
@synthesize data;

+ (MagazineMap *)sharedInstance
{
    static MagazineMap *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[MagazineMap alloc] init];
         
    });
    return shared;
}

-(void)getMagazineMapFromXmlSource:(NSString *)xmlPath{
    NSLog(@"后台解析MagazineMap数据");
    if (!self.TopicArray) {
        self.TopicArray = [[NSMutableArray alloc] init];
    }else{
        [self.TopicArray removeAllObjects];
    }
    
    NSString *docXML =[NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:Nil];
    //锅炉方式解析 XML (把所有内容全部倒入解析器)
    //预备一个 错误处理对象
    NSError *error = nil;
    
    //新建一个代表 XML 文档对象，代表所有 XML 文档内容
    GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithXMLString:docXML options:0 error:&error];

    
    GDataXMLElement *rootElement = [doc rootElement];
    NSArray *periodical = [rootElement children];
    //解析xml文件
    ContentData * conData = [[ContentData alloc]init];

    for (GDataXMLNode * obj in periodical) {
        for (GDataXMLElement * subObj in [obj children]) {
            if ([subObj.name isEqualToString:@"CoverPage"]) {
                //CoverPath
                NSString * coverpath = [[subObj attributeForName:@"CoverPath"] stringValue];
                conData.CoverPath = coverpath;
                
                //FolderName
                NSString * folder = [[coverpath componentsSeparatedByString:@"/"] objectAtIndex:2];
                conData.FolderName = folder;
                
                //ThumbName
                NSString * thumbname = [[subObj attributeForName:@"ThumbName"]stringValue];
                [conData.ThumbName addObject:thumbname];
                
                //封面页的ZipURL
                NSArray * arr = [coverpath componentsSeparatedByString:@"/"];
                NSString * zipurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@.zip",kBaseHttpURL,kResouceFlieName,[arr objectAtIndex:0],[arr objectAtIndex:1],[arr objectAtIndex:2],[arr objectAtIndex:3]];
                [conData.ZipURL addObject:zipurl];
                
                //封面页的ZipPath
                NSString * subzip = [[thumbname componentsSeparatedByString:@"."] objectAtIndex:0];
                NSString * zippath = [NSString stringWithFormat:@"%@/%@/%@.zip",kCachesFolderPath,conData.FolderName,subzip];
                [conData.TopicZipPath addObject:zippath];
                
                //封面页的ThumbPath
                NSString * frontpath = [NSString stringWithFormat:@"%@/%@/%@",kCachesFolderPath,folder,thumbname];
                [conData.ThumbPath addObject:frontpath];
                
                //封面页的resourcePath
                NSString * resourcestr = [NSString stringWithFormat:@"%@/%@/resource/%@",kCachesFolderPath,conData.FolderName,thumbname];
                [conData.resourcePath addObject:resourcestr];

            }else{
                //ThumbName
                NSString * thumbname = [[subObj attributeForName:@"ThumbName"]stringValue];
                [conData.ThumbName addObject:thumbname];
                
                
                //TopicPath
                NSString * topicpath = [[subObj attributeForName:@"TopicPath"]stringValue];
                
                //ZipURL
                NSArray * arr = [topicpath componentsSeparatedByString:@"/"];
                [conData.TopicPath addObject:topicpath];
                                NSString * zipurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@.zip",kBaseHttpURL,kResouceFlieName,[arr objectAtIndex:0],[arr objectAtIndex:1],[arr objectAtIndex:2],[arr objectAtIndex:3]];
                [conData.ZipURL addObject:zipurl];
                
                //ThumbURL
                NSMutableArray * mutarr = [NSMutableArray arrayWithArray:arr];
                [mutarr removeLastObject];
                [mutarr removeLastObject];
                NSString * str = [mutarr componentsJoinedByString:@"/"];
                NSString * thumburl = [NSString stringWithFormat:@"%@/%@/%@/ThumbPackage/%@",kBaseHttpURL,kResouceFlieName,str,thumbname];
                [conData.ThumbURL addObject:thumburl];
                
                //ZipPath
                NSString * subzip = [[thumbname componentsSeparatedByString:@"."] objectAtIndex:0];
                NSString * zippath = [NSString stringWithFormat:@"%@/%@/%@.zip",kCachesFolderPath,conData.FolderName,subzip];
                [conData.TopicZipPath addObject:zippath];
                
                //resourcePath
                NSString * resourcestr = [NSString stringWithFormat:@"%@/%@/resource/%@",kCachesFolderPath,conData.FolderName,thumbname];
                [conData.resourcePath addObject:resourcestr];
                
                //ThumbPath
                NSString * frontpath = [NSString stringWithFormat:@"%@/%@/%@",kCachesFolderPath,conData.FolderName,thumbname];
                [conData.ThumbPath addObject:frontpath];
                
            }
        }
    }
    NSLog(@"TopicData = %@",conData);
    [self.TopicArray addObject:conData];
   
}




@end
