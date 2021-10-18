//
//  MBProgressHUD+Prompt.m
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import "MBProgressHUD+Prompt.h"
#import <objc/runtime.h>
#import "BCLoadingView.h"

@implementation MBProgressHUD (Prompt)
/**********************************************************************
 加载框 配置
 *********************************************************************/
/**
 加载框
 
 @param msg 提示的信息
 @param carrierView 承载视图
 @param animation 是否显示动画
 @param userInteractionEnabled YES：未加载完，用户无法点击，NO：未加载完，用户可以点击
 @return MBProgressHUD
 */
+ (MBProgressHUD *)showHudMsg:(NSString *)msg carrierView:(UIView *)carrierView animation:(BOOL)animation userInteractionEnabled:(BOOL)userInteractionEnabled {
    //无承载视图，直接返回
    if (!carrierView) {return nil;}

    //生成加载框
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:carrierView animated:YES];
    hud.userInteractionEnabled = userInteractionEnabled;
//    carrierView.userInteractionEnabled = userInteractionEnabled;
    
    //是否显示加载动画
    if (animation) {
        //生成一张空白图片（MB 会根据图片的大小来分配大小，所以一定得设置一个底图）
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading0"]];

        //把加载动画添加到空白图层上
        if (userInteractionEnabled) {
            [BCLoadingView loadingToView:imageView loadingViewType:BCLoadingViewTypeForbidUserInteraction messge:nil];
        } else {
            [BCLoadingView loadingToView:imageView loadingViewType:BCLoadingViewTypeAllowUserInteraction messge:nil];
        }
        
        //设置为自定义模式，并赋值动画视图
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = imageView;
    } else {
        hud.mode = MBProgressHUDModeText;
    }
   
    //处理需要显示的文字
    if (msg != nil) {
        hud.label.text = msg;
    }else{
        hud.label.text = @"正在加载";
    }
    return hud;
}

/**********************************************************************
 加载框 手动隐藏
 *********************************************************************/
+ (void)hideFromKeyWindow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD hideHUDForView:window animated:YES];
}

/**********************************************************************
 加载框，有动画加载
 *********************************************************************/
/**
 加载框（无法点击）
 
 @param msg 提示的信息
 */
+ (MBProgressHUD *)showHudMsg:(NSString *)msg {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return [self showHudMsg:msg carrierView:window animation:YES userInteractionEnabled:YES];
}

/**********************************************************************
 加载框，无动画加载，自动隐藏
 *********************************************************************/
/**
 自动消失的提示框

 @param msg 提示的信息
 */
+ (void )autoDismissShowHudMsg:(NSString *)msg {
    [MBProgressHUD autoDismissShowHudMsg:msg andDismissDuration:1];
}

/**
 自动消失的提示框
 
 @param msg 提示的信息
 @param duration 提示的总时间
 */
+ (void )autoDismissShowHudMsg:(NSString *)msg andDismissDuration:(NSInteger)duration {
    [MBProgressHUD hideFromKeyWindow];//先删除手动生成的进度条
    MBProgressHUD *hud = [MBProgressHUD showWithOutImageHudMsg:msg];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    [hud hideAnimated:YES afterDelay:duration];
}

/**
 自动消失的提示框
 
 @param msg 提示的信息
 @param completion 提示消失后的回调
 
 */
+ (void )autoDismissShowHudMsg:(NSString *)msg completion:(void(^)(void))completion {
    [MBProgressHUD autoDismissShowHudMsg:msg andDismissDuration:1 completion:completion];
}

/**
 自动消失的提示框
 
 @param msg 提示的信息
 @param duration 提示的总时间
 @param completion 提示消失后的回调

 */
+ (void )autoDismissShowHudMsg:(NSString *)msg andDismissDuration:(NSInteger)duration completion:(void(^)(void))completion {
    MBProgressHUD *hud = [MBProgressHUD showWithOutImageHudMsg:msg];
    hud.mode = MBProgressHUDModeText;
    hud.label.numberOfLines = 0;
    [hud hideAnimated:YES afterDelay:duration];
    hud.completionBlock = ^{
        completion();
    };
}

/**
 加载框（自动消失的提示框专用加载、无法点击）
 
 @param msg 提示的信息
 */
+ (MBProgressHUD *)showWithOutImageHudMsg:(NSString *)msg{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return [self showHudMsg:msg carrierView:window animation:NO userInteractionEnabled:YES];
}

@end