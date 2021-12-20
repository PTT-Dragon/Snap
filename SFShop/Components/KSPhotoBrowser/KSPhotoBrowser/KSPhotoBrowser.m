//
//  KSPhotoBrowser.m
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import "KSPhotoBrowser.h"
#import "KSPhotoView.h"

#if __has_include(<YYWebImage/YYWebImage.h>)
#import <YYWebImage/YYWebImage.h>
#else
#import "YYWebImage.h"
#endif

static const NSTimeInterval kAnimationDuration = 0.3;
static const NSTimeInterval kSpringAnimationDuration = 0.5;

@interface KSPhotoBrowser () <UIScrollViewDelegate, UIViewControllerTransitioningDelegate, CAAnimationDelegate> {
    CGPoint _startLocation;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *photoItems;
@property (nonatomic, strong) NSMutableSet *reusableItemViews;
@property (nonatomic, strong) NSMutableArray *visibleItemViews;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIButton *deletedBtn;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL presented;
@property (nonatomic,strong) UIButton *backBtn;


@end

@implementation KSPhotoBrowser

// MAKR: - Initializer

+ (instancetype)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex {
    KSPhotoBrowser *browser = [[KSPhotoBrowser alloc] initWithPhotoItems:photoItems selectedIndex:selectedIndex];
    return browser;
}
+ (instancetype)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex bottomView:(UIView *)bottomView
{
    KSPhotoBrowser *browser = [[KSPhotoBrowser alloc] initWithPhotoItems:photoItems selectedIndex:selectedIndex bottomView:bottomView];
    return browser;
}

- (instancetype)init {
    NSAssert(NO, @"Use initWithMediaItems: instead.");
    return nil;
}

- (instancetype)initWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        _photoItems = [NSMutableArray arrayWithArray:photoItems];
        _currentPage = selectedIndex;
        
        _dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
        _pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
        _backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
        _loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        
        _reusableItemViews = [[NSMutableSet alloc] init];
        _visibleItemViews = [[NSMutableArray alloc] init];
    }
    return self;
}
- (instancetype)initWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex bottomView:(UIView *)bottomView{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        _photoItems = [NSMutableArray arrayWithArray:photoItems];
        _currentPage = selectedIndex;
        
        _dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
        _pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
        _backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
        _loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
        
        _reusableItemViews = [[NSMutableSet alloc] init];
        _visibleItemViews = [[NSMutableArray alloc] init];
        self.bottomView = bottomView;
    }
    return self;
}

// MARK: - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    
    CGRect rect = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    rect.origin.x -= kKSPhotoViewPadding;
    rect.size.width += 2 * kKSPhotoViewPadding;
    _scrollView = [[UIScrollView alloc] initWithFrame:rect];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    if (self.type == 2) {
        _backgroundView.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height - 50);
        _scrollView.frame = CGRectMake(0, 64, MainScreen_width, MainScreen_height - 114);
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 64)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bgView];
        
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreen_height - 50, MainScreen_width, 50)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bottomView];
        
//        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        finishBtn.backgroundColor = PublicBlueColor;
//        finishBtn.titleLabel.font = CHINESE_SYSTEM(15);
//        [finishBtn setTitleColor:PublicWhiteColor forState:0];
//        [finishBtn setTitle:[NSString stringWithFormat:@"完成%ld/9",_photoItems.count] forState:0];
//        finishBtn.frame = CGRectMake(MainScreen_width - 13 - AdaptedWidth(77.5), 7.5, AdaptedWidth(77.5), 35);
//        finishBtn.layer.cornerRadius = 5;
//        [finishBtn addTarget:self action:@selector(finishPhoto) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomView addSubview:finishBtn];
    }
    if (self.type == 3) {
        _backgroundView.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
        _scrollView.frame = CGRectMake(0, 64, MainScreen_width, MainScreen_height - 64);
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 64)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bgView];
        
        _deletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletedBtn setImage:[UIImage imageNamed:@"删除图片"] forState:0];
        _deletedBtn.frame = CGRectMake(MainScreen_width - 54, 20, 44, 44);
        [_deletedBtn addTarget:self action:@selector(deletedPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_deletedBtn];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"back"] forState:0];
        _backBtn.frame = CGRectMake(10, 20, 44, 44);
        [_backBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_backBtn];
        
    }
    if (self.type == 4) {
//        _backgroundView.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height - 50);
//        _scrollView.frame = CGRectMake(0, 64, MainScreen_width, MainScreen_height - 114);
        
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, navBarHei)];
        self.bgView.backgroundColor = PublicBlackColor;
        [self.view addSubview:self.bgView];
        
