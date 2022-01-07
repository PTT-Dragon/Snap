//
//  OrderLogisticsModel.m
//  SFShop
//
//  Created by MasterFly on 2021/12/14.
//

#import "OrderLogisticsModel.h"

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
    return [NSString stringWithFormat:@"%@ %.3f",self.monetary?self.monetary:@"",self.logisticsFee.floatValue / 1000.0];
}

- (NSString *)dateStr {
    return [NSString stringWithFormat:@"%@ %@-%@ %@", kLocalizedString(@"Est_arrival"), self.minDeliveryDays, self.maxDeliveryDays, kLocalizedString(@"Days")];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
