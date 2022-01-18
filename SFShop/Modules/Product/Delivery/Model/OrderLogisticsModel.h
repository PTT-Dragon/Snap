//
//  OrderLogisticsModel.h
//  SFShop
//
//  Created by MasterFly on 2021/12/14.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OrderLogisticsItem;
@interface OrderLogisticsItem : JSONModel
@property (nonatomic, readwrite, strong) NSString *logisticsModeId;//配送模式id
@property (nonatomic, readwrite, strong) NSString *logisticsModeName;//配送名称
@property (nonatomic, readwrite, strong) NSString *logisticsFee;//配送价格
@property (nonatomic, readwrite, strong) NSString *minDeliveryDays;//送达最小天数
@property (nonatomic, readwrite, strong) NSString *maxDeliveryDays;//送达最大天数

//自定义,是否被选中
@property (nonatomic, readwrite, assign) BOOL isSelected;
@property (nonatomic, readwrite, strong) NSString *monetary;//货币
@property (nonatomic, readonly, strong) NSString *priceStr;//价格字符串
@property (nonatomic, readonly, strong) NSString *dateStr;//配送日期

@end

@interface OrderLogisticsModel : JSONModel

@property (nonatomic, readwrite, strong) NSString *storeId;//商店id
@property (nonatomic, readwrite, strong) NSArray<OrderLogisticsItem *> <OrderLogisticsItem> *logistics;//配送方式数组
@end

NS_ASSUME_NONNULL_END
