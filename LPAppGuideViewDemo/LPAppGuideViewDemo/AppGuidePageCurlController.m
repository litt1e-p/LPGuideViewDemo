//
//  AppGuidePageCurlController.m
//  LPAppGuideViewDemo
//
//  Created by  litt1e-p   on 16/1/25.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "AppGuidePageCurlController.h"
#import "ViewController.h"

#undef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#undef kScreenHeight
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AppGuidePageCurlController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic,strong)UIPageViewController *pageVC;
@property (nonatomic,strong)NSMutableArray *viewControllers;

@end

@implementation AppGuidePageCurlController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    self.viewControllers = vcs;
    for (NSUInteger i = 0; i < 4; i++) {
        UIViewController * controller = [[UIViewController alloc] init];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:controller.view.bounds];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideBg%02lu", i + 1]];
        imageView.tag = 1000 + i;
        [controller.view addSubview:imageView];
        if (i == 3) {
            UIButton *entryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnY = kScreenHeight * 950 / 1135;
            CGFloat btnW = kScreenWidth * 250 / 640;
            CGFloat btnH = kScreenHeight * 65 / 1135;
            CGFloat btnX = kScreenWidth * 0.5 - btnW * 0.5;
            entryBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            entryBtn.layer.cornerRadius = 5.f;
            [entryBtn setBackgroundColor:[UIColor whiteColor]];
            [entryBtn setTitle:@"start adventure" forState:UIControlStateNormal];
            [entryBtn setTitleColor:[UIColor colorWithRed:109/255.f green:127/255.f blue:257/255.f alpha:1.f] forState:UIControlStateNormal];
            [entryBtn addTarget:self action:@selector(disAppearView) forControlEvents:UIControlEventTouchUpInside];
            [controller.view addSubview:entryBtn];
        }
        [self.viewControllers addObject:controller];
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageVC.dataSource        = self;
    self.pageVC.delegate          = self;
    self.pageVC.view.frame        = self.view.bounds;
    UIViewController * controller = self.viewControllers[0];
    NSArray *viewControllers =[NSArray arrayWithObject:controller];
    [self.pageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self.view addSubview:self.pageVC.view];
    
}

#pragma - mark datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger number = [viewController.view.subviews objectAtIndex:0].tag - 1000;
    if (number == NSNotFound) {
        return nil;
    }
    number++;
    if (number >= [self.viewControllers count]) {
        return nil;
    }
    return [self.viewControllers objectAtIndex:number];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger number = [viewController.view.subviews objectAtIndex:0].tag - 1000;
    if ((number == 0) || (number == NSNotFound)) {
        return nil;
    }
    number--;
    return [self.viewControllers objectAtIndex:number];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)disAppearView
{
    ViewController *rootView    = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootView];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    [self.view removeFromSuperview];
}

@end
