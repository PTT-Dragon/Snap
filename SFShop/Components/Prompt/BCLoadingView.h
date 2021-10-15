//
//  BCLoadingView.h
//  bookclub
//
//  Created by 游辉 on 2018/8/22.
//  Copyright © 2018年 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

//加载框类型
typedef enum : NSUInteger {
    BCLoadingViewTypeAllowUserInteraction,      //允许用户操作
    BCLoadingViewTypeForbidUserInteraction,     //禁止用户操作
} BCLoadingViewType;

@interface BCLoadingView : UIView

/**
 从view中移除

 @param view view
 */
+ (BOOL)dismissFromView:(UIView *)view;

/**
 从window 移除
 */
+ (void)dismissFromWindow;

/**
 开始动画
 */
- (void)beginAnimation;

/**
 结束动画
 */
- (void)stopAnimation;

/**
 类方法，直接生成加载框
 1、添加到window层，
 2、允许用户点击
 3、默认无附加信息
 4、开始动画
 
 @return instancetype
 */
+ (instancetype)loadingAllowUser;

/**
 类方法，直接生成加载框
 1、添加到window层，
 2、不允许用户点击
 3、默认无附加信息
 4、开始动画
 
 @return instancetype
 */
+ (instancetype)loadingForbidUser;

/**
 类方法，直接生成加载框
 1、添加到window层
 2、允许用户点击
 3、使用附加的信息，可以为nil
 4、开始动画
 
 @param messge 信息
 @return instancetype
 */
+ (instancetype)loadingAllowUserWithMessge:(NSString *)messge;

/**
 类方法，直接生成加载框
 1、添加到window层
 2、不允许用户点击
 3、使用附加的信息，可以为nil
 4、开始动画
 
 @param messge 信息
 @return instancetype
 */
+ (instancetype)loadingForbidUserWithMessge:(NSString *)messge;

/**
 类方法，直接生成加载框
 1、添加到window层
 2、使用附加的 类型来判断是否能 让用户点击
 3、使用附加的信息，可以为nil
 4、开始动画

 @param loadingViewType 是否允许用户操作
 @param messge 信息
 @return instancetype
 */
+ (instancetype)loadingWithLoadingViewType:(BCLoadingViewType)loadingViewType messge:(NSString *)messge;

/**
 类方法，直接生成加载框
 1、添加到目标层
 2、使用附加的 类型来判断是否能 让用户点击
 3、默认无附加信息
 4、开始动画
 
 @param view 承载层
 @param loadingViewType 是否允许用户操作
 @return instancetype
 */
+ (instancetype)loadingToView:(UIView *)view loadingViewType:(BCLoadingViewType)loadingViewType;

/**
 类方法，直接生成加载框
 1、添加到目标层
 2、使用附加的 类型来判断是否能 让用户点击
 3、使用附加的信息，可以为nil
 4、开始动画

 @param view 承载层
 @param loadingViewType 是否允许用户操作
 @param messge 信息
 @return instancetype
 */
+ (instancetype)loadingToView:(UIView *)view loadingViewType:(BCLoadingViewType)loadingViewType messge:(NSString *)messge;

/**
 类方法，直接生成加载框
 1、添加到目标层
 2、使用附加的 类型来判断是否能 让用户点击
 3、使用附加的信息，可以为nil
 4、使用附加的尺寸来定制动画
 5、开始动画

 @param view 承载层
 @param loadingViewType 是否允许用户操作
 @param messge 信息
 @return instancetype
 */
+ (instancetype)loadingToView:(UIView *)view imageSize:(CGSize)imageSize loadingViewType:(BCLoadingViewType)loadingViewType messge:(NSString *)messge beginAnmation:(BOOL)animation;

/**
 初始化
 1、添加到目标层
 2、使用附加的 类型来判断是否能 让用户点击
 3、使用附加的信息，可以为nil
 4、使用附加的尺寸来定制动画
 5、开始动画

 @param imageSize 动画尺寸
 @param loadingViewType 是否允许用户操作
 @param carrierView 承载视图
 @param title 如果不传如title，只有动画，传入title,会和动画 一起居中 显示
 @return instancetype
 */
- (instancetype)initWithImageSize:(CGSize)imageSize loadingViewType:(BCLoadingViewType)loadingViewType carrierView:(UIView *)carrierView title:(NSString *)title;

/**
 线条宽度（默认为3）
 */
@property (nonatomic, readwrite, assign) CGFloat lineWidth;

/**
 设置加载线的颜色
 
 数据数量 为 0 ～ 2,超过三个只取前两个
 0: 默认的两个颜色
 1: 两个线的颜色全部为传入的颜色
 2: 两个线的颜色分别为传入的颜色
 ... 参考2
 */
@property (nonatomic, readwrite, strong) NSArray<UIColor *> *lineColorArray;

/**
 加载框类型
 
 BCLoadingViewTypeAllowUserInteraction,      //允许用户操作
 BCLoadingViewTypeForbidUserInteraction,     //禁止用户操作
 */
@property (nonatomic, readwrite, assign) BCLoadingViewType  loadingViewType;
@end
