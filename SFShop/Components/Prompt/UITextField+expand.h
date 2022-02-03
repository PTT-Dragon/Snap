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
    CHECKPASSWORDTYPE,
    CHECKMEAILORPHONE,
    ANOTHERTYPE
}UITextFieldShowType;

typedef enum:NSUInteger {
    EIDTTYPE,
    ENDEDITTYPE,
    BEGINEDITTYPE
}UITextFieldEditType;

@interface UITextField (expand)

- (BOOL)textFieldState:(UITextFieldShowType)type editType:(UITextFieldEditType)editType labels:(NSArray <UILabel *>*)labels;

- (BOOL)textFieldState:(UITextFieldShowType)type label:(UILabel *)label tipLabel:(UILabel *)tipLabel;

- (UITextField *)textFieldState:(UITextFieldShowType)type label:(UILabel *)label button:(UIButton *)button;
- (BOOL)systemPhoneCheck:(UITextFieldShowType)type editType:(UITextFieldEditType)editType;

@end

NS_ASSUME_NONNULL_END
