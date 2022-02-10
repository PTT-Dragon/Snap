//
//  BCLoadingView.m
//  bookclub
//
//  Created by 游辉 on 2018/8/22.
//  Copyright © 2018年 luke.chen. All rights reserved.
//

#import "BCLoadingView.h"

@interface BCLoadingView ()
@property (nonatomic, readwrite, strong) UIView * maskView;                     //整个遮罩层，和承载视图位置大小一致，决定能否响应用户操作
@property (nonatomic, readwrite, strong) UILabel * titleLabel;                  //标题
@property (nonatomic, readwrite, strong) UIView * anmaitionBgView;              //动画的背景
@property (nonatomic, readwrite, strong) CAShapeLayer * firstCircleLineLayer;   //动画第一部分
@property (nonatomic, readwrite, strong) CAShapeLayer * secondCircleLineLayer;  //动画第二部分
@property (nonatomic, readwrite, weak) UIView * carrierView;                    //载体
@property (nonatomic, readwrite, copy) NSString * title;                        //标题
@property (nonatomic, readwrite, assign) CGSize imageSize;                      //图的尺寸
@end

@implementation BCLoadingView

+ (BOOL)dismissFromView:(UIView *)view {
    //从view中移除
    if (!view) {return NO;}
    BOOL ret = NO;
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[self class]]) {
            BCLoadingView *loading = obj;
            [loading removeFromSuperview];
            [loading.maskView removeFromSuperview];
            ret = YES;
        }
    }
    return ret;
}

+ (void)dismissFromWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //从window 移除
    [self dismissFromView:keyWindow];
}

+ (instancetype)loadingAllowUser {
    return [self loadingAllowUserWithMessge:nil];
}

+ (instancetype)loadingForbidUser {
    return [self loadingForbidUserWithMessge:nil];
}

+ (instancetype)loadingAllowUserWithMessge:(NSString *)messge {
    return [self loadingWithLoadingViewType:BCLoadingViewTypeAllowUserInteraction messge:messge];
}

+ (instancetype)loadingForbidUserWithMessge:(NSString *)messge {
    return [self loadingWithLoadingViewType:BCLoadingViewTypeForbidUserInteraction messge:messge];
}

+ (instancetype)loadingWithLoadingViewType:(BCLoadingViewType)loadingViewType messge:(NSString *)messge {
    //无window 时直接返回nil
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        return nil;
    }
    
    //加载
    return [self loadingToView:keyWindow loadingViewType:loadingViewType messge:messge];
}

+ (instancetype)loadingToView:(UIView *)view loadingViewType:(BCLoadingViewType)loadingViewType {
    return [self loadingToView:view loadingViewType:loadingViewType messge:nil];
}

+ (instancetype)loadingToView:(UIView *)view loadingViewType:(BCLoadingViewType)loadingViewType messge:(NSString *)messge  {
   return [BCLoadingView loadingToView:view imageSize:CGSizeMake(43, 43) loadingViewType:loadingViewType messge:messge beginAnmation:YES];
}

+ (instancetype)loadingToView:(UIView *)view imageSize:(CGSize)imageSize loadingViewType:(BCLoadingViewType)loadingViewType messge:(NSString *)messge beginAnmation:(BOOL)animation {
    //加载框
    BCLoadingView *load = [[BCLoadingView alloc] initWithImageSize:imageSize loadingViewType:loadingViewType carrierView:view title:messge];
    if (animation) {
        [load beginAnimation];
    }
    return load;
}

- (instancetype)initWithImageSize:(CGSize)imageSize loadingViewType:(BCLoadingViewType)loadingViewType carrierView:(UIView *)carrierView title:(NSString *)title {
    _title = title;
    _carrierView = carrierView;
    _imageSize = imageSize;
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = 3;
        self.loadingViewType = loadingViewType;       //默认不允许点击
        
        [carrierView addSubview:self.maskView];
        [carrierView addSubview:self];
        [self addSubview:self.anmaitionBgView];
        [self addSubview:self.titleLabel];
        [self.anmaitionBgView.layer addSublayer:self.firstCircleLineLayer];
        [self.anmaitionBgView.layer addSublayer:self.secondCircleLineLayer];
        [self layout];
    }
    return self;
}

