//
//  GSStoreMap.h
//  GSMagazinePublish
//
//  Created by zheng jie on 13-1-14.
//  Copyright (c) 2013年 GlaveSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

@interface GSStoreMap : NSObject{
}

//{"2012":[杂志1,杂志2,杂志3,杂志4],"2013":[杂志1,杂志2,杂志3,杂志4]}
@property (nonatomic, strong) NSMutableDictionary *yearData;
//[杂志1,杂志2,杂志3,杂志4]
@property (strong, nonatomic) NSMutableArray *monthData;
@property (strong, nonatomic) ASINetworkQueue * DownloadQueue;

+ (GSStoreMap *)sharedInstance;
//书架xml
- (void)getStoreMapFromXmlSource:(NSURL *)xmlUrl;

@end
