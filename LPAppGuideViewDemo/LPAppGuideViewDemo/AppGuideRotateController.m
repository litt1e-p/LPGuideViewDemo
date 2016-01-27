//
//  AppGuideController.m
//
//
//  Created by litt1e-p on 16/1/25.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "AppGuideRotateController.h"
#import "ViewController.h"

#define kBaseTag  999999
#define kRotateRate 1
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AppGuideRotateController ()<UIScrollViewDelegate>

@end

@implementation AppGuideRotateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:232/255.f green:77/255.f blue:136/255.f alpha:1];
    NSArray *imageArr         = @[@"guideBg01.png", @"guideBg02.png", @"guideBg03.png", @"guideBg04.png"];
    
    UIScrollView *mainScrollView                  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    mainScrollView.pagingEnabled                  = YES;
    mainScrollView.bounces                        = YES;
    mainScrollView.contentSize                    = CGSizeMake(kScreenWidth * imageArr.count, kScreenHeight);
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.delegate                       = self;
    [self.view addSubview:mainScrollView];
    
    for (int i = 0; i< imageArr.count; i++) {
        UIView *rotateView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight * 2)];
        [rotateView setTag:kBaseTag + i];
        [mainScrollView addSubview:rotateView];
        if (i !=0 ) {
            rotateView.alpha = 0;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        [rotateView addSubview:imageView];
        
        if (i == imageArr.count - 1) {
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
            [entryBtn addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
            [rotateView addSubview:entryBtn];
        }
    }
    UIView *firstView = [mainScrollView viewWithTag:kBaseTag];
    [mainScrollView bringSubviewToFront:firstView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView * view1 = [scrollView viewWithTag:kBaseTag];
    UIView * view2 = [scrollView viewWithTag:kBaseTag + 1];
    UIView * view3 = [scrollView viewWithTag:kBaseTag + 2];
    UIView * view4 = [scrollView viewWithTag:kBaseTag + 3];
    
    UIImageView * imageView1 = (UIImageView *)[scrollView viewWithTag:kBaseTag * 2];
    UIImageView * imageView2 = (UIImageView *)[scrollView viewWithTag:kBaseTag * 2 + 1];
    UIImageView * imageView3 = (UIImageView *)[scrollView viewWithTag:kBaseTag * 2 + 2];
    UIImageView * imageView4 = (UIImageView *)[scrollView viewWithTag:kBaseTag * 2 + 3];
    
    CGFloat xOffset = scrollView.contentOffset.x;
    CGFloat rotateAngle = -1 * 1.0 / kScreenWidth * xOffset * M_PI_2 * kRotateRate;
    view1.layer.transform = CATransform3DMakeRotation(rotateAngle, 0, 0, 1);
    view2.layer.transform = CATransform3DMakeRotation(M_PI_2 * 1 + rotateAngle, 0, 0, 1);
    view3.layer.transform = CATransform3DMakeRotation(M_PI_2 * 2 + rotateAngle, 0, 0, 1);
    view4.layer.transform = CATransform3DMakeRotation(M_PI_2 * 3 + rotateAngle, 0, 0, 1);
    
    view1.center = CGPointMake(0.5 * kScreenWidth+xOffset, kScreenHeight);
    view2.center = CGPointMake(0.5 * kScreenWidth+xOffset, kScreenHeight);
    view3.center = CGPointMake(0.5 * kScreenWidth+xOffset, kScreenHeight);
    view4.center = CGPointMake(0.5 * kScreenWidth+xOffset, kScreenHeight);
    
    if (xOffset<kScreenWidth*0.5) {
        [scrollView bringSubviewToFront:view1];
    } else if (xOffset>= kScreenWidth * 0.5 && xOffset < kScreenWidth * 1.5) {
        [scrollView bringSubviewToFront:view2];
    } else if (xOffset >= kScreenWidth*1.5 && xOffset < kScreenWidth * 2.5) {
        [scrollView bringSubviewToFront:view3];
    } else if (xOffset >= kScreenWidth*2.5) {
        [scrollView bringSubviewToFront:view4];
    }
    
    CGFloat xoffset_More = xOffset * 1.5 > kScreenWidth?kScreenWidth:xOffset * 1.5;
    if (xOffset < kScreenWidth) {
        view1.alpha      = (kScreenWidth - xoffset_More) / kScreenWidth;
        imageView1.alpha = (kScreenWidth - xOffset) / kScreenWidth;
    }
    if (xOffset <= kScreenWidth) {
        view2.alpha      = xoffset_More / kScreenWidth;
        imageView2.alpha = xOffset / kScreenWidth;
    }
    if (xOffset > kScreenWidth && xOffset <= kScreenWidth * 2) {
        view2.alpha      = (kScreenWidth * 2 - xOffset) / kScreenWidth;
        view3.alpha      = (xOffset - kScreenWidth) / kScreenWidth;
        imageView2.alpha = (kScreenWidth * 2 - xOffset) / kScreenWidth;
        imageView3.alpha = (xOffset - kScreenWidth) / kScreenWidth;
    }
    if (xOffset > kScreenWidth * 2 ) {
        view3.alpha      = (kScreenWidth * 3 - xOffset) / kScreenWidth;
        view4.alpha      = (xOffset - kScreenWidth*2) / kScreenWidth;
        imageView3.alpha = (kScreenWidth * 3 - xOffset)/kScreenWidth;
        imageView4.alpha = (xOffset - kScreenWidth * 2)/ kScreenWidth;
    }
    if (xOffset < kScreenWidth && xOffset > 0) {
        self.view.backgroundColor = [UIColor colorWithRed:(140 - 40.0 / kScreenWidth*xOffset) / 255.0 green:(255 - 25.0 / kScreenWidth*xOffset) / 255.0 blue:(255 - 100.0 / kScreenWidth * xOffset) / 255.0 alpha:1];
        
    } else if (xOffset >= kScreenWidth && xOffset<kScreenWidth * 2){
        self.view.backgroundColor = [UIColor colorWithRed:(100 + 30.0 / kScreenWidth * (xOffset - kScreenWidth)) / 255.0 green:(230 - 40.0 / kScreenWidth * (xOffset - kScreenWidth)) / 255.0 blue:(155 - 5.0 / 320 * (xOffset - kScreenWidth)) / 255.0 alpha:1];
    } else if (xOffset >= kScreenWidth * 2 && xOffset < kScreenWidth * 3){
        self.view.backgroundColor = [UIColor colorWithRed:(130 - 50.0 / kScreenWidth * (xOffset - kScreenWidth * 2)) / 255.0 green:(190 - 40.0 / kScreenWidth * (xOffset - kScreenWidth * 2)) / 255.0 blue:(150 + 50.0 / kScreenWidth * (xOffset - kScreenWidth * 2)) / 255.0 alpha:1];
    } else if (xOffset >= kScreenWidth * 3 && xOffset < kScreenWidth * 4){
        self.view.backgroundColor = [UIColor colorWithRed:232/255.f green:77/255.f blue:136/255.f alpha:1];
    }
}

- (void)clickToRemove
{
    ViewController *rootView    = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootView];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;

    [self.view removeFromSuperview];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
