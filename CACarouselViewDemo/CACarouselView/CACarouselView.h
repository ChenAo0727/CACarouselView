//
//  CACarouselView.h
//  CACarouselViewDemo
//
//  Created by chenao on 15/11/19.
//  Copyright © 2015年 chenao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CACarouselView;
@protocol CACarouselDelegate <NSObject>
- (void)carouselView:(CACarouselView *)carouselView didMoveToPage:(NSUInteger)page;
- (void)carouselView:(CACarouselView *)carouselView didSelectedPage:(NSUInteger)page;
@end

@interface CACarouselView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) BOOL isBool;
@property (nonatomic ,strong) NSArray *images;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, getter=isNeedRefresh) BOOL needRefresh;
@property (nonatomic, weak) id<CACarouselDelegate> pageDelegate;
@property (nonatomic, getter=isAutoMoving) BOOL autoMoving;
@property (nonatomic) NSTimeInterval movingTimeInterval;
@property (nonatomic, strong) UIImage *placeholder;
- (void)start;
- (void)stop;
@end