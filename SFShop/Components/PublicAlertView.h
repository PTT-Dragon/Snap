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
@end

NS_ASSUME_NONNULL_END
