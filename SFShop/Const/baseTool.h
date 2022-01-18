//
//  baseTool.h
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface baseTool : NSObject
+ (void)removeVCFromNavigation:(UIViewController *)vc;
+ (void)removeVCFromNavigationWithVCName:(NSString *)vcName currentVC:(UIViewController *)currentVC;
+ (void)removeVCFromNavigationWithVCNameArr:(NSArray <NSString *> *)vcName currentVC:(UIViewController *)currentVC;
+ (UIViewController *)getCurrentVC;
+ (void)updateCartNum;
@end

NS_ASSUME_NONNULL_END
