//
//  ZAPhotoViewController.m
//  PopAnimation
//
//  Created by Hiên on 8/24/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZAPhotoViewController.h"
#import "ZAPopAnimatorDelegate.h"
#import "ZAPhotoCollectionViewCell.h"
#import <POP.h>

const CGFloat kPaddingOfSlideView = 10.0;

@interface ZAPhotoViewController () <ZAPopAnimatorDestinationDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) NSArray *photos;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGPoint startPoint;
@end

@implementation ZAPhotoViewController

- (instancetype)initWithPhotoItems:(NSArray<UIImage *> *)photos atIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _photos = photos;
        _currentPage = index;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

- (void)initView {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[ZAPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self.view addSubview:_collectionView];
    
    _closeButton = [[UIButton alloc] init];
    _closeButton.bounds = CGRectMake(0, 0, 100, 50);
    _closeButton.center = CGPointMake(self.view.bounds.size.width - 40, 40);
    [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(dismissVCButton:) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.hidden = YES;
    [self.view addSubview:_closeButton];
    
    [self addGestureRecognizers];
    
}


- (IBAction)dismissVCButton:(UIButton *)sender {
    [self dismissVC];
}

- (void)dismissVC {
    _closeButton.hidden = YES;
    [_delegate dismissAtCurrentPage:_currentPage];
    ZAPhotoCollectionViewCell *cell = (ZAPhotoCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0]];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [_delegate dismissWithImageView:cell.imageView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZAPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.imageView.image = [_photos objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)currentIndexInSlideView {
    return _currentPage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    if (_currentPage != page) {
        [_delegate updateWhenChangePage:_currentPage atCurrentPage:page];
        _currentPage = page;
    }
}

- (void)addGestureRecognizers {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_collectionView addGestureRecognizer:tap];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    ZAPhotoCollectionViewCell *cell = (ZAPhotoCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0]];
    
    CGPoint translation = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self handlePanBegan];
            _startPoint = cell.imageView.center;
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat percent = fabs(translation.y) / self.view.frame.size.height;
            cell.imageView.center = CGPointMake(_startPoint.x + translation.x, _startPoint.y + translation.y);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:1-percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            
            if (fabs(translation.y) > 200 || fabs(velocity.y) > 1000) {
                // dismiss VC
                [self dismissVC];
            } else {
                POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
                positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                positionAnimation.toValue = [NSValue valueWithCGPoint:self.startPoint];
                positionAnimation.duration = 0.1f;
                
                
                POPBasicAnimation *backColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBackgroundColor];
                backColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                backColorAnimation.toValue = (id)[UIColor blackColor].CGColor;
                backColorAnimation.duration = 0.1f;
                
                [cell.imageView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
                [self.view.layer pop_addAnimation:backColorAnimation forKey:@"backColorAnimation"];
            }
            
            break;
        }
        default:
            break;
            
    }
    
}

- (void)handlePanBegan {
    
}

- (IBAction)handleTap:(id)sender {
    _closeButton.hidden = !_closeButton.isHidden;
}

@end
