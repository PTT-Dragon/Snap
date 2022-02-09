//
//  MBProgressHUD+Prompt.h
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SpecialHud_None,    //不显示
    SpecialHud_Loading, //显示，加载中
    SpecialHud_Error,   //显示出错，可再次点击
} SpecialHud;
@interface MBProgressHUD (Prompt)
/**
 加载框
 
 @param msg 提示的信息
 @param carrierView 承载视图
 @param animation 是否显示动画
 @param userInteractionEnabled YES：未加载完，用户无法点击，NO：未加载完，用户可以点击
 @return MBProgressHUD
 */
+ (MBProgressHUD *)showHudMsg:(NSString *)msg carrierView:(UIView *)carrierView animation:(BOOL)animation userInteractionEnabled:(BOOL)userInteractionEnabled;

/**
 加载框（无法点击）
 
 @param msg 提示的信息
 */
+ (MBProgressHUD *)showHudMsg:(NSString *)msg;

/**
 加载框消失
 */
+ (void)hideFromKeyWindow;

/**
 自动消失的提示框
 
 @param msg 提示的信息
 @param duration 提示的总时间
 */
+ (void )autoDismissShowHudMsg:(NSString *)msg andDismissDuration:(NSInteger)duration;

/**
 自动消失的提示框
 
 @param msg 提示的信息
 */
+ (void )autoDismissShowHudMsg:(NSString *)msg;

/**
 自动消失的提示框
 
 @param msg 提示的信息
 @param completion 提示消失后的回调
 
 */
+ (void )autoDismissShowHudMsg:(NSString *)msg completion:(void(^)())completion;

/**
 自动消失的提示框
 
 @param msg 提示的信息
 @param duration 提示的总时间
 @param completion 提示消失后的回调
 
 */
+ (void )autoDismissShowHudMsg:(NSString *)msg andDismissDuration:(NSInteger)duration completion:(void(^)())completion;

/**
 显示在顶部的提示框
 
 @param msg 提示的信息
 
 */
+ (void)showTopTipMessage:(NSString *)msg;
+ (void)showTopErrotMessage:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
