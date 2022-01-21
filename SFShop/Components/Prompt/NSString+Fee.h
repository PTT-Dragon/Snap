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

- (CGFloat)multiplyCurrencyFloat;

@end

NS_ASSUME_NONNULL_END