//        customLabel *label = [[customLabel alloc] initWithFrame:CGRectMake(70, statuBarHei, MainScreen_width - 140, 44) title:self.title font:CHINESE_MEDIUM(18) aligement:NSTextAlignmentCenter textColor:PublicWhiteColor num:1];
//        [self.bgView addSubview:label];
//
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setImage:[UIImage imageNamed:@"Back icon"] forState:0];
//        backBtn.frame = CGRectMake(10, statuBarHei, 44, 44);
//        [backBtn addTarget:self action:@selector(gobackAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.bgView addSubview:backBtn];
    }
    
    
    if (_pageindicatorStyle == KSPhotoBrowserPageIndicatorStyleDot) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-40, self.view.bounds.size.width, 20)];
        _pageControl.numberOfPages = _photoItems.count;
        _pageControl.currentPage = _currentPage;
        [self.view addSubview:_pageControl];
    } else {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.type == 4 ? MainScreen_height - 64:20, self.view.bounds.size.width, 44)];
        _pageLabel.textColor = self.type == 4 ? [UIColor whiteColor]: PublicBlackColor;
        _pageLabel.font = [UIFont systemFontOfSize:16];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        [self configPageLabelWithPage:_currentPage];
        [self.bgView addSubview:_pageLabel];
    }
    
    CGSize contentSize = CGSizeMake(rect.size.width * _photoItems.count, rect.size.height);
    _scrollView.contentSize = contentSize;
    
    [self addGestureRecognizer];
    
    CGPoint contentOffset = CGPointMake(_scrollView.frame.size.width*_currentPage, 0);
    [_scrollView setContentOffset:contentOffset animated:NO];
    if (contentOffset.x == 0) {
        [self scrollViewDidScroll:_scrollView];
    }
}
- (void)setBottomView:(UIView *)bottomView
{
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(300);
    }];
}
- (void)gobackAction
{
    [self dismissSelf];
}
- (void)dismissSelf
{
    [self dismissAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    YYWebImageManager *manager = [YYWebImageManager sharedManager];
    NSString *key = [manager cacheKeyForURL:item.imageUrl];
    if ([manager.cache getImageForKey:key withType:YYImageCacheTypeMemory]) {
        [self configPhotoView:photoView withItem:item];
    } else {
        photoView.imageView.image = item.thumbImage;
        [photoView resizeImageView];
    }
    
    CGRect endRect = photoView.imageView.frame;
    CGRect sourceRect;
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0 && systemVersion < 9.0) {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toCoordinateSpace:photoView];
    } else {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toView:photoView];
    }
    photoView.imageView.frame = sourceRect;
    
    if (_backgroundStyle == KSPhotoBrowserBackgroundStyleBlur) {
        [self blurBackgroundWithImage:[self screenshot] animated:NO];
    } else if (_backgroundStyle == KSPhotoBrowserBackgroundStyleBlurPhoto) {
        [self blurBackgroundWithImage:item.thumbImage animated:NO];
    }
    if (_bounces) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            _presented = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.frame = endRect;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [self configPhotoView:photoView withItem:item];
            _presented = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }];
    }
}

- (void)dealloc {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)finishPhoto
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishPhoto)]) {
        [self.delegate finishPhoto];
    }
}
// MARK: - Public

- (void)showFromViewController:(UIViewController *)vc {
    [vc presentViewController:self animated:NO completion:nil];
}

