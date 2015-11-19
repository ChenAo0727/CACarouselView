//
//  CACarouselViewController.m
//  CACarouselViewDemo
//
//  Created by chenao on 15/11/19.
//  Copyright © 2015年 chenao. All rights reserved.
//

#import "CACarouselViewController.h"
#import "CACarouselView.h"
#import "Common.h"

@implementation CACarouselViewController
+ (instancetype)defaultCAViewController {
    static CACarouselViewController *CACarouselVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CACarouselVC = [[CACarouselViewController alloc]initWithNibName:@"CACarouselViewController" bundle:nil];
    });
    return CACarouselVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCACarouselView];
    [self setupPageControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.CACarouselView start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.CACarouselView stop];
}

#pragma mark - Private Method
- (void)setupCACarouselView {
    self.CACarouselView.images = [self imageURLs];
    self.CACarouselViewHeightConstraint.constant = 200;
    self.CACarouselView.placeholder = PLACEHOLDER_IMAGE;
    self.CACarouselView.pageDelegate = self;
    self.CACarouselView.autoMoving = YES;
    self.CACarouselView.movingTimeInterval = 1.5f;
}

- (void)setupPageControl {
    self.pageControl.numberOfPages = [[self imageURLs] count];
}

- (NSArray *)imageURLs {
    NSArray *imageURLs = @[[NSURL URLWithString:IMAGE_0],
                           [NSURL URLWithString:IMAGE_1],
                           [NSURL URLWithString:IMAGE_2]];
    return imageURLs;
}

#pragma mark - CACarouselDelegate
- (void)carouselView:(CACarouselView *)carouselView didMoveToPage:(NSUInteger)page {
    self.pageControl.currentPage = page;
}

- (void)carouselView:(CACarouselView *)carouselView didSelectedPage:(NSUInteger)page {
    NSLog(@"No.%ld page did TOUCH",self.pageControl.currentPage);
}

@end
