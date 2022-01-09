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

@property (nonatomic, readwrite, strong) NSString *logisticsModeId;//物流id
@property (nonatomic, readwrite, strong) NSString *deliveryAddressId;//地址id

/// 初始化 CheckoutData ⚠️ productIds 个数需要和 productNums 一致
/// @param logisticsModeId 物流id
/// @param deliveryAddressId 地址id
/// @param deliveryMode 配送模式
/// @param storeId 商店id
/// @param sourceType 类型,固定的,参考H5
/// @param productIds 商品id数组
/// @param productNums 商品购买数量数组
+ (instancetype)initWithLogisticsModeId:(nullable NSString *)logisticsModeId
                      deliveryAddressId:(NSString *)deliveryAddressId
                           deliveryMode:(NSString *)deliveryMode
                                storeId:(NSString *)storeId
                             sourceType:(NSString *)sourceType
                             productIds:(NSArray *)productIds
                            productNums:(NSArray *)productNums;

- (NSMutableDictionary *)logisticsParams;
- (NSMutableDictionary *)calcfeeParams;
- (NSMutableDictionary *)couponsAvailableParams;
@end




NS_ASSUME_NONNULL_END
