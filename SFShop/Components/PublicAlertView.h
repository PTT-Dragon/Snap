//
//  PublicAlertView.h
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//typedef void(^AlertBlock)(void);

@interface PublicAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title btnTitle:(NSString *)btnTitle block:(void (^)(void))block;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title btnTitle:(NSString *)btn1Title block:(void (^)(void))block1 btn2Title:(NSString *)btn2Title block2:(void (^)(void))block2;
@end

NS_ASSUME_NONNULL_END
