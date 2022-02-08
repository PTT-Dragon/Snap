//
//  OrderLogisticsModel.m
//  SFShop
//
//  Created by MasterFly on 2021/12/14.
//

#import "OrderLogisticsModel.h"
#import "NSString+Fee.h"

@implementation OrderLogisticsModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@interface OrderLogisticsItem ()
@property (nonatomic, readwrite, strong) NSString *priceStr;
@property (nonatomic, readwrite, strong) NSString *dateStr;
@end
@implementation OrderLogisticsItem

- (NSString *)priceStr {
    return [NSString stringWithFormat:@"%@",self.logisticsFee.currency];
}

- (NSString *)dateStr {
    return [NSString stringWithFormat:@"%@ %@-%@ %@", kLocalizedString(@"DELIVERY_RANGE"), self.minDeliveryDays, self.maxDeliveryDays, kLocalizedString(@"Days")];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
