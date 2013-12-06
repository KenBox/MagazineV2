//
//  DEMOHomeViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//


//行高
#define HEIGHT_SHELF                        220
#define _BACKGROUNDQUEUE "backgroundqueue"
static int ZipTag = 0;//创建一个计数器控制解压文件
static int imageIndex = 0;


#import "DEMOHomeViewController.h"
#import "DEMONavigationController.h"
#import "ContentViewController.h"
#import "CellViewController.h"
#import "GSReachability.h"
#import "MeiJiaHeader.h"
#import "ASIHTTPRequest.h"
#import "FileOperation.h"
#import "GSStoreMap.h"
#import "PeriodicalData.h"
#import "MagazineMap.h"
#import "LeavesView.h"
#import "ContentData.h"
#import "ASINetworkQueue.h"
@interface DEMOHomeViewController ()

@end

@implementation DEMOHomeViewController
@synthesize tableView,YearKeysData,YearData,AllDataDict,ContentView;
@synthesize zipqueue;

-(void)showFavourite{
    NSLog(@"tap 收藏");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    zipqueue = [[ASINetworkQueue alloc]init];
    //启动
    [zipqueue setMaxConcurrentOperationCount:5];
    //取消队列中下载失败就取消其他所有请求的情况。
    [zipqueue setShouldCancelAllRequestsOnFailure:NO];

	self.title = @"Home Controller";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showFavourite)];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setAllowsSelection:NO];
    [self.view addSubview:self.tableView];
    
    
    //在首页界面加载完成后，调用后台访问的代码
    //最好使用多线程，新开一个线程访问
    //新建一个后台运行的线程队列
    dispatch_async(dispatch_queue_create(_BACKGROUNDQUEUE, NULL), ^{
        [self getListXML];
        self.YearKeysData = [[NSMutableArray alloc]initWithArray:[[GSStoreMap sharedInstance].yearData allKeys]];
        self.YearData = [[NSMutableArray alloc]initWithArray:[[GSStoreMap sharedInstance].yearData allValues]];
        //对数组经行排序
        [self sortMonthData];
        [self sortYearData];
        self.YearKeysData = [NSMutableArray arrayWithArray:[self.YearKeysData sortedArrayUsingSelector:@selector(compare:)]];
        
        //更新好xml数据到主线程刷新table
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activity stopAnimating];
            for (UIView * obj in self.tableView.subviews) {
                [obj removeFromSuperview];
            }
            [self.tableView reloadData];
        });
    });
}

-(void)sortMonthData{
    for (int i = 0; i<YearData.count; i++) {
        NSArray * obj = [YearData objectAtIndex:i];
        NSMutableArray * Array = [NSMutableArray arrayWithArray:obj];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PeriodicalTag" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [Array sortUsingDescriptors:sortDescriptors];
        [YearData replaceObjectAtIndex:i withObject:Array];
    }
}

-(void)sortYearData{
    //类似冒泡排序将YearData从大至小排序
    for (int i = 0; i<self.YearData.count - 1; i++) {
        NSArray * PerArray1 = [self.YearData objectAtIndex:i];
        NSArray * PerArray2 = [self.YearData objectAtIndex:i+1];
        
        PeriodicalData * obj1 = [PerArray1 firstObject];
        PeriodicalData * obj2 = [PerArray2 firstObject];
        
        NSInteger Year1 = [obj1.Year integerValue];
        NSInteger Year2 = [obj2.Year integerValue];
        
        if (Year1>Year2) {
            [self.YearData exchangeObjectAtIndex:i withObjectAtIndex:i+1];
        }
    }
}

#pragma mark -
#pragma mark UITableView Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_SHELF;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [YearKeysData count];
}

