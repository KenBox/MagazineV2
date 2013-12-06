//
//  ContentViewController.m
//  Magazine_V2
//
//  Created by Ken on 13-12-5.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "ContentViewController.h"
#import "HMSideMenu.h"
#import "LeavesView.h"
#import "Utilities.h"
#import "ASIHTTPRequest.h"
@interface ContentViewController ()

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _images = [[NSMutableArray alloc]init];
        self.leavesView.currentPageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect ItemFrame = CGRectMake(0, 0, 66, 40);
    UIColor * bgcolor = [UIColor colorWithRed:0.220 green:0.185 blue:0.126 alpha:0.500];
    UIView *HomeItem = [[UIView alloc] initWithFrame:ItemFrame];
    [HomeItem setBackgroundColor:bgcolor];
    [HomeItem.layer setCornerRadius:8];
    [HomeItem setMenuActionWithBlock:^{
        [self HomeBtnPressed:Nil];
    }];
    UIImageView *HomeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(19, 6, 28, 28)];
    [HomeIcon setImage:[UIImage imageNamed:@"btn_home.png"]];
    [HomeItem addSubview:HomeIcon];
    
    UIView *CommentItem = [[UIView alloc] initWithFrame:ItemFrame];
    [CommentItem setBackgroundColor:bgcolor];
    [CommentItem.layer setCornerRadius:8];
    [CommentItem setMenuActionWithBlock:^{
        [self CommentBtnPressed:Nil];
    }];
    UIImageView *CommentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(19, 6, 28 , 28)];
    [CommentIcon setImage:[UIImage imageNamed:@"btn_cmt.png"]];
    [CommentItem addSubview:CommentIcon];
    
    UIView *ShareItem = [[UIView alloc] initWithFrame:ItemFrame];
    [ShareItem setBackgroundColor:bgcolor];
    [ShareItem.layer setCornerRadius:8];
    [ShareItem setMenuActionWithBlock:^{
        [self ShareBtnPressed:Nil];
        
    }];
    UIImageView *ShareIcon = [[UIImageView alloc] initWithFrame:CGRectMake(19, 6, 28, 28)];
    [ShareIcon setImage:[UIImage imageNamed:@"btn_share.png"]];
    [ShareItem addSubview:ShareIcon];
    
    
    UIView *ThumbItem = [[UIView alloc] initWithFrame:ItemFrame];
    [ThumbItem setBackgroundColor:bgcolor];
    [ThumbItem.layer setCornerRadius:8];
    [ThumbItem setMenuActionWithBlock:^{
        [self ThumbBtnPressed:Nil];
    }];
    UIImageView *ThumbIcon = [[UIImageView alloc] initWithFrame:CGRectMake(21, 8, 24, 24)];
    [ThumbIcon setImage:[UIImage imageNamed:@"btn_catalog.png"]];
    [ThumbItem addSubview:ThumbIcon];
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[HomeItem, CommentItem, ShareItem, ThumbItem]];
    [self.sideMenu setItemSpacing:5.0f];
    [self.sideMenu setMenuPosition:HMSideMenuPositionBottom];
    [self.view addSubview:self.sideMenu];

    //Tap手势显示及隐藏Toolbar
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                           action:@selector(toggleMenu:)];
    [self.leavesView addGestureRecognizer:tap1];
    [self.view insertSubview:self.leavesView atIndex:0];

}


#pragma mark - Button Methods
- (void)ThumbBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了目录");
//    ThumbViewController = [[CCThumbViewController alloc]initWithNibName:@"CCThumbViewController" bundle:Nil];
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"thumbImages" object:ThumbImagesArray];
//    [self presentViewController:ThumbViewController animated:YES completion:Nil];
}
- (void)HomeBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了Home");

    [self dismissViewControllerAnimated:YES completion:Nil];
    //    [self.leavesView removeFromSuperview];
    
}
- (void)CommentBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了评论");
//    CommentViewController = [[CCCommentViewController alloc]initWithNibName:@"CCCommentViewController" bundle:Nil];
//    [self presentViewController:CommentViewController animated:YES completion:Nil];
}
- (void)ShareBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了分享");
//    shareActionSheet = [[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到新浪微博" otherButtonTitles:@"分享到腾讯微博", nil];
//    [shareActionSheet showInView:self.view];
    
}


#pragma mark - SideMenu
- (void)toggleMenu:(id)sender {
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    else
        [self.sideMenu open];
}

#pragma mark LeavesViewDataSource

- (NSUInteger)numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return _images.count;
}

- (void)renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	UIImage *image = [_images objectAtIndex:index];
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	CGAffineTransform transform = aspectFit(imageRect,
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawImage(ctx, imageRect, [image CGImage]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
