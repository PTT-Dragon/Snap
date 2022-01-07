//
//  CheckoutData.h
//  SFShop
//
//  Created by YouHui on 2022/1/7.
//

#import <Foundation/Foundation.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckoutInputData : NSObject

/// 初始化 CheckoutData ⚠️ productIds 个数需要和 productNums 一致
/// @param logisticsModeId <#logisticsModeId description#>
/// @param deliveryAddressId <#deliveryAddressId description#>
/// @param deliveryMode <#deliveryMode description#>
/// @param storeId <#storeId description#>
/// @param sourceType <#sourceType description#>
/// @param productIds productIds description
/// @param productNums <#productNums description#>
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
