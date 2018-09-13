//
//  CAMediaTimingFunction+Custom.h
//  PopAnimation
//
//  Created by Hiên on 9/5/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSUInteger, CAMediaTimingFunctionType) {
    kCAMediaTimingFunctionTypeZalo,
    kCAMediaTimingFunctionTypeFacebook
};

@interface CAMediaTimingFunction (Custom)

+ (instancetype)functionWithType:(CAMediaTimingFunctionType)type;

@end
