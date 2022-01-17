//
//  ProductDetailModel.h
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "JSONModel.h"
#import "CartModel.h"
#import "OrderModel.h"
#import "FlashSaleModel.h"
#import "CouponModel.h"
#import "OrderLogisticsModel.h"
#import "CouponsAvailableModel.h"
#import "ProductCalcFeeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProductCarouselImgModel;
@protocol ProductAttrModel;
@protocol ProductAttrValueModel;
@protocol ProdSpcAttrsModel;
@protocol ProductItemModel;
@protocol EvaluatesContentsModel;
@protocol ProductEvalationLabelsModel;
@protocol cmpShareBuysModel;
@protocol ProductGroupListModel;
@protocol FlashSaleDateModel;
@protocol CouponModel;




@interface ProductCarouselImgModel: JSONModel

@property(nonatomic, assign) NSInteger contentId;
@property(nonatomic, strong) NSString *contentType;
@property(nonatomic, assign) NSInteger seq;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *imgUrl;
@property(nonatomic, strong) NSString *bigImgUrl;
@property(nonatomic, strong) NSString *smallImgUrl;

@end

@interface ProductAttrValueModel: JSONModel

@property(nonatomic, assign) NSInteger seq;
@property(nonatomic, strong) NSString *value;

@end


@interface ProductAttrModel: JSONModel

@property(nonatomic, strong) NSString *attrId;
@property(nonatomic, assign) NSInteger seq;
@property(nonatomic, strong) NSString *attrName;
@property(nonatomic, strong) NSArray <ProductAttrValueModel *> <ProductAttrValueModel> *attrValues;

@end

@interface ProductItemModel: JSONModel

@property(nonatomic, assign) NSInteger productId;
@property(nonatomic, strong) NSString *productName;
@property(nonatomic, strong) NSString *productRemark;
@property(nonatomic, assign) NSInteger salesPrice;
@property(nonatomic, assign) NSInteger marketPrice;
@property(nonatomic, assign) NSInteger minBuyCount;
@property(nonatomic, assign) NSInteger maxBuyCount;
@property(nonatomic, strong) NSString *isCollection;
@property(nonatomic, strong) NSString *imgUrl;
@property (nonatomic,strong) NSArray <ProdSpcAttrsModel *> <ProdSpcAttrsModel> *prodSpcAttrs;

#pragma mark - 自定义字段，需要外部赋值(详情页使用)
@property(nonatomic, readwrite, assign) NSInteger groupPrice;//团购价

#pragma mark - 自定义字段，需要外部赋值(结算使用)
@property(nonatomic, readwrite, strong) NSString *storeName;//商店名称
@property(nonatomic, readwrite, assign) NSInteger currentBuyCount;//当前商品购买数量
@property(nonatomic, readwrite, strong, nullable) NSArray *inCmpIdList;//当前商品的优惠id 列表

@end

@interface ProductDetailModel : JSONModel

@property(nonatomic, assign) NSInteger offerId;
@property(nonatomic, strong) NSString *offerType;
@property(nonatomic, strong) NSString *isNeedDelivery;
@property(nonatomic, strong) NSString *deliveryMode;
@property(nonatomic, strong) NSString *offerName;
@property(nonatomic, strong) NSString *subheadName;
@property(nonatomic, assign) NSInteger salesPrice;
@property(nonatomic, assign) NSInteger marketPrice;
@property(nonatomic, strong) NSString *goodsIntroduce;
@property(nonatomic, strong) NSString *goodsDetails;
@property(nonatomic, assign) NSInteger storeId;//必须
@property(nonatomic, strong) NSString *storeName;//必须
@property(nonatomic, strong) NSString *storeType;
@property(nonatomic, strong) NSString *storeLogoUrl;
@property(nonatomic, strong) NSString *uccAccount;
@property(nonatomic, strong) NSArray <ProductAttrModel *> <ProductAttrModel> *offerSpecAttrs;
@property(nonatomic, strong) NSArray <ProductCarouselImgModel *> <ProductCarouselImgModel> *carouselImgUrls;
@property(nonatomic, strong) NSArray *offerAttrValues;
@property(nonatomic, strong) NSArray <ProductItemModel *> <ProductItemModel> *products;

