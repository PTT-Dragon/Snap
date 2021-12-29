//
//  forgotPasswordView.h
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum :NSUInteger{
    forgetType,
    resetType
}changePasswordType;

@interface forgotPasswordView : UIView
@property (nonatomic,assign) changePasswordType type;
@end

NS_ASSUME_NONNULL_END
