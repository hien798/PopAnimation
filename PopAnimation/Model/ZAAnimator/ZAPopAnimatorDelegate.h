//
//  ZAPopAnimatorDelegate.h
//  PopAnimation
//
//  Created by Hiên on 8/27/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ZAPopAnimatorSourceDelegate

/**
 * Get source frame to initial a frame for zooming
 * Source frame get from presenting ViewController
 **/

- (CGRect)sourceFrameAtCurrentIndex;

/**
 * Get UIImageView to initial a frame when dismiss presented ViewController
 * imageView get from presented ViewController
 **/

- (UIImageView *)imageViewAtCurrentIndex;

@optional

/**
 * For prepare data or view before a transition begin
 **/

- (void)presentTransitionBegan;

/**
 * To do anything when dismiss transition animation completion
 **/

- (void)dismissTransitionFinished;

@end

@protocol ZAPopAnimatorDestinationDelegate

/**
 * Set current index for slideView
 **/

- (NSInteger)currentIndexInSlideView;

@end
