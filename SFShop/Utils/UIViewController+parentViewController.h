//
//  UIViewController+parentViewController.h
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (parentViewController)

/**
 获取当前最顶层的UINavigationController

 @return UINavigationController
 */
+ (UINavigationController *)currentNavigationController;

/**
 获取当前最顶层的UINavigationController的最顶层的viewcontroller

 @return UIViewController
 */
+ (UIViewController *)currentTopViewController;


@end

NS_ASSUME_NONNULL_END
