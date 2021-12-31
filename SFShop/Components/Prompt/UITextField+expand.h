//
//  UITextField+expand.h
//  SFShop
//
//  Created by 游挺 on 2021/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum:NSUInteger {
    CHECKPHONETYPE,
    CHECKEMAILTYPE,
    CHECKPASSWORDTYPE
}UITextFieldShowType;

@interface UITextField (expand)

- (BOOL)textFieldState:(UITextFieldShowType)type labels:(NSArray <UILabel *>*)labels;

- (UITextField *)textFieldState:(UITextFieldShowType)type label:(UILabel *)label button:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
