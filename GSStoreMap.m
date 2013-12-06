//
//  GSStoreMap.m
//  GSMagazinePublish
//
//  Created by zheng jie on 13-1-14.
//  Copyright (c) 2013年 GlaveSoft. All rights reserved.
//
//书店xml解析
#import "GSStoreMap.h"
#import "PeriodicalData.h"
#import "GDataXMLNode.h"
#import "MeiJiaHeader.h"

@implementation GSStoreMap

@synthesize yearData;
@synthesize monthData;
@synthesize DownloadQueue;

+ (GSStoreMap *)sharedInstance
{
    static GSStoreMap *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[GSStoreMap alloc] init];
    });
    return shared;
}


//书店xml解析
- (void)getStoreMapFromXmlSource:(NSURL *)xmlUrl
{
    NSData *xmlData = nil;
    xmlData = [NSData dataWithContentsOfURL:xmlUrl];

    self.yearData = [[NSMutableDictionary alloc] init];
    self.monthData = [[NSMutableArray alloc] init];
//    __block NSString *suffix_year;

    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];

    GDataXMLElement *rootElement = [doc rootElement];
    NSArray *years = [rootElement elementsForName:@"year"];
    
    for (GDataXMLElement * obj in years) {
        NSArray * month = [obj elementsForName:@"Month"];
        for (GDataXMLElement * subObj in month) {
            PeriodicalData * bookInfo = [[PeriodicalData alloc]init];
            
            //year
            bookInfo.Year = [[obj attributeForName:@"value"]stringValue];
            
            //month
            bookInfo.Month = [[[[subObj attributeForName:@"value"] stringValue] componentsSeparatedByString:@"."] objectAtIndex:1];
            
            //Periodical
            GDataXMLElement *periodical = [[subObj elementsForName:@"Periodical"] objectAtIndex:0];
            bookInfo.Periodical = [periodical stringValue];
            
            //Title
            GDataXMLElement *title = [[subObj elementsForName:@"Title"] objectAtIndex:0];
            bookInfo.title = [title stringValue];
            
            //frontCover
            GDataXMLElement *frontCover = [[subObj elementsForName:@"FrontCover"] objectAtIndex:0];
            bookInfo.FrontCoverName = [frontCover stringValue];
            
            //Ppath
            GDataXMLElement *ppath = [[subObj elementsForName:@"Ppath"] objectAtIndex:0];
            bookInfo.Ppath = [ppath stringValue];
            //LabelTitle
            bookInfo.LabelTitle = [NSString stringWithFormat:@"%@年%@月第%@刊",bookInfo.Year,bookInfo.Month,bookInfo.Periodical];
            
            
            NSArray * arr =[bookInfo.Ppath componentsSeparatedByString:@"."];
            NSString * str = [arr objectAtIndex:0];
            NSArray * arr2 = [str componentsSeparatedByString:@"/"];
            NSMutableArray * mutArr2 = [NSMutableArray arrayWithArray:arr2];
            [mutArr2 removeLastObject];

            NSString * res = [mutArr2 componentsJoinedByString:@"/"];
            //PeriodicalTag
            bookInfo.PeriodicalTag = [NSString stringWithFormat:@"%@%@",[mutArr2 objectAtIndex:1],bookInfo.Periodical];
            
            //FolderName
            bookInfo.FolderName = [NSString stringWithString:[mutArr2 lastObject]];
            
            //FrontCoverURL
            bookInfo.FrontCoverURL = [NSString stringWithFormat:@"%@/%@/%@/ThumbPackage/%@",kBaseHttpURL,kResouceFlieName,res,bookInfo.FrontCoverName];
            
            NSString * folderName = [NSString stringWithFormat:@"%@%@_%@",bookInfo.Year,bookInfo.Month,bookInfo.Periodical];
            //resourcePath
            bookInfo.ResourcePath = [NSString stringWithFormat:@"%@/%@",kCachesFolderPath,folderName];
            //TopicXMLURL
            bookInfo.TopicXMLURL = [NSString stringWithFormat:@"%@/%@/%@",kBaseHttpURL,kResouceFlieName,bookInfo.Ppath];
            
            [monthData addObject:bookInfo];
        }
        NSArray * monthArr = [NSArray arrayWithArray:monthData];
//        [yearData addObject:monthArr];
        [yearData setObject:monthArr forKey:[[obj attributeForName:@"value"]stringValue]];
        [monthData removeAllObjects];
    }
    NSLog(@"yearData = %@",yearData);
}

@end
