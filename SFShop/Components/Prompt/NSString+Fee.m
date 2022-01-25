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
    NSString *precisionStr = [NSString stringWithFormat:@"%%.%ldf", precision];//精度
    NSString *thousandthStr = [[NSString stringWithFormat:precisionStr,self.currencyFloat] thousandthFormat:precision];//千位分割显示
    NSString *fullStr = [NSString stringWithFormat:@"%@ %@",currency,thousandthStr];//添加货币符号
    if ([currency caseInsensitiveCompare:@"rp"] == NSOrderedSame) {//越南盾，替换"," == > '.'
        fullStr = [fullStr stringByReplacingOccurrencesOfString:@"," withString:@"."];
    }
    return fullStr;
}
@end
