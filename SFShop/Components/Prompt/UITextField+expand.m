//
//  UITextField+expand.m
//  SFShop
//
//  Created by 游挺 on 2021/12/30.
//

#import "UITextField+expand.h"
#import "NSString+Add.h"

#define defaultColor RGBColorFrom16(0x7b7b7b)
#define highlightColor RGBColorFrom16(0xCE0000)

@implementation UITextField (expand)


- (BOOL)textFieldState:(UITextFieldShowType)type editType:(UITextFieldEditType)editType labels:(NSArray <UILabel *>*)labels
{
    if (type == CHECKPHONETYPE) {
//        if ([self.text phoneTextCheck]) {
//            //手机规则符合
//            self.layer.borderColor = defaultColor.CGColor;
//            [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                obj.textColor = defaultColor;
//                obj.hidden = NO;
//            }];
//            return YES;
//        }else{
            if (editType == ENDEDITTYPE) {
                if ([self.text isEqualToString:@""]) {
                    self.layer.borderColor = defaultColor.CGColor;
                    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.textColor = defaultColor;
                        obj.hidden = YES;
                    }];
                }
            }else if (editType == BEGINEDITTYPE){
                if ([self.text isEqualToString:@""]) {
                    self.layer.borderColor = defaultColor.CGColor;
                    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.textColor = defaultColor;
                        obj.hidden = NO;
                    }];
                }
            }else{
                self.layer.borderColor = defaultColor.CGColor;
                [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.textColor = defaultColor;
                    obj.hidden = NO;
                }];
            }
//        }
    }else if (type == CHECKPASSWORDTYPE){
//        if ([self.text passwordTextCheck]) {
//            self.layer.borderColor = defaultColor.CGColor;
//            [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                obj.textColor = defaultColor;
//                obj.hidden = YES;
//            }];
//            return YES;
//        }else{
            if (editType == ENDEDITTYPE) {
                if ([self.text isEqualToString:@""]) {
                    self.layer.borderColor = defaultColor.CGColor;
                    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.textColor = defaultColor;
                        obj.hidden = YES;
                    }];
                }
            }else if (editType == BEGINEDITTYPE){
                if ([self.text isEqualToString:@""]) {
                    self.layer.borderColor = defaultColor.CGColor;
                    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.textColor = defaultColor;
                        obj.hidden = NO;
                    }];
                }
            }else{
                self.layer.borderColor = defaultColor.CGColor;
                [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.textColor = defaultColor;
                    obj.hidden = NO;
                }];
            }
//        }
    }else if (type == CHECKEMAILTYPE){
//        if ([self.text emailTextCheck]) {
//            self.layer.borderColor = defaultColor.CGColor;
//            [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                obj.textColor = defaultColor;
//                obj.hidden = YES;
//            }];
//            return YES;
//        }else{
            if (editType == ENDEDITTYPE) {
                if ([self.text isEqualToString:@""]) {
                    self.layer.borderColor = defaultColor.CGColor;
                    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.textColor = defaultColor;
                        obj.hidden = YES;
                    }];
                }
            }else if (editType == BEGINEDITTYPE){
                if ([self.text isEqualToString:@""]) {
                    self.layer.borderColor = defaultColor.CGColor;
                    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.textColor = defaultColor;
                        obj.hidden = NO;
                    }];
                }
            }else{
                self.layer.borderColor = defaultColor.CGColor;
                [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.textColor = defaultColor;
                    obj.hidden = NO;
                }];
            }
//        }
    }
    return ![self.text isEqualToString:@""];
}
- (void)endEditingWithlabels:(NSArray <UILabel *>*)labels
{
    
}
- (UITextField *)textFieldState:(UITextFieldShowType)type label:(UILabel *)label button:(UIButton *)button
{
    if (type == CHECKPHONETYPE) {
        if ([self.text phoneTextCheck]) {
            //手机规则符合
            self.layer.borderColor = defaultColor.CGColor;
            label.textColor = defaultColor;
        }else{
            self.layer.borderColor = highlightColor.CGColor;
            label.textColor = highlightColor;
        }
    }else if (type == CHECKPASSWORDTYPE){
        if ([self.text passwordTextCheck]) {
            self.layer.borderColor = defaultColor.CGColor;
            label.textColor = defaultColor;
        }else{
            self.layer.borderColor = highlightColor.CGColor;
            label.textColor = highlightColor;
        }
    }else if (type == CHECKEMAILTYPE){
        if ([self.text emailTextCheck]) {
            self.layer.borderColor = defaultColor.CGColor;
            label.textColor = defaultColor;
        }else{
            self.layer.borderColor = highlightColor.CGColor;
            label.textColor = highlightColor;
        }
    }
    return self;
}
- (BOOL)textFieldState:(UITextFieldShowType)type label:(UILabel *)label tipLabel:(UILabel *)tipLabel
{
    /**
     "EMAIL_ERROR_2" = "请输入正确的邮件地址";
     "LOGIN_INVALID_PHONE" = "请输入正确的手机号";
     REQUIREDTIP
     **/
    if (type == CHECKEMAILTYPE) {
        if ([self.text emailTextCheck]) {
            self.layer.borderColor = defaultColor.CGColor;
            label.textColor = defaultColor;
            label.hidden = YES;
            tipLabel.textColor = defaultColor;
            tipLabel.hidden = YES;
            return YES;
        }else{
            label.hidden = NO;
            self.layer.borderColor = highlightColor.CGColor;
            label.textColor = highlightColor;
            tipLabel.textColor = highlightColor;
            tipLabel.text = [self.text isEqualToString:@""] ? kLocalizedString(@"REQUIREDTIP"): kLocalizedString(@"EMAIL_ERROR_2");
            tipLabel.hidden = NO;
            return NO;
        }
    }else if (type == CHECKPHONETYPE){
        if ([self.text phoneTextCheck]) {
            label.hidden = YES;
            self.layer.borderColor = defaultColor.CGColor;
            label.textColor = defaultColor;
            tipLabel.textColor = defaultColor;
            tipLabel.hidden = YES;
            return YES;
        }else{
            label.hidden = NO;
            self.layer.borderColor = highlightColor.CGColor;
            label.textColor = highlightColor;
            tipLabel.textColor = highlightColor;
            tipLabel.hidden = NO;
            tipLabel.text = [self.text isEqualToString:@""] ? kLocalizedString(@"REQUIREDTIP"): kLocalizedString(@"LOGIN_INVALID_PHONE");
            return NO;
        }
    }else if (type == CHECKPASSWORDTYPE){
        if ([self.text passwordTextCheck]) {
            label.hidden = YES;
            self.layer.borderColor = defaultColor.CGColor;
            label.textColor = defaultColor;
            tipLabel.textColor = defaultColor;
            tipLabel.hidden = YES;
            return YES;
        }else{
            label.hidden = NO;
            self.layer.borderColor = highlightColor.CGColor;
            label.textColor = highlightColor;
            tipLabel.textColor = highlightColor;
            tipLabel.hidden = NO;
            return NO;
        }
    }
    
    self.layer.borderColor = [self.text isEqualToString:@""] ? highlightColor.CGColor: defaultColor.CGColor;
    tipLabel.textColor = highlightColor;
    tipLabel.hidden = ![self.text isEqualToString:@""];
    label.hidden = ![self.text isEqualToString:@""];
    label.textColor = [self.text isEqualToString:@""] ?highlightColor : defaultColor;
    return ![self.text isEqualToString:@""];
}
@end
