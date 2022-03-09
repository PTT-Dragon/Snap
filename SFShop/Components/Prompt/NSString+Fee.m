//
//  NSString+Fee.m
//  SFShop
//
//  Created by YouHui on 2022/1/12.
//

#import "NSString+Fee.h"

@implementation NSString (Fee)
- (CGFloat)currencyFloat {
    NSInteger precision = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_PRECISION.intValue;
    return self.floatValue / pow(10, precision);
}

- (CGFloat)multiplyCurrencyFloat {
    NSInteger precision = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_PRECISION.intValue;
    return self.floatValue * pow(10, precision);
}

- (NSString *)currency {
    NSString *currency = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_DISPLAY;
    NSInteger precision = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_PRECISION.intValue;
    if (self.currencyFloat == 0) {precision = 0;}//当价格为0时, 不需要显示小数
    NSString *precisionStr = [NSString stringWithFormat:@"%%.%ldf", precision];//精度
    NSString *thousandthStr = [[NSString stringWithFormat:precisionStr,self.currencyFloat] thousandthFormat:precision];//千位分割显示
    NSString *fullStr = [NSString stringWithFormat:@"%@ %@",currency,thousandthStr];//添加货币符号
    if ([currency caseInsensitiveCompare:@"rp"] == NSOrderedSame) {//越南盾，替换"," == > '.'
        fullStr = [fullStr stringByReplacingOccurrencesOfString:@"," withString:@"."];
    }
    return fullStr;
}

- (BOOL)validatePhoneNumber {
    NSString *rule = SysParamsItemModel.sharedSysParamsItemModel.PHONE_REGULAR_RULE;
    if (!rule.length) {return YES;}//没获取到,统一返回YES
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
    return [predicate evaluateWithObject:self];
}

- (BOOL)validateEmail {
    NSString *rule = SysParamsItemModel.sharedSysParamsItemModel.EMAIL_REGULAR_RULE;
    if (!rule.length) {return YES;}//没获取到,统一返回YES
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
    return [predicate evaluateWithObject:self];
}
- (BOOL)validatePassword {
    NSString *rule = SysParamsItemModel.sharedSysParamsItemModel.PASSWORD_REGULAR_RULE;
//    rule = [rule stringByReplacingOccurrencesOfString:@"[\\\]" withString:@"\\[\\\]"];
    rule = @"(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[~!@#$%^&:;?,.(){}\\[\\]'*\\-_+=<>]).{0,}$";
    if (!rule.length) {return YES;}//没获取到,统一返回YES
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
    return [predicate evaluateWithObject:self];
}
@end