// MARK: - Private

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (KSPhotoView *)photoViewForPage:(NSUInteger)page {
    for (KSPhotoView *photoView in _visibleItemViews) {
        if (photoView.tag == page) {
            return photoView;
        }
    }
    return nil;
}

- (KSPhotoView *)dequeueReusableItemView {
    KSPhotoView *photoView = [_reusableItemViews anyObject];
    if (photoView == nil) {
        photoView = [[KSPhotoView alloc] initWithFrame:_scrollView.bounds];
    } else {
        [_reusableItemViews removeObject:photoView];
    }
    photoView.tag = -1;
    return photoView;
}

- (void)updateReusableItemViews {
    NSMutableArray *itemsForRemove = @[].mutableCopy;
    for (KSPhotoView *photoView in _visibleItemViews) {
        if (photoView.frame.origin.x + photoView.frame.size.width < _scrollView.contentOffset.x - _scrollView.frame.size.width ||
            photoView.frame.origin.x > _scrollView.contentOffset.x + 2 * _scrollView.frame.size.width) {
            [photoView removeFromSuperview];
            [self configPhotoView:photoView withItem:nil];
            [itemsForRemove addObject:photoView];
            [_reusableItemViews addObject:photoView];
        }
    }
    [_visibleItemViews removeObjectsInArray:itemsForRemove];
}

- (void)configItemViews {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5;
    for (NSInteger i = page - 1; i <= page + 1; i++) {
        if (i < 0 || i >= _photoItems.count) {
            continue;
        }
        KSPhotoView *photoView = [self photoViewForPage:i];
        if (photoView == nil) {
            photoView = [self dequeueReusableItemView];
            CGRect rect = _scrollView.bounds;
            rect.origin.x = i * _scrollView.bounds.size.width;
            photoView.frame = rect;
            photoView.tag = i;
            [_scrollView addSubview:photoView];
            [_visibleItemViews addObject:photoView];
        }
        if (photoView.item == nil && _presented) {
            KSPhotoItem *item = [_photoItems objectAtIndex:i];
            [self configPhotoView:photoView withItem:item];
        }
    }
    
    if (page != _currentPage && _presented && (page >= 0 && page < _photoItems.count)) {
        KSPhotoItem *item = [_photoItems objectAtIndex:page];
        if (_backgroundStyle == KSPhotoBrowserBackgroundStyleBlurPhoto) {
            [self blurBackgroundWithImage:item.thumbImage animated:YES];
        }
        _currentPage = page;
        if (_pageindicatorStyle == KSPhotoBrowserPageIndicatorStyleDot) {
            _pageControl.currentPage = page;
        } else {
            [self configPageLabelWithPage:_currentPage];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(ks_photoBrowser:didSelectItem:atIndex:)]) {
            [_delegate ks_photoBrowser:self didSelectItem:item atIndex:page];
        }
    }
}

- (void)dismissAnimated:(BOOL)animated {
    for (KSPhotoView *photoView in _visibleItemViews) {
        [photoView cancelCurrentImageLoad];
    }
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            item.sourceView.alpha = 1;
        }];
    } else {
        item.sourceView.alpha = 1;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)performRotationWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat angle = 0;
            if (_startLocation.x < self.view.frame.size.width/2) {
                angle = -(M_PI / 2) * (point.y / self.view.frame.size.height);
            } else {
                angle = (M_PI / 2) * (point.y / self.view.frame.size.height);
            }
            CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(0, point.y);
            CGAffineTransform transform = CGAffineTransformConcat(rotation, translation);
            photoView.imageView.transform = transform;
            
            double percent = 1 - fabs(point.y)/(self.view.frame.size.height/2);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            _backgroundView.alpha = percent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 200 || fabs(velocity.y) > 500) {
                [self showRotationCompletionAnimationFromPoint:point];
            } else {
                [self showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)performScaleWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            double percent = 1 - fabs(point.y)/(self.view.frame.size.height/2);
            percent = MAX(percent, 0);
            double s = MAX(percent, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x/s, point.y/s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            photoView.imageView.transform = CGAffineTransformConcat(translation, scale);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            _backgroundView.alpha = percent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 100 || fabs(velocity.y) > 500) {
                [self showDismissalAnimation];
            } else {
                [self showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)performSlideWithPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePanBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            photoView.imageView.transform = CGAffineTransformMakeTranslation(0, point.y);
            double percent = 1 - fabs(point.y)/(self.view.frame.size.height/2);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            _backgroundView.alpha = percent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 200 || fabs(velocity.y) > 500) {
                [self showSlideCompletionAnimationFromPoint:point];
            } else {
                [self showCancellationAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}

- (UIImage *)screenshot {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, [UIScreen mainScreen].scale);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)blurBackgroundWithImage:(UIImage *)image animated:(BOOL)animated {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *blurImage = [image yy_imageByBlurDark];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (animated) {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    _backgroundView.alpha = 0;
                } completion:^(BOOL finished) {
                    _backgroundView.image = blurImage;
                    [UIView animateWithDuration:kAnimationDuration animations:^{
                        _backgroundView.alpha = 1;
                    } completion:nil];
                }];
            } else {
                _backgroundView.image = blurImage;
            }
        });
    });
}

