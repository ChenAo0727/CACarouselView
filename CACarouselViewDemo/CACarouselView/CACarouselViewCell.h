//
//  CACarouselViewCell.h
//  CACarouselViewDemo
//
//  Created by chenao on 15/11/19.
//  Copyright © 2015年 chenao. All rights reserved.
//
#define CACAROUSELVIEW_CELL_IDENTIFY @"CACarouselViewCell"
#import <UIKit/UIKit.h>

@interface CACarouselViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *currentImageView;

@end
