//
//  CAMediaTimingFunction+Custom.m
//  PopAnimation
//
//  Created by Hiên on 9/5/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "CAMediaTimingFunction+Custom.h"

@implementation CAMediaTimingFunction (Custom)

+ (instancetype)functionWithType:(CAMediaTimingFunctionType)type {
    switch (type) {
        case kCAMediaTimingFunctionTypeFacebook:
        {
            return [CAMediaTimingFunction functionWithControlPoints:0.45 :0.2 :0.2 :1];
            break;
        }
        case kCAMediaTimingFunctionTypeZalo:
        {
            return [CAMediaTimingFunction functionWithControlPoints:0.15 :0.7 :0.3 :1.2];
            break;
        }
        default:
        {
            return [CAMediaTimingFunction functionWithControlPoints:0.15 :0.7 :0.3 :1.2];
            break;
        }
    }
}

@end
