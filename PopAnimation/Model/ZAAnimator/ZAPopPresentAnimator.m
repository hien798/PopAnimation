//
//  ZAPopPresentAnimator.m
//  PopAnimation
//
//  Created by Hiên on 8/24/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZAPopPresentAnimator.h"
#import <POP.h>
#import "CAMediaTimingFunction+Custom.h"

@implementation ZAPopPresentAnimator

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
            self.duration = 0.3f;
            self.timingFunction = [CAMediaTimingFunction functionWithType:kCAMediaTimingFunctionTypeFacebook];
//            self.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45 :0.2 :0.2 :1];
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
    
    [_delegate presentTransitionBegan];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect sourceFrame = [_delegate sourceFrameAtCurrentIndex];
    CGPoint center = CGPointMake(sourceFrame.origin.x + sourceFrame.size.width/2, sourceFrame.origin.y + sourceFrame.size.height/2);
    if (toView.frame.size.width < toView.frame.size.height) {
        sourceFrame.size.height = sourceFrame.size.width*toView.frame.size.height/toView.frame.size.width;
    } else {
        sourceFrame.size.width = sourceFrame.size.height*toView.frame.size.width/toView.frame.size.height;
    }
    
    CGRect frame;
    
    UIView *container = transitionContext.containerView;
    
    frame = container.frame;
   
    [container addSubview:toView];
    
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(sourceFrame.size.width/frame.size.width, sourceFrame.size.height/frame.size.height)];
    scaleAnimation.duration = _duration;
    scaleAnimation.timingFunction = _timingFunction;

    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:center];
    positionAnimation.toValue = [NSValue valueWithCGPoint:container.center];
    positionAnimation.duration = _duration;
    positionAnimation.timingFunction = _timingFunction;

    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0.5);
    opacityAnimation.toValue = @(1.0);
    
    [scaleAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

@end
