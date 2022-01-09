//
//  ProductCalcFeeModel.h
//  SFShop
//
//  Created by Jacue on 2021/12/5.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProductCalcFeeProductModel;
@protocol ProductCalcFeeStoreModel;

@interface NSString (ProductCalcFeeModel)
- (CGFloat)fee;
@end

@interface ProductCalcFeeProductModel: JSONModel

@property(nonatomic, strong) NSString *discountPrice;
@property(nonatomic, strong) NSString *offerCnt;
@property(nonatomic, strong) NSString *offerId;
@property(nonatomic, strong) NSString *offerPrice;
@property(nonatomic, strong) NSString *orderPrice;
@property(nonatomic, strong) NSString *platformCouponPrice;
@property(nonatomic, strong) NSString *productId;
@property(nonatomic, strong) NSString *salesPrice;
@property(nonatomic, strong) NSString *stock;
@property(nonatomic, strong) NSString *storeCampaignPrice;
@property(nonatomic, strong) NSString *storeCouponPrice;
@property(nonatomic, strong) NSString *vatPrice;

@end


@interface ProductCalcFeeStoreModel: JSONModel

@property(nonatomic, strong) NSString *discountPrice;
@property(nonatomic, strong) NSString *freeThreshold;
@property(nonatomic, strong) NSString *leftOfferPrice;
@property(nonatomic, strong) NSString *logisticsFee;
@property(nonatomic, strong) NSString *offerPrice;
@property(nonatomic, strong) NSString *orderPrice;
@property(nonatomic, strong) NSString *platformCouponPrice;
@property(nonatomic, strong) NSString *storeCampaignPrice;
@property(nonatomic, strong) NSString *storeCouponPrice;
@property(nonatomic, strong) NSString *storeId;
@property(nonatomic, strong) NSString *storeOrderPrice;
@property(nonatomic, strong) NSString *vatPrice;
@property(nonatomic, strong) NSArray <ProductCalcFeeProductModel *> <ProductCalcFeeProductModel> *products;


@end

@interface ProductCalcFeeModel : JSONModel

@property(nonatomic, strong) NSString *platformCouponPrice;
@property(nonatomic, strong) NSString *pointPrice;
@property(nonatomic, strong) NSString *storeCampaignPrice;
@property(nonatomic, strong) NSString *storeCouponPrice;
@property(nonatomic, strong) NSString *totalDiscount;
@property(nonatomic, strong) NSString *totalLogisticsFee;
@property(nonatomic, strong) NSString *totalOfferPrice;
@property(nonatomic, strong) NSString *totalPrice;
@property(nonatomic, strong) NSString *totalTax;
@property(nonatomic, strong) NSArray <ProductCalcFeeStoreModel *> <ProductCalcFeeStoreModel> *stores;

@end

NS_ASSUME_NONNULL_END