- (void)configPhotoView:(KSPhotoView *)photoView withItem:(KSPhotoItem *)item {
    [photoView setItem:item determinate:(_loadingStyle == KSPhotoBrowserImageLoadingStyleDeterminate)];
}

- (void)configPageLabelWithPage:(NSUInteger)page {
    _pageLabel.text = [NSString stringWithFormat:@"%ld / %ld", page+1, _photoItems.count];
}

- (void)handlePanBegin {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    [photoView cancelCurrentImageLoad];
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    [UIApplication sharedApplication].statusBarHidden = NO;
    photoView.progressLayer.hidden = YES;
    item.sourceView.alpha = 0;
}

// MARK: - Gesture Recognizer

- (void)addGestureRecognizer {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    [self.view addGestureRecognizer:longPress];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)didSingleTap:(UITapGestureRecognizer *)tap {
    if (self.type == 4) {
        return;
    }
    [self showDismissalAnimation];
}

- (void)didDoubleTap:(UITapGestureRecognizer *)tap {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    if (!item.finished) {
        return;
    }
    if (photoView.zoomScale > 1) {
        [photoView setZoomScale:1 animated:YES];
    } else {
        CGPoint location = [tap locationInView:self.view];
        CGFloat maxZoomScale = photoView.maximumZoomScale;
        CGFloat width = self.view.bounds.size.width / maxZoomScale;
        CGFloat height = self.view.bounds.size.height / maxZoomScale;
        [photoView zoomToRect:CGRectMake(location.x - width/2, location.y - height/2, width, height) animated:YES];
    }
}

- (void)didLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state != UIGestureRecognizerStateBegan) {
        return;
    }
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    UIImage *image = photoView.imageView.image;
    if (!image) {
        return;
    }
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        activityViewController.popoverPresentationController.sourceView = longPress.view;
        CGPoint point = [longPress locationInView:longPress.view];
        activityViewController.popoverPresentationController.sourceRect = CGRectMake(point.x, point.y, 1, 1);
    }
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)didPan:(UIPanGestureRecognizer *)pan {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    if (photoView.zoomScale > 1.1) {
        return;
    }
    
    switch (_dismissalStyle) {
        case KSPhotoBrowserInteractiveDismissalStyleRotation:
            [self performRotationWithPan:pan];
            break;
        case KSPhotoBrowserInteractiveDismissalStyleScale:
            [self performScaleWithPan:pan];
            break;
        case KSPhotoBrowserInteractiveDismissalStyleSlide:
            [self performSlideWithPan:pan];
            break;
        default:
            break;
    }
}

// MARK: - Animation

- (void)showCancellationAnimation {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    item.sourceView.alpha = 1;
    if (!item.finished) {
        photoView.progressLayer.hidden = NO;
    }
    if (_bounces && _dismissalStyle == KSPhotoBrowserInteractiveDismissalStyleScale) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.transform = CGAffineTransformIdentity;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [self configPhotoView:photoView withItem:item];
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.transform = CGAffineTransformIdentity;
            self.view.backgroundColor = [UIColor blackColor];
            _backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            [self configPhotoView:photoView withItem:item];
        }];
    }
}

