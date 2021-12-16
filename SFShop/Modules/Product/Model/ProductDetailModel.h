//
//  ProductDetailModel.h
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "JSONModel.h"
#import "CartModel.h"
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProductCarouselImgModel;
@protocol ProductAttrModel;
@protocol ProductAttrValueModel;
@protocol ProdSpcAttrsModel;
@protocol ProductItemModel;
@protocol EvaluatesContentsModel;
@protocol ProductEvalationLabelsModel;
@protocol cmpShareBuysModel;



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
@property(nonatomic, assign) NSInteger storeId;
@property(nonatomic, strong) NSString *storeName;
@property(nonatomic, strong) NSString *storeType;
@property(nonatomic, strong) NSString *storeLogoUrl;
@property(nonatomic, strong) NSString *uccAccount;
@property(nonatomic, strong) NSArray <ProductAttrModel *> <ProductAttrModel> *offerSpecAttrs;
@property(nonatomic, strong) NSArray <ProductCarouselImgModel *> <ProductCarouselImgModel> *carouselImgUrls;
@property(nonatomic, strong) NSArray *offerAttrValues;
@property(nonatomic, strong) NSArray <ProductItemModel *> <ProductItemModel> *products;

@end

@interface ProductEvalationReplayModel : JSONModel
@property(nonatomic, strong) NSString *replyComments;
@property(nonatomic, strong) NSString *replyDate;
@property(nonatomic, strong) NSString *storeName;
@property(nonatomic, strong) NSString *storeLogoUrl;
@property(nonatomic, strong) NSString *usefulCnt;
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
@end


NS_ASSUME_NONNULL_END
