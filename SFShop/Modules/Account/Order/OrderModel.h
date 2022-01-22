//
//  OrderModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol orderItemsModel;
@protocol ReviewUserInfoModel;
@protocol DeliveryInfoModel;
@protocol EvaluatesModel;
@protocol EvaluatesContentsModel;
@protocol OrderDetailPaymentsModel;
@protocol PackageListModel;



@interface orderItemsModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*canEvaluate;
@property (nonatomic,copy) NSString <Optional>*canReturn;
@property (nonatomic,copy) NSString <Optional>*canReview;
@property (nonatomic,copy) NSDictionary <Optional>*evaluation;
@property (nonatomic,copy) NSString <Optional>*imagUrl;
@property (nonatomic,copy) NSString <Optional>*offerCnt;
@property (nonatomic,copy) NSString <Optional>*offerId;
@property (nonatomic,copy) NSString <Optional>*offerName;
@property (nonatomic,copy) NSString <Optional>*offerType;
@property (nonatomic,copy) NSString <Optional>*orderItemId;
@property (nonatomic,copy) NSString <Optional>*orderPrice;
@property (nonatomic,copy) NSString <Optional>*productId;
@property (nonatomic,copy) NSString <Optional>*productName;
@property (nonatomic,copy) NSString <Optional>*productRemark;
@property (nonatomic,copy) NSString <Optional>*serviceTypes;
@property (nonatomic,copy) NSString <Optional>*unitPrice;

@end

@interface EvaluatesContentsModel : JSONModel
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *bigImgUrl;


@end


@interface OrderGroupModel : JSONModel
@property (nonatomic,copy) NSString *campaignId;
@property (nonatomic,copy) NSString *catgId;
@property (nonatomic,copy) NSString *expDate;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *joinFlag;
@property (nonatomic,copy) NSString *state;
@property (nonatomic,copy) NSString *now;
@property (nonatomic,copy) NSString *offerId;
@property (nonatomic,copy) NSString *offerName;
@property (nonatomic,copy) NSString *shareBuyPrice;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *shareBuyOrderNbr;
@property (nonatomic,assign) NSInteger salesCnt;
@property (nonatomic,assign) NSInteger memberQty;
@property (nonatomic,assign) NSInteger shareByNum;
@property (nonatomic,copy) NSString *shareBuyOrderId;
@property (nonatomic,strong) NSArray <EvaluatesContentsModel>*imgs;
@property (nonatomic,strong) NSArray <ReviewUserInfoModel>*groupMembers;

/**
 {
     campaignId = 25;
     catgId = 199;
     expDate = "2021-12-10 13:43:44";
     groupMembers =     (
                 
     );
     imgUrl = "/get/resource/HJ-OR-NA-A360\U9ed1\U9152\U7ea2\U4e00\U5bf91404720233993867264.jpg";
     imgs =     (
                 
     );
     joinFlag = 1;
     memberQty = 1;
     now = "2021-12-10 14:01:28";
     offerId = 1137;
     offerName = "Gelang Magnet Sepasang, Cocok Untuk Hadiah Valentine ";
     productId = 1991;
     productName = "Gelang magnet 2 pasang, untuk hadiah di hari Valentine  Hitam + Anggur merah";
     salesCnt = 8;
     shareBuyOrderId = 75004;
     shareBuyOrderNbr = G202112091343326946;
     shareBuyPrice = 10000;
     shareByNum = 2;
     state = C;
     subheadName = "";
 }

 **/

@end

@interface OrderModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*canEvaluate;
@property (nonatomic,copy) NSString <Optional>*canReview;
@property (nonatomic,copy) NSString <Optional>*deliveryState;
@property (nonatomic,copy) NSString <Optional>*offerCnt;
@property (nonatomic,copy) NSString <Optional>*orderId;
@property (nonatomic,copy) NSString <Optional>*orderNbr;
@property (nonatomic,copy) NSString <Optional>*orderPrice;
@property (nonatomic,copy) NSString <Optional>*paymentState;
@property (nonatomic,copy) OrderGroupModel <Optional>*shareBuyBriefInfo;
@property (nonatomic,copy) NSString <Optional>*state;
@property (nonatomic,copy) NSString <Optional>*storeId;
@property (nonatomic,copy) NSString <Optional>*storeLogoUrl;
@property (nonatomic,copy) NSString <Optional>*storeName;
@property (nonatomic,copy) NSString <Optional>*stateStr;
@property (nonatomic,strong) NSArray <orderItemsModel>*orderItems;
- (NSString *)getStateStr;