- (void)showRotationCompletionAnimationFromPoint:(CGPoint)point {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    BOOL startFromLeft = _startLocation.x < self.view.frame.size.width / 2;
    BOOL throwToTop = point.y < 0;
    CGFloat angle, toTranslationY;
    if (throwToTop) {
        angle = startFromLeft ? (M_PI / 2) : -(M_PI / 2);
        toTranslationY = -self.view.frame.size.height;
    } else {
        angle = startFromLeft ? -(M_PI / 2) : (M_PI / 2);
        toTranslationY = self.view.frame.size.height;
    }
    
    CGFloat angle0 = 0;
    if (_startLocation.x < self.view.frame.size.width/2) {
        angle0 = -(M_PI / 2) * (point.y / self.view.frame.size.height);
    } else {
        angle0 = (M_PI / 2) * (point.y / self.view.frame.size.height);
    }
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(angle0);
    rotationAnimation.toValue = @(angle);
    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translationAnimation.fromValue = @(point.y);
    translationAnimation.toValue = @(toTranslationY);
    CAAnimationGroup *throwAnimation = [CAAnimationGroup animation];
    throwAnimation.duration = kAnimationDuration;
    throwAnimation.delegate = self;
    throwAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    throwAnimation.animations = @[rotationAnimation, translationAnimation];
    [throwAnimation setValue:@"throwAnimation" forKey:@"id"];
    [photoView.imageView.layer addAnimation:throwAnimation forKey:@"throwAnimation"];
    
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    CGAffineTransform translation = CGAffineTransformMakeTranslation(0, toTranslationY);
    CGAffineTransform transform = CGAffineTransformConcat(rotation, translation);
    photoView.imageView.transform = transform;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        _backgroundView.alpha = 0;
    } completion:nil];
}

- (void)showDismissalAnimation {
    KSPhotoItem *item = [_photoItems objectAtIndex:_currentPage];
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    [photoView cancelCurrentImageLoad];
    [UIApplication sharedApplication].statusBarHidden = NO;
    photoView.progressLayer.hidden = YES;
    item.sourceView.alpha = 0;
    CGRect sourceRect;
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0 && systemVersion < 9.0) {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toCoordinateSpace:photoView];
    } else {
        sourceRect = [item.sourceView.superview convertRect:item.sourceView.frame toView:photoView];
    }
    if (_bounces) {
        [UIView animateWithDuration:kSpringAnimationDuration delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:kNilOptions animations:^{
            photoView.imageView.frame = sourceRect;
            self.view.backgroundColor = [UIColor clearColor];
            _backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissAnimated:NO];
        }];
    } else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            photoView.imageView.frame = sourceRect;
            self.view.backgroundColor = [UIColor clearColor];
            _backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissAnimated:NO];
        }];
    }
}

- (void)showSlideCompletionAnimationFromPoint:(CGPoint)point {
    KSPhotoView *photoView = [self photoViewForPage:_currentPage];
    BOOL throwToTop = point.y < 0;
    CGFloat toTranslationY = 0;
    if (throwToTop) {
        toTranslationY = -self.view.frame.size.height;
    } else {
        toTranslationY = self.view.frame.size.height;
    }
    [UIView animateWithDuration:kAnimationDuration animations:^{
        photoView.imageView.transform = CGAffineTransformMakeTranslation(0, toTranslationY);
        self.view.backgroundColor = [UIColor clearColor];
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissAnimated:YES];
    }];
}

// MARK: - Animation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"id"] isEqualToString:@"throwAnimation"]) {
        [self dismissAnimated:YES];
    }
}

// MARK: - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateReusableItemViews];
    [self configItemViews];
}

- (void)deletedPhoto
{
    if (_delegate && [_delegate respondsToSelector:@selector(deletedPhotoWithIndex:)]) {
        [self showDismissalAnimation];
        [_delegate deletedPhotoWithIndex:_currentPage];
    }
}
@end
