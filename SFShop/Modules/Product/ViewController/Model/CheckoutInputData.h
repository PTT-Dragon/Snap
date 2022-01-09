//
//  CheckoutData.h
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import <Foundation/Foundation.h>
#import "ProductDetailModel.h"
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckoutInputData : NSObject
#pragma mark - 可选参数
@property (nonatomic, readwrite, strong, nullable) NSString *deliveryAddressId;//地址id
@property (nonatomic, readwrite, strong, nullable) NSString *logisticsModeId;//物流id
@property (nonatomic, readwrite, strong, nullable) NSString *selUserCouponId;//店铺优惠券id
@property (nonatomic, readwrite, strong, nullable) NSString *selUserPltCouponId;//平台优惠券id

/// 初始化 CheckoutData ⚠️ productIds 个数需要和 productNums 一致
/// @param deliveryAddressId 地址id
/// @param deliveryMode 配送模式
/// @param storeId 商店id
/// @param sourceType 类型,固定的,参考H5
/// @param productIds 商品id数组
/// @param productNums 商品购买数量数组
+ (instancetype)initWithDeliveryAddressId:(NSString *)deliveryAddressId
                             deliveryMode:(NSString *)deliveryMode
                                  storeId:(NSString *)storeId
                               sourceType:(NSString *)sourceType
                               productIds:(NSArray<NSString *> *)productIds
                              productNums:(NSArray<NSNumber *> *)productNums
                             inCmpIdLists:(nullable NSArray<NSNumber *> *)inCmpIdLists;

- (NSMutableDictionary *)logisticsParams;
- (NSMutableDictionary *)calcfeeParams;
- (NSMutableDictionary *)couponsAvailableParams;
@end




NS_ASSUME_NONNULL_END
