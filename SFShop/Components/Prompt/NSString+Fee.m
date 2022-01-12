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
    if (precision > 0) {
        return self.floatValue / pow(10, precision);
    }
    return self.floatValue / 1000.0;
}

- (NSString *)currency {
    NSString *currency = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_DISPLAY;
    NSInteger precision = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_PRECISION.intValue;
    NSString *precisionStr = [NSString stringWithFormat:@"%@ %%.%ldf",currency, precision];
    NSString *result = [NSString stringWithFormat:precisionStr,self.currencyFloat];
    return result;
}
@end
