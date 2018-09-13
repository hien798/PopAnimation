//
//  ZACollectionViewCell.m
//  Animation
//
//  Created by Hiên on 8/30/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZACollectionViewCell.h"

@implementation ZACollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.backgroundColor = [UIColor grayColor];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
