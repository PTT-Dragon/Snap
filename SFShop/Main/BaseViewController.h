//
//  BaseViewController.h
//  SFShop
//
//  Created by Jacue on 2021/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LoginInterceptor <NSObject>

@optional
- (BOOL)shouldCheckLoggedIn;

@end

@interface BaseViewController : UIViewController <LoginInterceptor>

@end

NS_ASSUME_NONNULL_END
