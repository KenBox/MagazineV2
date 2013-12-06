//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
enum kBtnType{
    kHomeBtn = 0,
    kCachesBtn,
    kHelpBtn,
    kAboutUsBtn
};
#import "MeiJiaHeader.h"
#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "GSAlert.h"
#import "GSStoreMap.h"

@implementation DEMOMenuViewController

-(void)BtnPressed:(id)sender{
    UIButton * btn = sender;
    switch (btn.tag) {
        case kHomeBtn:
            NSLog(@"home");
            break;
        case kCachesBtn:
            NSLog(@"kCachesBtn");
            [self confirmToRemoveCache];
            break;
        case kHelpBtn:
            NSLog(@"kHelpBtn");
            break;
        case kAboutUsBtn:
            NSLog(@"kAboutUsBtn");
            break;
    
            
        default:
            break;
    }
}

-(void)confirmToRemoveCache{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"清理缓存" message:@"您确定要这么做吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"    , nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString * path = kCachesFolderPath;
        [fileManager removeItemAtPath:path error:Nil];
        //遍历文件夹
        //        NSDirectoryEnumerator *dirEnumerater = [fileManager enumeratorAtPath:path];
        //        NSString *filePath = nil;
        //        while(nil != (filePath = [dirEnumerater nextObject])) {
        //            [fileManager removeItemAtPath:filePath error:Nil];
        //        }
        //创建文件夹路径
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

//        [[GSStoreMap sharedInstance] getStoreMapFromXmlSource:[NSURL URLWithString:KListXMLDownloadURL]];
        [GSAlert showAlertWithTitle:@"清理缓存完毕"];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor redColor]];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(85, 0, 0, 184.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    imageView.image = [UIImage imageNamed:@"avatar.jpg"];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 50.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 3.0f;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imageView.layer.shouldRasterize = YES;
    imageView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
    label.text = @"Magazine";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [view addSubview:imageView];
    [view addSubview:label];
    [self.view addSubview:view];

    
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 184, 270, 208)];
    
//    [view2 setBackgroundColor:[UIColor redColor]];
    UIButton * HomeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 270, 54)];
    [HomeBtn setTitle:@"首页" forState:UIControlStateNormal];
    HomeBtn.tag = kHomeBtn;
    
    [HomeBtn setBackgroundColor:[UIColor colorWithWhite:0.298 alpha:0.500]];
    HomeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [HomeBtn addTarget:self action:@selector(BtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * CachesBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 54, 270, 54)];
    [CachesBtn setTitle:@"清理缓存" forState:UIControlStateNormal];
    [CachesBtn setBackgroundColor:[UIColor colorWithWhite:0.298 alpha:0.500]];
    [CachesBtn addTarget:self action:@selector(BtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    CachesBtn.tag = kCachesBtn;
    CachesBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    UIButton * HelpBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 108, 270, 54)];
    [HelpBtn setTitle:@"帮助页面" forState:UIControlStateNormal];
    HelpBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [HelpBtn setBackgroundColor:[UIColor colorWithWhite:0.298 alpha:0.500]];
    [HelpBtn addTarget:self action:@selector(BtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    HelpBtn.tag = kHelpBtn;

    UIButton * AboutUsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 162, 270, 54)];
    [AboutUsBtn setTitle:@"关于我们" forState:UIControlStateNormal];
    AboutUsBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [AboutUsBtn setBackgroundColor:[UIColor colorWithWhite:0.298 alpha:0.500]];
    [AboutUsBtn addTarget:self action:@selector(BtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    AboutUsBtn.tag = kAboutUsBtn;

    
    
    [view2 addSubview:HomeBtn];
    [view2 addSubview:CachesBtn];
    [view2 addSubview:HelpBtn];
    [view2 addSubview:AboutUsBtn];
    [self.view addSubview:view2];
    
    
    
//    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.opaque = NO;
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.tableHeaderView = ({
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = 50.0;
//        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//        imageView.layer.borderWidth = 3.0f;
//        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        imageView.layer.shouldRasterize = YES;
//        imageView.clipsToBounds = YES;
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
//        label.text = @"Magazine";
//        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
//        [label sizeToFit];
//        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        
//        [view addSubview:imageView];
//        [view addSubview:label];
//        view;
//    });
}

//#pragma mark -
//#pragma mark UITableView Delegate
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
//    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return nil;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//    
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return 0;
//    
//    return 34;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
//    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        DEMOHomeViewController *homeViewController = [[DEMOHomeViewController alloc] init];
//        navigationController.viewControllers = @[homeViewController];
//    } else {
//        DEMOSecondViewController *secondViewController = [[DEMOSecondViewController alloc] init];
//        navigationController.viewControllers = @[secondViewController];
//    }
//    
//    [self.frostedViewController hideMenuViewController];
//}
//
//#pragma mark -
//#pragma mark UITableView Datasource
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 54;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
//{
//    return 4;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    
//    if (indexPath.section == 0) {
//        NSArray *titles = @[@"Home", @"ClearCaches", @"Help",@"About Us"];
//        cell.textLabel.text = titles[indexPath.row];
//    }
////    } else {
////        NSArray *titles = @[@"John Appleseed", @"John Doe", @"Test User"];
////        cell.textLabel.text = titles[indexPath.row];
////    }
//    
//    return cell;
//}

@end