#pragma mark - Public
- (void)beginAnimation {
    self.firstCircleLineLayer.hidden = NO;
    self.secondCircleLineLayer.hidden = NO;
    [self.firstCircleLineLayer addAnimation:[self strokeAnimation] forKey:@"firstStrokeAnimation"];
    [self.secondCircleLineLayer addAnimation:[self strokeAnimation] forKey:@"secondStrokeAnimation"];
    [self.anmaitionBgView.layer addAnimation:[self rotationAnimation] forKey:@"rotationAnimation"];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self stopAnimation];
//    });
}

- (void)stopAnimation {
    self.firstCircleLineLayer.hidden = YES;
    self.secondCircleLineLayer.hidden = YES;
    [self.firstCircleLineLayer removeAnimationForKey:@"firstStrokeAnimation"];
    [self.secondCircleLineLayer removeAnimationForKey:@"secondStrokeAnimation"];
    [self.anmaitionBgView.layer removeAnimationForKey:@"rotationAnimation"];
    [self.maskView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - Layout
- (void)layout {
    CGFloat titleWidth = [self.titleLabel.text calWidthWithLabel:self.titleLabel];//标题宽度
    CGFloat imageWidth = self.imageSize.width;                                    //动画宽度
    CGFloat imageHeight = self.imageSize.height;                                  //动画高度
    CGFloat space = (self.title && ![self.title isEqualToString:@""])?10:0;       //标题和动画之间的间隙
    CGFloat carrierWidth = CGRectGetWidth(self.carrierView.frame);                //承载视图的宽度
    CGFloat carrierHeight = CGRectGetHeight(self.carrierView.frame);              //承载视图的高度
    CGFloat totalWidth = titleWidth + space + imageWidth;                         //总宽度
    
    //如果总宽度大于承载视图的宽度，那么优先扣除 titleWidth ，且让totalWidth == carrierWidth
    if (totalWidth > carrierWidth) {
        totalWidth = carrierWidth;
        titleWidth = totalWidth - imageWidth - space;
    }
    
    //如果高度超过承载视图
    if (imageHeight > carrierHeight) {
        imageHeight = carrierHeight;
        imageWidth = carrierHeight;
    }
    
    //遮罩
    self.maskView.frame = self.carrierView.bounds;
    
    //自身位置，大小
    self.center = self.maskView.center;
    self.bounds = CGRectMake(0, 0, totalWidth, imageHeight);
    
    //动画背景视图
    self.anmaitionBgView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    
    //第一个半圈的形状大小
    UIBezierPath *firstCircleLinePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.anmaitionBgView.frame) / 2.0, CGRectGetHeight(self.anmaitionBgView.frame) / 2.0) radius:(CGRectGetWidth(self.anmaitionBgView.frame) - self.lineWidth) / 2.0  startAngle:- 0.25 * M_PI endAngle:0.75 * M_PI clockwise:YES];
    self.firstCircleLineLayer.path = firstCircleLinePath.CGPath;
    
    //第二个半圈的形状大小
    UIBezierPath *secondCircleLinepath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.anmaitionBgView.frame) / 2.0, CGRectGetHeight(self.anmaitionBgView.frame) / 2.0) radius:(CGRectGetWidth(self.anmaitionBgView.frame) - self.lineWidth) / 2.0  startAngle:0.75 * M_PI endAngle:1.75 * M_PI clockwise:YES];
    self.secondCircleLineLayer.path = secondCircleLinepath.CGPath;
    
    //标题
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.anmaitionBgView.frame) + space, 0, titleWidth, CGRectGetHeight(self.frame));
}

#pragma mark - Get & Set
- (void)setLoadingViewType:(BCLoadingViewType)loadingViewType {
    _loadingViewType = loadingViewType;
    switch (_loadingViewType) {
        case BCLoadingViewTypeAllowUserInteraction:
            self.maskView.userInteractionEnabled = NO;      //透传点击事件到父视图
            break;
        case BCLoadingViewTypeForbidUserInteraction:
            self.maskView.userInteractionEnabled = YES;     //拦截点击事件，并不处理
            break;
        default:
            break;
    }
}

