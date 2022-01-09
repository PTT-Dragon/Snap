//
//  CheckoutData.m
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import "CheckoutInputData.h"

@interface CheckoutInputData ()
@property (nonatomic, readwrite, strong) NSString *deliveryMode;//配送模型
@property (nonatomic, readwrite, strong) NSString *storeId;//商店id
@property (nonatomic, readwrite, strong) NSString *sourceType;//类型 LJGM 等参考H5
@property (nonatomic, readwrite, strong) NSArray<NSString *> *productIds;//产品id数组
@property (nonatomic, readwrite, strong) NSArray<NSNumber *> *productNums;//购买产品对应的数量
@end

@implementation CheckoutInputData

+ (instancetype)initWithLogisticsModeId:(NSString *)logisticsModeId
                      deliveryAddressId:(NSString *)deliveryAddressId
                           deliveryMode:(NSString *)deliveryMode
                                storeId:(NSString *)storeId
                             sourceType:(NSString *)sourceType
                             productIds:(NSArray<NSString *> *)productIds
                            productNums:(NSArray<NSNumber *> *)productNums {
    NSAssert(storeId.length > 0, @"storeId 不能为空");
    NSAssert(sourceType.length > 0, @"sourceType 不能为空");
    NSAssert(productIds.count > 0, @"productIds 不能为空");
    NSAssert(productNums.count > 0, @"productNums 不能为空");
    NSAssert(productNums.count == productIds.count, @"productNums 和 productIds 个数不一致");

    CheckoutInputData *data = [[CheckoutInputData alloc] init];
    data.logisticsModeId = logisticsModeId;
    data.deliveryAddressId = deliveryAddressId;
    data.deliveryMode = deliveryMode;
    data.storeId = storeId;
    data.sourceType = sourceType;
    data.productIds = productIds;
    data.productNums = productNums;
    return data;
}

- (NSMutableDictionary *)logisticsParams {
    NSMutableDictionary *params = self.outter;
    [params setObject:@[self.innner] forKey:@"stores"];
    return params;
}

- (NSMutableDictionary *)couponsAvailableParams {
    return self.logisticsParams;
}

- (NSDictionary *)calcfeeParams {
    NSMutableDictionary *params = self.outter;
    [params setObject:self.sourceType forKey:@"sourceType"];
    if (self.selUserPltCouponId.length > 0) {[params setObject:self.selUserPltCouponId forKey:@"selUserPltCouponId"];}
    
    NSMutableDictionary *store = self.innner;
    if (self.selUserCouponId.length > 0) {[store setObject:self.selUserCouponId forKey:@"selUserCouponId"];}
    if (self.logisticsModeId.length > 0) {[store setObject:self.logisticsModeId forKey:@"logisticsModeId"];}
    [params setObject:@[store] forKey:@"stores"];
    return params;
}

#pragma mark - Private
- (NSMutableDictionary *)outter {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.deliveryAddressId.length > 0) {[params setObject:self.deliveryAddressId forKey:@"deliveryAddressId"];}
    if (self.deliveryMode.length > 0) {[params setObject:self.deliveryMode forKey:@"deliveryMode"];}
    return params;
}

- (NSMutableDictionary *)innner {
    NSMutableDictionary *stores = [NSMutableDictionary dictionary];
    [stores setObject:self.storeId forKey:@"storeId"];
    NSMutableArray *products = [NSMutableArray array];
    for (int i = 0; i < self.productIds.count; i ++) {
        NSString *productId = self.productIds[i];
        NSNumber *offerCnt = self.productNums[i];
        if (productId.length > 0 && offerCnt.intValue > 0) {
            [products addObject:@{@"productId":productId,@"offerCnt":offerCnt}];
        }
    }
    [stores setObject:products forKey:@"products"];
    return stores;
}

@end