#pragma mark - 自定义字段，需要外部赋值 (详情页使用)

/// 更新选中的标签
/// @param spcAttsMode 标签模型
- (void)updateCurrentSpcAttsMode:(ProdSpcAttrsModel *)spcAttsMode;

//获取当前选中的商品
@property(nonatomic, readonly, strong) ProductItemModel *selectedProductItem;


#pragma mark - 自定义字段，需要外部赋值 (结算使用)
@property(nonatomic, readwrite, strong, nullable) NSString *note;//留言

/*
 外部组装选中商品(结算使用)
 */
@property(nonatomic, readwrite, strong, nonnull) NSArray <ProductItemModel *> *selectedProducts;//选中商品商品

/*
 当前商店投递数据
 1、可以为空
 2、每次更新投递数据之后需要重新计算总价
 */
@property (nonatomic, readwrite, strong, nullable) OrderLogisticsModel *logisticsModel;
@property (nonatomic, readwrite, strong, nullable) OrderLogisticsItem *currentLogisticsItem;


/*
 当前商店优惠券
 1、可以为空
 2、每次更新之后需要重新计算总价
 */
@property (nonatomic, readwrite, strong, nullable) CouponsStoreModel *storeCoupon;//当前商店所有优惠券
@property (nonatomic, readwrite, strong, nullable) CouponItem *currentStoreCoupon;//当前商店优惠券

/*
 当前商店结算数据
 */
@property (nonatomic, readwrite, strong, nullable) ProductCalcFeeStoreModel *feeModel;

@end

@interface ProductEvalationReplayModel : JSONModel
@property(nonatomic, strong) NSString *replyComments;
@property(nonatomic, strong) NSString *replyDate;
@property(nonatomic, strong) NSString *storeName;
@property(nonatomic, strong) NSString *storeLogoUrl;
@property(nonatomic, strong) NSString *usefulCnt;
@property(nonatomic,assign) CGFloat itemHie;
@end

@interface ProductEvalationModel : JSONModel
@property(nonatomic, strong) NSString *offerEvaluationId;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *offerId;
@property(nonatomic, strong) NSString *offerName;
@property(nonatomic, strong) NSString *productId;
@property(nonatomic, strong) NSString *productName;
@property(nonatomic, strong) NSString *attrValues;
@property(nonatomic, strong) NSString *productImgUrl;
@property(nonatomic, strong) NSString *isAnonymous;
@property(nonatomic, strong) NSString *rate;
@property(nonatomic, strong) NSString *evaluationComments;
@property(nonatomic, strong) NSString *createdDate;
@property(nonatomic, strong) NSString *userLogo;
@property(nonatomic, strong) ProductEvalationReplayModel *reply;
@property(nonatomic,assign) CGFloat itemHie;
@property (nonatomic,strong) NSArray <EvaluatesContentsModel>*evaluationContents;
/**
 "offerEvaluationId": 54005,
             "userId": 1224,
             "userName": "wcttest2@qq.com",
             "offerId": 1491,
             "offerName": "Pompa air listrik, untuk minum air ,bentuk lebih besar, perangkat penghisap tekanan air, perangkat pompa air otomatis, Dispenser Air Portabel , perangkat bisa diisi ulang daya.",
             "productId": 2891,
             "productName": "Pompa air listrik, untuk minum air ,bentuk lebih besar, perangkat penghisap tekanan air, perangkat pompa air otomatis, Dispenser Air Portabel , perangkat bisa diisi ulang daya. KT012 Hitam",
             "attrValues": "KT012 Hitam",
             "productImgUrl": "/get/resource/KT012-black1423114793488879616.jpg",
             "isAnonymous": "N",
             "rate": 5,
             "evaluationComments": "Positive review given by system default",
             "createdDate": "2021-11-30 01:00:00",
             "usefulCnt": 0,
             "isUseful": "N",
             "userLogo": "/get/resource/218BA32D-2BD6-4E02-B7FE-729FABDBF7C91455344634011193344.jpeg",
             "evaluationContents": [],
             "review": null,
             "reply": {
                 "replyComments": "1",
                 "replyDate": "2021-11-30 10:05:35",
                 "storeName": "NeuKoo",
                 "storeLogoUrl": "/get/resource/f11460116260238004224.jpg",
                 "contents": null,
                 "usefulCnt": 0,
                 "isUseful": null
             },
             "labelNames": []
         }
 **/

