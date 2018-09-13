//
//  ViewController.m
//  PopAnimation
//
//  Created by Hiên on 8/24/18.
//  Copyright © 2018 Hiên. All rights reserved.
//

#import "ZAPopViewController.h"
#import "ZACollectionViewCell.h"
#import "ZAPhotoViewController.h"

const NSInteger kNumOfItemsInRow = 3;
const CGFloat kSpacing = 1.0;

@interface ZAPopViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate, ZAPopAnimatorSourceDelegate, ZAPhotoViewDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *photos;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ZAPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    
}

- (void)initData {
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger i=0; i<24; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cat-%ld", (long)(i+1)]];
        if (image) {
            [photos addObject:image];
        }        
    }
    _photos = photos;
}

- (void)initView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.view.bounds.size.width - (kNumOfItemsInRow + 1))/kNumOfItemsInRow, (self.view.bounds.size.width - (kNumOfItemsInRow + 1))/kNumOfItemsInRow);
    layout.minimumLineSpacing = kSpacing;
    layout.minimumInteritemSpacing = kSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGRect rect = CGRectMake(0, _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - _segmentedControl.bounds.size.height - _segmentedControl.frame.origin.y);
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [_collectionView registerClass:[ZACollectionViewCell class] forCellWithReuseIdentifier:@"ZACell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor cyanColor];
    _collectionView.contentInset = UIEdgeInsetsMake(kSpacing, kSpacing, kSpacing, kSpacing);
    
    [self.view addSubview:_collectionView];;
    _timingFunctionType = kCAMediaTimingFunctionTypeZalo;
}

- (IBAction)segmentedControllAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _timingFunctionType = kCAMediaTimingFunctionTypeZalo;
    } else {
        _timingFunctionType = kCAMediaTimingFunctionTypeFacebook;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZACell" forIndexPath:indexPath];
    cell.imageView.image = [_photos objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.row;
    ZAPhotoViewController *vc = [[ZAPhotoViewController alloc] initWithPhotoItems:_photos atIndex:indexPath.row];
    vc.delegate = self;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    ZAPopPresentAnimator *presentAnimator = [[ZAPopPresentAnimator alloc] initWithTimingFunctionType:_timingFunctionType];
    presentAnimator.delegate = self;
    return presentAnimator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ZAPopDismissAnimator *dismissAnimator = [[ZAPopDismissAnimator alloc] initWithTimingFunctionType:_timingFunctionType];
    dismissAnimator.delegate = self;
    return dismissAnimator;
}


#pragma mark - ZAPopAnimatorSourceDelegate

- (CGRect)sourceFrameAtCurrentIndex {
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    CGRect sourceRect = [self.collectionView convertRect:attributes.frame toView:self.collectionView.superview];
    return sourceRect;
}

- (UIImageView *)imageViewAtCurrentIndex {
    return _imageView;
}

// Optional

- (void)presentTransitionBegan {
    ZACollectionViewCell *cell = (ZACollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    cell.imageView.hidden = YES;
}

- (void)dismissTransitionFinished {
    ZACollectionViewCell *cell = (ZACollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    cell.imageView.hidden = NO;
}


#pragma mark - ZAPhotoViewDelegate

- (void)dismissAtCurrentPage:(NSInteger)page {
//    _currentIndex = page;
}

- (void)dismissWithImageView:(UIImageView *)imageView {
    _imageView = imageView;
}

- (void)updateWhenChangePage:(NSInteger)previousPage atCurrentPage:(NSInteger)currentPage {
    ZACollectionViewCell *previousCell = (ZACollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:previousPage inSection:0]];
    previousCell.imageView.hidden = NO;
    ZACollectionViewCell *currentCell = (ZACollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:0]];
    currentCell.imageView.hidden = YES;
    _currentIndex = currentPage;
}

@end
