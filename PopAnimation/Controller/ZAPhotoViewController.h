//
//  ZAPhotoViewController.h
//  PopAnimation
//
//  Created by Hiên on 8/24/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZAPhotoViewDelegate

@optional

/**
 * Dismiss VC and send index of page of slide View
 **/

- (void)dismissAtCurrentPage:(NSInteger)page;

/**
 * Dismiss VC and send a imageView display in slideView
 **/

- (void)dismissWithImageView:(UIImageView *)imageView;

/**
 * Update data when slide change page
 **/

- (void)updateWhenChangePage:(NSInteger)previousPage atCurrentPage:(NSInteger)currentPage;

@end

@interface ZAPhotoViewController : UIViewController

@property (nonatomic) id<ZAPhotoViewDelegate> delegate;
- (instancetype)initWithPhotoItems:(NSArray<UIImage *> *)photos atIndex:(NSInteger)index;

@end