//通过计算得出Section需要分配的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSArray * arr = [YearData objectAtIndex:sectionIndex];
    NSInteger RowNumber = 0;
    if ([arr count]%2==0) {
        RowNumber = [arr count]/2;
    }else if([arr count]%2 == 1){
        RowNumber = [arr count]/2 + 1;
    }
    return RowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //每次取出队列都需要清空子视图
    for (UIView* view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
//    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    NSInteger MagazineNum = indexPath.row * 2;
    CGFloat origin_x = 0;
    for (NSInteger i = MagazineNum; i<MagazineNum + 2 && i< [[YearData objectAtIndex:indexPath.section] count]; i++) {
        CellViewController * homecell = [[CellViewController alloc]initWithNibName:@"CellViewController" bundle:Nil];
        CGRect frame = CGRectMake(origin_x+20, 10, 140, 200);
        [homecell.view setFrame:frame];
        
        PeriodicalData * CellPer = [[YearData objectAtIndex:indexPath.section] objectAtIndex:i];
        //设置文件路径
        NSString * downloadPath = [NSString stringWithFormat:@"%@/%@/%@",kCachesFolderPath,CellPer.FolderName,CellPer.FrontCoverName];
        NSString * localImgPath = [NSString stringWithFormat:@"%@/%@",CellPer.ResourcePath,CellPer.FrontCoverName];
        NSString * localXMLPath = [NSString stringWithFormat:@"%@/%@.xml",CellPer.ResourcePath,CellPer.FolderName];
        //判断文件是否存在
        if (![FileOperation fileExistsAtPath:localXMLPath]) {
            [CellPer downloadImageFrom:CellPer.FrontCoverURL intoPath:downloadPath ByCreatFolder:CellPer.FolderName];
            [CellPer downloadFileFrom:CellPer.TopicXMLURL intoPath:localXMLPath];
        }
        UIImage * CellImg = [UIImage imageWithContentsOfFile:localImgPath];
        [homecell.CellImageView setImage:CellImg];
        [homecell.CellImageView setTag:[CellPer.PeriodicalTag integerValue]];
        [homecell.CellImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureTap:)];
        [homecell.CellImageView addGestureRecognizer:tap];
        origin_x += 150;
        
        homecell.CellLabel.text = CellPer.LabelTitle;
        [cell.contentView addSubview:homecell.view];
    }
    return cell;
}



//添加章节头部的 section Header 上的 年份内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //新建一个子视图，在子视图中可以设置的属性较多，实现的效果也更好
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19.f];
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.backgroundColor = [UIColor clearColor];
    
    

    NSString *yearKey = [YearKeysData objectAtIndex:section];
    titleLabel.text = [NSString stringWithFormat:@"%@年",yearKey];
    titleLabel.frame = CGRectMake(15.f, 0.f, 80.f, 40.f);
	
    //把创建的子视图，添加到表格 section header 内部
	[headerView addSubview:titleLabel];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yearView.png"]];
	[headerView sizeToFit];
    
	return headerView;
}



-(void)getListXML
{
    NSLog(@"------运行到这里，说明正在网络请求后台的 List.xml --------");
    //添加网络状态判断
    if ([GSReachability checkIfOnline]) {
        //网络正常链接
        //1 得到List.xml的路径
        NSURL *listURL = [NSURL URLWithString:KListXMLDownloadURL];
        //2 建立请求对象
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:listURL];
        //3 设置下载的路径
        [request setDownloadDestinationPath:[FileOperation getCachesDirectory:KListXMLName]];
        //使用缓存策略
        [request setCachePolicy:ASIUseDefaultCachePolicy];
        //GSSaveBundleFileInDocumentsDirectory(xmlData, LISTFILENAME);  //?每次保存的都是最新的list
        //解析对应路径的 XML ，得到首页需要的数据
        [[GSStoreMap sharedInstance] getStoreMapFromXmlSource:listURL];
    }
    else
    {
        //网络不能链接
        
    }
    
}

-(void)gestureTap:(UITapGestureRecognizer *)sender{
    NSLog(@"tap");
    
    [self showOnWindow:sender];
    ContentView = [[ContentViewController alloc]initWithNibName:@"ContentViewController" bundle:Nil];
    [self presentViewController:ContentView animated:YES completion:Nil];
    
  

//    [self presentViewController:ContentView animated:YES completion:^{}];
}

