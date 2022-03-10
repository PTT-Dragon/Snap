//
//  NSString+Fee.h
//  SFShop
//
//  Created by YouHui on 2022/1/12.
//

#import <Foundation/Foundation.h>
#import "SysParamsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Fee)

/// 根据配置自动换算金额保留位 （CGFloat 类型）
- (CGFloat)currencyFloat;

/// 根据配置自动换算金额保留位（带单位，字符串）
- (NSString *)currency;

/// 筛选等反向放大金额
- (CGFloat)multiplyCurrencyFloat;

/// 最小提现金额
- (NSString *)minWithdraw;

/// 手机号是否通过校验
- (BOOL)validatePhoneNumber;

/// 邮箱是否通过校验
- (BOOL)validateEmail;

//密码是否
- (BOOL)validatePassword;

@end

NS_ASSUME_NONNULL_END
