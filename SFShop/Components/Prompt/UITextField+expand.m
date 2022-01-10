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
        if ([self.text phoneTextCheck]) {
            //手机规则符合
            self.layer.borderColor = defaultColor.CGColor;
            [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.textColor = defaultColor;
                obj.hidden = YES;
            }];
            return YES;            
        }else{
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
                self.layer.borderColor = highlightColor.CGColor;
                [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.textColor = highlightColor;
                    obj.hidden = NO;
                }];
            }
        }
    }else if (type == CHECKPASSWORDTYPE){
        if ([self.text passwordTextCheck]) {
            self.layer.borderColor = defaultColor.CGColor;
            [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.textColor = defaultColor;
                obj.hidden = YES;
            }];
            return YES;
        }else{
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
                self.layer.borderColor = highlightColor.CGColor;
                [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.textColor = highlightColor;
                    obj.hidden = NO;
                }];
            }
        }
    }else if (type == CHECKEMAILTYPE){
        if ([self.text emailTextCheck]) {
            self.layer.borderColor = defaultColor.CGColor;
            [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.textColor = defaultColor;
                obj.hidden = YES;
            }];
            return YES;
        }else{
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
                self.layer.borderColor = highlightColor.CGColor;
                [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.textColor = highlightColor;
                    obj.hidden = NO;
                }];
            }
        }
    }
    return NO;
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

@end
