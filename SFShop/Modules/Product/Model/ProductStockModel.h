//
//  ProductStockModel.h
//  SFShop
//
//  Created by Jacue on 2022/1/22.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SingleProductStockModel;

@interface SingleProductStockModel : JSONModel

@property(nonatomic, strong) NSString *productId;
@property(nonatomic, strong) NSString *stock;
@property(nonatomic, strong) NSString *noStock;
@property(nonatomic, strong) NSString *minDeliveryDays;
@property(nonatomic, strong) NSString *maxDeliveryDays;
@property(nonatomic, strong) NSString *cmpStock;
@property(nonatomic, strong) NSString *cmpNoStock;

@end


@interface ProductStockModel : JSONModel

@property(nonatomic, strong) NSString *storeId;
@property(nonatomic, strong) NSArray <SingleProductStockModel *> <SingleProductStockModel> *products;

@end

NS_ASSUME_NONNULL_END
