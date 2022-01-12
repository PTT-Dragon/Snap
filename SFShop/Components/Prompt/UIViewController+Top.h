//
//  UIViewController+Top.h
//  SFShop
//
//  Created by YouHui on 2021/1/12.
//  Copyright © 2021年  YouHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Top)

// 获取当前VC，从rootVc开始查找
+ (UIViewController *_Nullable)sf_currentViewController;

// 获取当前VC，从rootVc开始查找 是否直接从keywindow开始
+ (UIViewController *_Nullable)sf_currentViewController:(BOOL)fromKeyWindow;

// 获取顶层VC，从window开始查找
+ (UIViewController *_Nullable)sf_topViewController;

// 获取当前VC，从指定VC开始查找
+ (UIViewController *_Nonnull)sf_currentViewControllerForRootVC:(UIViewController *_Nullable)rootVc;


@end
