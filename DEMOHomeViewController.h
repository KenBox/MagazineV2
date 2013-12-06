//
//  DEMOHomeViewController.h
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASINetworkQueue.h"
@class ContentViewController;
@interface DEMOHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate>{
    UIActivityIndicatorView *_activity;
    MBProgressHUD *HUD;
}

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * YearKeysData;//每年的数据，控制section
@property (nonatomic,strong) NSMutableDictionary * AllDataDict;
@property (nonatomic,strong) NSMutableArray * YearData;//每月的数据,控制row
@property (nonatomic,strong) ContentViewController * ContentView;
@property (nonatomic,strong) ASINetworkQueue * zipqueue;//zip下载队列

@end
