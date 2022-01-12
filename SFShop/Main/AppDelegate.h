//
//  AppDelegate.h
//  SFShop
//
//  Created by MasterFly on 2021/9/22.
//

#import <UIKit/UIKit.h>
#import "MainTabViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, readwrite, strong) UIWindow *window;

@property (nonatomic, strong) MainTabViewController *tabVC;

@end

