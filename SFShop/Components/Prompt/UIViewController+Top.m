//
//  UIViewController+Top.m
//  SFShop
//
//  Created by YouHui on 2021/1/12.
//  Copyright © 2021年  YouHui. All rights reserved.
//

#import "UIViewController+Top.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@implementation UIViewController (NRChildViewControllerAPI)

+ (UIViewController *)sf_currentViewController {
    return [self sf_currentViewController:NO];
}

+ (UIViewController *)sf_currentViewController:(BOOL)fromKeyWindow {
    UIViewController *rootViewController = fromKeyWindow ? [UIApplication sharedApplication].keyWindow.rootViewController : [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *topVC = [self _sf_currentViewController:rootViewController];
    return topVC;
}

+ (UIViewController *)sf_topViewController {
    UIViewController *topVc = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] lastObject];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        topVc = nextResponder;
    } else {
        topVc = window.rootViewController;
    }
    topVc = [self _sf_currentViewController:topVc];
    return topVc;
}

// 获取当前VC，从指定VC开始查找
+ (UIViewController *)sf_currentViewControllerForRootVC:(UIViewController *)rootVc {
    return [self _sf_currentViewController:rootVc];
}

+ (UIViewController *)_sf_currentViewController:(UIViewController *)rootVc {
    UIViewController *topVC = [UIViewController sf_deepestPresentedViewControllerOf:rootVc];
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *tabSelectedVC = ((UITabBarController *)topVC).selectedViewController;
        if (tabSelectedVC) {
            topVC = [UIViewController sf_deepestPresentedViewControllerOf:tabSelectedVC];
        }
    }
    
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        UIViewController *navTopVC = ((UINavigationController *)topVC).topViewController;
        if (navTopVC) {
            topVC = [UIViewController sf_deepestPresentedViewControllerOf:navTopVC];
        }
    }
    
    if ([topVC isKindOfClass:NSClassFromString(@"NRHDAlertController")]) {
        UIViewController *childVc = topVC.childViewControllers.lastObject;
        if (childVc) {
            topVC = [self _sf_currentViewController:childVc];
        } else {
            topVC = [UIViewController sf_deepestPresentedViewControllerOf:topVC];
        }
    }
    return topVC;
}

+ (UIViewController *)sf_deepestPresentedViewControllerOf:(UIViewController *)viewController {
    UIViewController *deepestViewController = viewController;
    Class alertVC0 = [UIAlertController class];
    Class alertVC1 = NSClassFromString(@"_UIAlertShimPresentingViewController");
    while (YES) {
        UIViewController *presentedVC = deepestViewController.presentedViewController;
        if (presentedVC && ![presentedVC isKindOfClass:alertVC0] && ![presentedVC isKindOfClass:alertVC1]) {
            deepestViewController = deepestViewController.presentedViewController;
        } else {
            break;
        }
    }
    return deepestViewController;
}

@end
