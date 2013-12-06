//
//  MagazineMap.h
//  Magazine_V2
//
//  Created by Ken on 13-12-5.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ContentData;
@interface MagazineMap : NSObject{

}

//[Topic1,Topic2,Topic3]
@property (strong, nonatomic) NSMutableArray *TopicArray;
@property (strong, nonatomic) ContentData * data;



+ (MagazineMap *)sharedInstance;
//内容页xml,本地路径
- (void)getMagazineMapFromXmlSource:(NSString *)xmlPath;

@end
