//
//  ZAPhotoCollectionViewCell.m
//  Animation
//
//  Created by Hiên on 8/30/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZAPhotoCollectionViewCell.h"

@implementation ZAPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat margin = 2.0;
        CGFloat width = frame.size.width - 2*margin;
        CGFloat height = frame.size.height - 2*margin;
        CGRect rect = CGRectMake(margin, margin, width, height);
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