@end

@interface billAddressModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*certNbr;
@property (nonatomic,copy) NSString <Optional>*certTypeId;
@property (nonatomic,copy) NSString <Optional>*contactAddress;
@property (nonatomic,copy) NSString <Optional>*contactEmail;
@property (nonatomic,copy) NSString <Optional>*contactFixNbr;
@property (nonatomic,copy) NSString <Optional>*contactName;
@property (nonatomic,copy) NSString <Optional>*contactNbr;
@property (nonatomic,copy) NSString <Optional>*contactStdId;
@property (nonatomic,copy) NSString <Optional>*postCode;
@end

@interface deliveryAddress : JSONModel
@property (nonatomic,copy) NSString <Optional>*certNbr;
@property (nonatomic,copy) NSString <Optional>*certTypeId;
@property (nonatomic,copy) NSString <Optional>*contactAddress;
@property (nonatomic,copy) NSString <Optional>*contactEmail;
@property (nonatomic,copy) NSString <Optional>*contactFixNbr;
@property (nonatomic,copy) NSString <Optional>*contactName;
@property (nonatomic,copy) NSString <Optional>*contactNbr;
@property (nonatomic,copy) NSString <Optional>*contactStdId;
@property (nonatomic,copy) NSString <Optional>*postCode;
@end

@interface DeliveryInfoModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*logisticsUrl;
@property (nonatomic,copy) NSString <Optional>*deliveryOrderId;
@property (nonatomic,copy) NSString <Optional>*warehouseName;
@property (nonatomic,copy) NSString <Optional>*logisticsId;
@property (nonatomic,copy) NSString <Optional>*logisticsName;
@property (nonatomic,copy) NSString <Optional>*deliveryDate;
@property (nonatomic,copy) NSString <Optional>*shippingNbr;
@property (nonatomic,copy) NSArray <Optional>*deliveryItems;
@end

@interface OrderDetailPaymentsModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*charge;
@property (nonatomic,copy) NSString <Optional>*orderPaymentId;
@property (nonatomic,copy) NSString <Optional>*paymentAcct;
@property (nonatomic,copy) NSString <Optional>*paymentDate;
@property (nonatomic,copy) NSString <Optional>*paymentId;
@property (nonatomic,copy) NSString <Optional>*paymentMethodName;
@property (nonatomic,copy) NSString <Optional>*paymentSn;
@property (nonatomic,copy) NSString <Optional>*paymentState;

@end

@interface OrderDetailModel : JSONModel
@property (nonatomic,strong) billAddressModel *billAddress;
@property (nonatomic,strong) deliveryAddress *deliveryAddress;
@property (nonatomic,strong) NSArray <OrderDetailPaymentsModel>*payments;
@property (nonatomic,strong) NSArray <orderItemsModel>*orderItems;
@property (nonatomic,strong) NSArray <DeliveryInfoModel>*deliverys;
@property (nonatomic,copy) NSString <Optional>*canEvaluate;
@property (nonatomic,copy) NSString <Optional>*canReview;
@property (nonatomic,copy) NSString <Optional>*cancelReason;
@property (nonatomic,copy) NSString <Optional>*completionDate;
@property (nonatomic,copy) NSString <Optional>*createdDate;
@property (nonatomic,copy) NSString <Optional>*deductionPrice;
@property (nonatomic,copy) NSString <Optional>*deliveryDate;
@property (nonatomic,copy) NSString <Optional>*deliveryMode;
@property (nonatomic,copy) NSString <Optional>*deliveryState;
@property (nonatomic,copy) NSString <Optional>*discountPrice;
@property (nonatomic,copy) NSString <Optional>*isNeedDelivery;
@property (nonatomic,copy) NSString <Optional>*leaveMsg;
@property (nonatomic,copy) NSString <Optional>*logisticsDeductFee;
@property (nonatomic,copy) NSString <Optional>*logisticsFee;
@property (nonatomic,copy) NSString <Optional>*logisticsModeId;
@property (nonatomic,copy) NSString <Optional>*logisticsOriFee;
@property (nonatomic,copy) NSString <Optional>*offerCnt;
@property (nonatomic,copy) NSString <Optional>*offerPrice;
@property (nonatomic,copy) NSString <Optional>*orderNbr;
@property (nonatomic,copy) NSString <Optional>*orderId;
@property (nonatomic,copy) NSString <Optional>*orderPrice;
@property (nonatomic,copy) NSString <Optional>*state;
@property (nonatomic,copy) NSString <Optional>*packageQty;
@property (nonatomic,copy) NSString <Optional>*paymentMode;
@property (nonatomic,copy) NSString <Optional>*paymentState;
@property (nonatomic,copy) NSString <Optional>*storeName;
@property (nonatomic,copy) NSString <Optional>*storeId;
@property (nonatomic,copy) NSString <Optional>*stateDate;
@property (nonatomic,copy) NSString <Optional>*storeCampaignPrice;
@property (nonatomic,copy) NSString <Optional>*storeCouponPrice;
@property (nonatomic,copy) NSString <Optional>*returnPrice;
@property (nonatomic,copy) NSString <Optional>*pointPrice;
@property (nonatomic,copy) NSString <Optional>*receivedDate;
@property (nonatomic,copy) NSString <Optional>*shareBuyOrderId;
@property (nonatomic,copy) NSString <Optional>*shareBuyOrderNbr;
@end

