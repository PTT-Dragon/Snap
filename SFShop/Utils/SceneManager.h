//
//  SceneManager.h
//  SFShop
//
//  Created by YouHui on 2022/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SceneManager : NSObject

/// 跳转到首页
+ (void)transToHome;

/// 跳转到指定Tabbar
/// @param index index
+ (void)transToTab:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
