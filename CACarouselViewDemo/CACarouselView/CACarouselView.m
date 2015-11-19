//
//  CACarouselView.m
//  CACarouselViewDemo
//
//  Created by chenao on 15/11/19.
//  Copyright © 2015年 chenao. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "CACarouselViewCell.h"
#import "CACarouselView.h"
#import "Common.h"
@implementation CACarouselView
@synthesize images = _images;
- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]){
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
    }
    [self registerNib:[UINib nibWithNibName:CACAROUSELVIEW_CELL_IDENTIFY bundle:nil] forCellWithReuseIdentifier:CACAROUSELVIEW_CELL_IDENTIFY];
    [self registerNofitication];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isNeedRefresh) {
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        self.needRefresh = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Method

- (void)start {
    [self addTimer];
}

- (void)stop {
    [self removeTimer];
}

#pragma mark - Private Method
- (void)addTimer {
    [self removeTimer];
    NSTimeInterval speed = self.movingTimeInterval < MIN_MOVING_TIMEINTERVAL ? DEFAULT_MOVING_TIMEINTERVAL : self.movingTimeInterval;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(moveToNextPage) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)moveToNextPage {
    CGPoint newContentOffset = (CGPoint){self.contentOffset.x + SCREEN_WIDTH,0};
    [self setContentOffset:newContentOffset animated:YES];
}

- (void)adjustCurrentPage:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH - 1;
    if (scrollView.contentOffset.x < SCREEN_WIDTH) {
        page = [self.images count] - 3;
    }
    else if (scrollView.contentOffset.x > SCREEN_WIDTH * ([self.images count] - 1)) {
        page = 0;
    }
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(carouselView:didMoveToPage:)]) {
        [self.pageDelegate carouselView:self didMoveToPage:page];
    }
}

- (void)registerNofitication {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX([self.images count],1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CACarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CACAROUSELVIEW_CELL_IDENTIFY forIndexPath:indexPath];
    if (![self.images count]) {
        [cell.currentImageView setImage:self.placeholder];
        return cell;
    }
    [cell.currentImageView sd_setImageWithURL:[self.images objectAtIndex:indexPath.item] placeholderImage:self.placeholder];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger page = 0;
    NSUInteger lastIndex = [self.images count] - 3;
    
    if (indexPath.item == 0) {
        page = lastIndex;
    }
    else if (indexPath.item == lastIndex) {
        page = 0;
    }
    else{
        page = indexPath.item - 1;
    }
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(carouselView:didSelectedPage:)]) {
        [self.pageDelegate carouselView:self didSelectedPage:page];
    }
}

#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == ([self.images count] - 1) * SCREEN_WIDTH ) {
        [self setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    }
    [self adjustCurrentPage:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.isAutoMoving) {
        [self addTimer];
    }
    if (scrollView.contentOffset.x < SCREEN_WIDTH ) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.images count] - 2 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    if (scrollView.contentOffset.x  > ([self.images count] - 1) * SCREEN_WIDTH - 10) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    [self adjustCurrentPage:scrollView];
    
}

#pragma mark - Notification
- (void)applicationWillResignActive {
    [self stop];
}

- (void)applicationDidBecomeActive {
    if (self.isAutoMoving) {
        [self start];
    }
}

#pragma mark - Getter and Setter
- (NSArray *)images {
    if (!_images) {
        _images = [NSArray array];
    }
    return _images;
}

- (void)setImages:(NSArray *)images {
    if (images.count > 0) {
        NSMutableArray *actuallyImages = [NSMutableArray array];
        [actuallyImages addObject:[images lastObject]];
        [actuallyImages addObjectsFromArray:images];
        [actuallyImages addObject:[images firstObject]];
        _images = [NSArray arrayWithArray:actuallyImages];
    }
    [self reloadData];
    _needRefresh = YES;
}

@end