@interface CancelOrderReasonModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*comments;
@property (nonatomic,assign) BOOL sel;
@property (nonatomic,copy) NSString <Optional>*orderReasonId;
@property (nonatomic,copy) NSString <Optional>*orderReasonName;
@end


@class ProductItemModel;

@interface PurchaseReviewModel : JSONModel
@property (nonatomic,strong) NSArray <EvaluatesContentsModel>*contents;
@property (nonatomic,copy) NSString <Optional>*reviewTime;
@property (nonatomic,copy) NSString <Optional>*reviewDate;
@property (nonatomic,copy) NSString <Optional>*reviewComments;
@property (nonatomic,copy) NSString <Optional>*isUseful;
@end

@interface ReviewUserInfoModel : JSONModel
@property (nonatomic,strong) NSString <Optional>*photo;
@property (nonatomic,strong) NSString <Optional>*nickName;
@property (nonatomic,strong) NSString <Optional>*isLeader;
@property (nonatomic,strong) NSString <Optional>*shareBuyOrdInstId;
@property (nonatomic,strong) NSString <Optional>*orderId;

@end

@interface EvaluatesModel : JSONModel
@property (nonatomic,strong) NSArray <EvaluatesContentsModel>*contents;
@property (nonatomic,copy) NSString <Optional>*evaluationComments;
@property (nonatomic,copy) NSString <Optional>*isAnonymous;
@property (nonatomic,copy) NSString <Optional>*isUseful;
@property (nonatomic,copy) NSString <Optional>*offerEvaluationId;
@property (nonatomic,copy) NSString <Optional>*rate;
@property (nonatomic,strong) ProductItemModel *product;
@property (nonatomic,strong) PurchaseReviewModel *review;
@property (nonatomic,strong) ReviewUserInfoModel *user;
@end

@interface ReviewDetailModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*completionDate;
@property (nonatomic,copy) NSString <Optional>*evaluateDate;
@property (nonatomic,copy) NSString <Optional>*orderId;
@property (nonatomic,copy) NSString <Optional>*orderNbr;
@property (nonatomic,strong) NSArray <EvaluatesModel>*evaluates;
@end



@interface OrderNumModel : JSONModel
@property (nonatomic,assign) NSInteger toPayNum;
@property (nonatomic,assign) NSInteger toDeliveryNum;
@property (nonatomic,assign) NSInteger toReceiveNum;
@property (nonatomic,assign) NSInteger completedNum;
@property (nonatomic,assign) NSInteger toRatingNum;
@property (nonatomic,assign) NSInteger toComfirmNum;
@property (nonatomic,assign) NSInteger canceledNum;
@property (nonatomic,assign) NSInteger returnsNum;

@end

@interface PackageListModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*subPkgLogisticsName;
@property (nonatomic,copy) NSString <Optional>*subPkgLogisticsNbr;


@end

@interface OrderDetailLogisticsModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*logisticsId;
@property (nonatomic,copy) NSString <Optional>*logisticsName;
@property (nonatomic,copy) NSString <Optional>*url;
@property (nonatomic,copy) NSString <Optional>*shippingNbr;
@property (nonatomic,strong) NSArray <Optional>*packageDetailList;


@end

@interface RefundChargeModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*refundAmount;
@property (nonatomic,copy) NSString <Optional>*refundCharge;

@end

NS_ASSUME_NONNULL_END
