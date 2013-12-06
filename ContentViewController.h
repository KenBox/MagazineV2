//
//  ContentViewController.h
//  Magazine_V2
//
//  Created by Ken on 13-12-5.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeavesViewController.h"

@class HMSideMenu;
@interface ContentViewController : LeavesViewController
@property (nonatomic, strong) HMSideMenu *sideMenu;
//Leaves框架
@property (nonatomic,strong) NSMutableArray *images;

@end