#pragma mark - activity Methods
- (void)showOnWindow:(id)sender {
	// The hud will dispable all input on the window
	HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
	[self.view.window addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"页面加载中";
	
	[HUD showWhileExecuting:@selector(myTask:) onTarget:self withObject:(UIGestureRecognizer *)sender animated:YES];
    
}

-(void)myTask:(id)sender{
    
    
    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;
    UIView * view = tap.view;
    NSInteger tag = view.tag;
    NSLog(@"tag = %d",tag);
    NSString * str = [NSString stringWithFormat:@"%d",tag];
    NSString * subStr1 = [str substringToIndex:6];
    NSString * subStr2 = [str substringFromIndex:6];
    NSString * folderName = [NSString stringWithFormat:@"%@_%@",subStr1,subStr2];
    NSString * xmlPath = [NSString stringWithFormat:@"%@/%@/%@.xml",kCachesFolderPath,folderName,folderName];
    [[MagazineMap sharedInstance] getMagazineMapFromXmlSource:xmlPath];
    
    ContentData * data = [[MagazineMap sharedInstance].TopicArray firstObject];
    
    
    
    if (ZipTag) {
        ZipTag = 0;
        imageIndex = 0;
    }
    //下载加解压
        for (int i = 0; i<data.ZipURL.count; i++) {
            NSString * ZipURL = [data.ZipURL objectAtIndex:i];
            NSString * ZipPath = [data.TopicZipPath objectAtIndex:i];
            NSString * UnZippedPath = [NSString stringWithFormat:@"%@/%@",kCachesFolderPath,data.FolderName];
            if (![FileOperation fileExistsAtPath:ZipPath]) {
                [data downloadFileFrom:ZipURL intoPath:ZipPath];
                [data unzipImage:ZipPath WithZipDir:UnZippedPath];
//                ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:ZipURL]];
//                [request setDownloadDestinationPath:ZipPath];
//                [request setAllowResumeForFileDownloads:YES];
//                [request setDelegate:self];
//                [zipqueue addOperation:request];
//                [zipqueue go];
            }
            if (ZipTag > 2 && ZipTag % 3 == 0) {
                [self uploadContentImages];
                ZipTag++;
                continue;
            }
            NSLog(@"ZipTag = %d",ZipTag);
            ZipTag++;
        }
    [self uploadContentImages];
    //后台继续下载目录页图片
    [self downloadThumbImages];
    ZipTag = 0;
    imageIndex = 0;
    NSLog(@"全部图片下载解压完毕");
}

//在主线程刷新页面显示的数据
-(void)uploadContentImages{

    ContentData * data = [[MagazineMap sharedInstance].TopicArray firstObject];
    NSArray * array = [NSArray arrayWithArray:data.resourcePath];
    int min = (array.count < ZipTag ? array.count : ZipTag);
    if (!ContentView.images) {
        ContentView.images = [[NSMutableArray alloc]init];
    }
    
    for ( ; imageIndex < min; imageIndex++ ) {
        NSString * imgpath =[array objectAtIndex:imageIndex];
        UIImage * img =[UIImage imageWithContentsOfFile:imgpath];
        [ContentView.images addObject:img];
    }
    
    //更新好xml数据到主线程刷新table
    dispatch_async(dispatch_get_main_queue(), ^{
        [_activity stopAnimating];
        NSLog(@"leavesView reloadData");
        
        [ContentView.leavesView reloadData];

        //这里已经加载了3张视图，可以把界面交还给用户
        [HUD hide:YES];
    });
    
}
//后台继续下载目录页所需图片
-(void)downloadThumbImages{
    ContentData * data = [[MagazineMap sharedInstance].TopicArray firstObject];
    for (int i = 0 ; i<data.ThumbURL.count; i++) {
        NSString * ThumbURL = [data.ThumbURL objectAtIndex:i];
        NSString * ThumbPath = [data.ThumbPath objectAtIndex:i+1];//目录存放路径包含了不用下载的封面路径，所以i+1
        if (![FileOperation fileExistsAtPath:ThumbPath]) {
            [data downloadFileFrom:ThumbURL intoPath:ThumbPath];
        }
    }
}


#pragma mark - ASIHTTPRequest协议
//帮助完成后解压
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSLog(@"complete!");
//    NSLog(@"userInfo:%@, keys:%@",request.userInfo,[request.userInfo allKeys]);
//    NSString *zipName = [[request.userInfo allKeys] objectAtIndex:0];
//    //下载完成 解压zip
//    //如果目标文件夹中存在zip文件就解压
//    if ([FileOperation fileExistsAtPath:[[kCachesFolderPath stringByAppendingPathComponent:self.magazineNumber] stringByAppendingPathComponent:zipName]]) {
//        [self unzipHtmlFile:zipName getMagazineNumber:self.magazineNumber];
//        //[self deleteZipFile:zipName getMagazineNumber:self.magazineNumber];
//        //解压好后发通知给当前页面，更新界面
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_DOWNLOADSTATUS" object:@{@"downloadZipInfo" : zipName}];
//    }
//    
//}

@end
