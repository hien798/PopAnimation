//
//  ZAPopDismissAnimator.m
//  PopAnimation
//
//  Created by Hiên on 8/24/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZAPopDismissAnimator.h"
#import <POP.h>
#import "CAMediaTimingFunction+Custom.h"

@implementation ZAPopDismissAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timingFunctionType = kCAMediaTimingFunctionTypeZalo;
//        self.timingFunctionType = kZAPopTimingFunctionTypeFacebook;
    }
    return self;
}

- (instancetype)initWithTimingFunctionType:(CAMediaTimingFunctionType)timingFunctionType {
    self = [super init];
    if (self) {
        self.timingFunctionType = timingFunctionType;
    }
    return self;
}

- (void)setTimingFunctionType:(CAMediaTimingFunctionType)timingFunctionType {
    switch (timingFunctionType) {
        case kCAMediaTimingFunctionTypeFacebook:
        {
            self.duration = 0.4f;
            self.timingFunction = [CAMediaTimingFunction functionWithType:kCAMediaTimingFunctionTypeFacebook];
            break;
        }
        default:
        {
            self.duration = 0.45f;
            self.timingFunction = [CAMediaTimingFunction functionWithType:kCAMediaTimingFunctionTypeZalo];
            break;
        }
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *container = transitionContext.containerView;
    container.backgroundColor = [UIColor clearColor];
    
    CGRect sourceFrame = [_delegate sourceFrameAtCurrentIndex];
    UIImageView *imageView = [_delegate imageViewAtCurrentIndex];
    UIView *fromView = imageView ? imageView : [transitionContext viewForKey:UITransitionContextFromViewKey];
    fromView.contentMode = UIViewContentModeScaleAspectFill;
    CGRect fromFrame = fromView.frame;
    CGPoint fromCenter = fromView.center;
    
    if (imageView) {
        if (imageView.image.size.width/imageView.frame.size.width < imageView.image.size.height/imageView.frame.size.height) {
            // anh dung
            CGFloat ratio = imageView.frame.size.height/sourceFrame.size.height;
            CGFloat newWidth = ratio*sourceFrame.size.width;
            fromFrame.size.width = newWidth;
        } else {
            // anh ngang
            CGFloat ratio = imageView.frame.size.width/sourceFrame.size.width;
            CGFloat newHeight = ratio*sourceFrame.size.height;
            fromFrame.size.height = newHeight;
        }
    } else {
        if (imageView.frame.size.width < imageView.frame.size.height) {
            // view dung
            CGFloat ratio = fromView.frame.size.width/sourceFrame.size.width;
            CGFloat newHeight = ratio*sourceFrame.size.height;
            fromFrame.size.height = newHeight;
        } else {
            // view ngang
            CGFloat ratio = fromView.frame.size.height/sourceFrame.size.height;
            CGFloat newWidth = ratio*sourceFrame.size.width;
            fromFrame.size.width = newWidth;
        }
    }
    fromView.frame = fromFrame;
    fromView.center = fromCenter;
    
    CGPoint center = CGPointMake(sourceFrame.origin.x + sourceFrame.size.width/2, sourceFrame.origin.y + sourceFrame.size.height/2);
    
    [container addSubview:fromView];
    
    
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(sourceFrame.size.width/fromView.frame.size.width, sourceFrame.size.height/fromView.frame.size.height)];
    scaleAnimation.duration = _duration;
    scaleAnimation.timingFunction = _timingFunction;
    [scaleAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
        [self.delegate dismissTransitionFinished];
    }];
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:center];
    positionAnimation.duration = _duration;
    positionAnimation.timingFunction = _timingFunction;
    
    [fromView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [fromView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
}

@end
