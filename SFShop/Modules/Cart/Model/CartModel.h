//
//  CartModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/31.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CartListModel;
@protocol CartItemModel;
@protocol ProdSpcAttrsModel;
@protocol CartCampaignsModel;


@interface ProdSpcAttrsModel : JSONModel
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy) NSString *attrName;
@property (nonatomic,copy) NSString *attrId;
@end

@interface CartItemModel : JSONModel
@property (nonatomic,copy) NSString *shoppingCartId;
@property (nonatomic,copy) NSString *contactChannel;
@property (nonatomic,copy) NSString *offerId;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *storeCouponFlag;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *isSelected;
@property (nonatomic,copy) NSString *addon;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *cutRate;
@property (nonatomic,copy) NSString *noStock;
@property (nonatomic,copy) NSString *campaignId;
@property (nonatomic,copy) NSString *isCollection;
@property (nonatomic,copy) NSString *deliveryMode;
@property (nonatomic,assign) NSInteger maxBuyCount;
@property (nonatomic,assign) NSInteger stock;
@property (nonatomic,assign) double unitPrice;
@property (nonatomic,assign) double salesPrice;
@property (nonatomic,assign) double marketPrice;
@property (nonatomic,assign) double reducePrice;
@property (nonatomic,assign) double discountPrice;
@property (nonatomic,assign) double vatPrice;
@property (nonatomic,assign) double orderPrice;
@property (nonatomic,assign) double offerPrice;
@property (nonatomic,assign) double storeCouponPrice;
@property (nonatomic,assign) double platformCouponPrice;
@property (nonatomic,strong) NSArray <ProdSpcAttrsModel> *prodSpcAttrs;
@end

@interface CartCampaignsModel : JSONModel
@property (nonatomic,strong) NSArray <CartItemModel> *shoppingCarts;
@end


@interface CartListModel : JSONModel
@property (nonatomic,copy) NSString *storeId;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *logoUrl;
@property (nonatomic,copy) NSString *selUserCouponId;
@property (nonatomic,copy) NSString *storeCouponFlag;
@property (nonatomic,assign) double offerPrice;
@property (nonatomic,assign) double orderPrice;
@property (nonatomic,assign) double freeThreshold;
@property (nonatomic,assign) double leftOfferPrice;
@property (nonatomic,assign) double discountPrice;
@property (nonatomic,assign) double vatPrice;
@property (nonatomic,assign) double storeCouponPrice;
@property (nonatomic,assign) double platformCouponPrice;
@property (nonatomic,strong) NSArray <CartItemModel> *shoppingCarts;
@property (nonatomic,strong) NSArray <CartCampaignsModel> *campaignGroups;


@end


@interface CartModel : JSONModel

@property (nonatomic,assign) double totalOfferPrice;
@property (nonatomic,assign) double totalPrice;
@property (nonatomic,assign) double totalTax;
@property (nonatomic,assign) double totalDiscount;
@property (nonatomic,assign) double storeCouponPrice;
@property (nonatomic,assign) double platformCouponPrice;
@property (nonatomic,assign) double storeCampaignPrice;
@property (nonatomic,strong) NSArray <CartListModel> *validCarts;
@property (nonatomic,strong) NSArray <CartListModel> *invalidCarts;

@end

@interface CartNumModel : JSONModel
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *reduceNum;
@end

NS_ASSUME_NONNULL_END
