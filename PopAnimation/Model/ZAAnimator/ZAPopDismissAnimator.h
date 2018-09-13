//
//  ZAPopDismissAnimator.h
//  PopAnimation
//
//  Created by Hiên on 8/24/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZAPopAnimatorDelegate.h"
#import "CAMediaTimingFunction+Custom.h"

@interface ZAPopDismissAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) id<ZAPopAnimatorSourceDelegate> delegate;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) CAMediaTimingFunctionType timingFunctionType;
@property (nonatomic) CAMediaTimingFunction *timingFunction;
- (instancetype)initWithTimingFunctionType:(CAMediaTimingFunctionType)timingFunctionType;
@end