@end

@interface ProductEvalationLabelsModel : JSONModel
@property (nonatomic,copy) NSString *labelId;
@property (nonatomic,copy) NSString *labelName;
@property (nonatomic,assign) BOOL sel;
@property (nonatomic,assign) float width;
@end

@interface ProductEvalationDetailModel : JSONModel
@property (nonatomic,assign) float oneStarCnt;
@property (nonatomic,assign) float twoStarCnt;
@property (nonatomic,assign) float threeStarCnt;
@property (nonatomic,assign) float fourStarCnt;
@property (nonatomic,assign) float fiveStarCnt;
@property (nonatomic,assign) NSInteger positiveEvaluationCnt;
@property (nonatomic,assign) NSInteger negativeEvaluationCnt;
@property (nonatomic,assign) NSInteger imgEvaluationCnt;
@property (nonatomic,assign) NSInteger videoEvaluationCnt;
@property (nonatomic,assign) NSInteger mediaEvaluationCnt;
@property (nonatomic,assign) NSInteger evaluationCnt;
@property (nonatomic,copy) NSString *evaluationAvg;
@property (nonatomic,copy) NSString *evaluationRate;
@property (nonatomic,strong) NSArray <ProductEvalationLabelsModel>*evaluationLabels;
@end

@interface cmpShareBuysModel : JSONModel
@property (nonatomic,assign) NSInteger campaignId;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *useCoupon;
@property (nonatomic,assign) NSInteger shareByNum;
@property (nonatomic,assign) double shareBuyPrice;
@property (nonatomic,assign) double discountPercent;
@property (nonatomic,assign) NSInteger buyAmtLimit;
@end

@interface ProductCampaignsInfoModel : JSONModel
@property (nonatomic,strong) NSArray *cmpBuygetns;
@property (nonatomic,strong) NSArray <cmpShareBuysModel>*cmpShareBuys;
@property (nonatomic,strong) NSArray <FlashSaleDateModel>*cmpFlashSales;
@property (nonatomic,strong) NSArray <CouponModel>*coupons;
@end


@interface ProductGroupListModel : JSONModel
@property (nonatomic,copy) NSString *memberQty;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *shareBuyOrderId;
@property (nonatomic,copy) NSString *shareBuyOrderNbr;
@property (nonatomic,copy) NSString *shareByNum;
@end

@interface ProductGroupModel : JSONModel
@property (nonatomic,strong) NSArray <ProductGroupListModel>*list;
@property (nonatomic,assign) NSInteger total;
/**
 {
     endRow = 2;
     firstPage = 1;
     hasNextPage = 0;
     hasPreviousPage = 0;
     isFirstPage = 1;
     isLastPage = 1;
     lastPage = 1;
     list =     (
                 {
             memberQty = 1;
             nickName = hyy1994;
             photo = "/get/resource/0CR9CC45-72EC-4522-9D8E-RB8491192E011467123501889622016.jpeg";
             shareBuyOrderId = 79003;
             shareBuyOrderNbr = G202112161413289975;
             shareByNum = 2;
         },
                 {
             memberQty = 1;
             nickName = hyy1994;
             photo = "/get/resource/0CR9CC45-72EC-4522-9D8E-RB8491192E011467123501889622016.jpeg";
             shareBuyOrderId = 80007;
             shareBuyOrderNbr = G202112161740346230;
             shareByNum = 2;
         },
                 {
             memberQty = 1;
             nickName = hyy1994;
             photo = "/get/resource/0CR9CC45-72EC-4522-9D8E-RB8491192E011467123501889622016.jpeg";
             shareBuyOrderId = 79006;
             shareBuyOrderNbr = G202112161934063490;
             shareByNum = 2;
         }
     );
     navigateFirstPage = 1;
     navigateLastPage = 1;
     navigatePages = 8;
     navigatepageNums =     (
         1
     );
     nextPage = 0;
     pageNum = 1;
     pageSize = 5;
     pages = 1;
     prePage = 0;
     size = 3;
     startRow = 0;
     total = 3;
 }

 **/
@end

NS_ASSUME_NONNULL_END