- (void)setLineColorArray:(NSArray *)lineColorArray {
    _lineColorArray = lineColorArray;
    if (_lineColorArray.count == 1) {           //数组中只有一种颜色
        UIColor *color = _lineColorArray.firstObject;
        if ([color isKindOfClass:[UIColor class]]) {
            self.firstCircleLineLayer.strokeColor = color.CGColor;
            self.secondCircleLineLayer.strokeColor = color.CGColor;
        }
    } else if (_lineColorArray.count >= 2) {    //数组中有两种或更多种颜色
        UIColor *firstColor = _lineColorArray.firstObject;
        if ([firstColor isKindOfClass:[UIColor class]]) {
            self.firstCircleLineLayer.strokeColor = firstColor.CGColor;
        }
        
        UIColor *secondColor = _lineColorArray[1];
        if ([secondColor isKindOfClass:[UIColor class]]) {
            self.secondCircleLineLayer.strokeColor = secondColor.CGColor;
        }
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.firstCircleLineLayer.lineWidth = _lineWidth;
    self.secondCircleLineLayer.lineWidth = _lineWidth;
    
    //第一个半圈的形状大小
    UIBezierPath *firstCircleLinePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.anmaitionBgView.frame) / 2.0, CGRectGetHeight(self.anmaitionBgView.frame) / 2.0) radius:(CGRectGetWidth(self.anmaitionBgView.frame) - self.lineWidth) / 2.0  startAngle:- 0.25 * M_PI endAngle:0.75 * M_PI clockwise:YES];
    self.firstCircleLineLayer.path = firstCircleLinePath.CGPath;
    
    //第二个半圈的形状大小
    UIBezierPath *secondCircleLinepath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.anmaitionBgView.frame) / 2.0, CGRectGetHeight(self.anmaitionBgView.frame) / 2.0) radius:(CGRectGetWidth(self.anmaitionBgView.frame) - self.lineWidth) / 2.0  startAngle:0.75 * M_PI endAngle:1.75 * M_PI clockwise:YES];
    self.secondCircleLineLayer.path = secondCircleLinepath.CGPath;
}

- (CABasicAnimation *)strokeAnimation {
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.duration = 0.8;
    strokeAnimation.fromValue = @(1.0);
    strokeAnimation.toValue = @(0);
    strokeAnimation.removedOnCompletion = NO;
    strokeAnimation.beginTime = 0.0;
    strokeAnimation.autoreverses = YES;
    strokeAnimation.repeatCount = NSIntegerMax;
    strokeAnimation.fillMode = kCAFillModeForwards;
    return strokeAnimation;
}

- (CABasicAnimation *)rotationAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 0.8;
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(2 * M_PI);
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.beginTime = 0.0;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.repeatCount = NSIntegerMax;
    return rotationAnimation;
}

- (CAShapeLayer *)firstCircleLineLayer {
    if (_firstCircleLineLayer == nil) {
        _firstCircleLineLayer = [CAShapeLayer layer];
        _firstCircleLineLayer.strokeColor = [UIColor systemOrangeColor].CGColor;
        _firstCircleLineLayer.fillColor = [UIColor clearColor].CGColor;
        _firstCircleLineLayer.lineCap = @"round";
        _firstCircleLineLayer.lineWidth = self.lineWidth;
    }
    return _firstCircleLineLayer;
}

- (CAShapeLayer *)secondCircleLineLayer {
    if (_secondCircleLineLayer == nil) {
        _secondCircleLineLayer = [CAShapeLayer layer];
        _secondCircleLineLayer.strokeColor = [UIColor jk_colorWithHexString:@"#4C4948"].CGColor;
        _secondCircleLineLayer.fillColor = [UIColor clearColor].CGColor;
        _secondCircleLineLayer.lineCap = @"round";
        _secondCircleLineLayer.lineWidth = self.lineWidth;
    }
    return _secondCircleLineLayer;
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor clearColor];
    }
    return _maskView;
}

- (UIView *)anmaitionBgView {
    if (_anmaitionBgView == nil) {
        _anmaitionBgView = [[UIView alloc] init];
        _anmaitionBgView.backgroundColor = [UIColor clearColor];
    }
    return _anmaitionBgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = kFontRegular(17);
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#4C4948"];
        _titleLabel.text = self.title;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
@end
