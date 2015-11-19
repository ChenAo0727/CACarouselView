//
//  CACarouselViewController.h
//  CACarouselViewDemo
//
//  Created by chenao on 15/11/19.
//  Copyright © 2015年 chenao. All rights reserved.
//

#import "CACarouselView.h"
@class CACarouselView;
@interface CACarouselViewController : UIViewController <CACarouselDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CACarouselViewHeightConstraint;
@property (weak, nonatomic) IBOutlet CACarouselView *CACarouselView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
+ (instancetype)defaultCAViewController;
@end
