//
//  OrderModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol orderItemsModel <NSObject>


@end

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

@interface OrderModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*canEvaluate;
@property (nonatomic,copy) NSString <Optional>*canReview;
@property (nonatomic,copy) NSString <Optional>*deliveryState;
@property (nonatomic,copy) NSString <Optional>*offerCnt;
@property (nonatomic,copy) NSString <Optional>*orderId;
@property (nonatomic,copy) NSString <Optional>*orderNbr;
@property (nonatomic,copy) NSString <Optional>*orderPrice;
@property (nonatomic,copy) NSString <Optional>*paymentState;
@property (nonatomic,copy) NSDictionary <Optional>*shareBuyBriefInfo;
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

@interface OrderDetailModel : JSONModel
@property (nonatomic,strong) billAddressModel *billAddress;
@property (nonatomic,strong) deliveryAddress *deliveryAddress;
@property (nonatomic,strong) NSArray <orderItemsModel>*orderItems;
@property (nonatomic,strong) NSArray <Optional>*deliverys;
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
/**
 {
     logisticsDeductFee = 0;
     logisticsFee = 20000;
     logisticsModeId = 1;
     logisticsOriFee = 20000;
     offerCnt = 1;
     offerPrice = 3000;
     orderId = 69004;
     orderNbr = O202109162044596345;
     orderPrice = 23000;
     packageQty = "<null>";
     paymentMode = A;
     paymentState = N;
     payments = "<null>";
     platformCouponPrice = 0;
     pointExchCharge = 0;
     pointPrice = 0;
     receivedDate = "<null>";
     returnPrice = "<null>";
     sellerComments = "<null>";
     shareBuyOrderId = "<null>";
     shareBuyOrderNbr = "<null>";
     state = E;
     stateDate = "2021-09-16 21:15:00";
     storeCampaignPrice = 0;
     storeCouponPrice = 0;
     storeId = 11;
     storeName = "Apple Store";
     thirdPartyCodeList =     (
     );
     uccAccount = "<null>";
     vatPrice = 0;
 }
 **/

@end

@interface CancelOrderReasonModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*comments;
@property (nonatomic,assign) BOOL sel;
@property (nonatomic,copy) NSString <Optional>*orderReasonId;
@property (nonatomic,copy) NSString <Optional>*orderReasonName;
@end

@protocol EvaluatesModel <NSObject>


@end
@protocol EvaluatesContentsModel <NSObject>


@end

@interface EvaluatesContentsModel : JSONModel
@property (nonatomic,copy) NSString *url;
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
/**
 {
 orderId = 41001;
 orderNbr = O202107231430105449;
     completionDate = "2021-07-23 14:31:15";
     evaluateDate = "2021-07-23 14:32:06";
     evaluates =     (
                 {
             contents =             (
                                 {
                     bigImgUrl = "<null>";
                     catgType = B;
                     content = "<null>";
                     defLangId = "<null>";
                     deviceType = "<null>";
                     imgUrl = "<null>";
                     name = "83e15ae56d952a76252d6978a96bb9d7.jpeg";
                     offerId = "<null>";
                     productId = "<null>";
                     seq = 0;
                     smallImgUrl = "<null>";
                     type = T;
                     uid = 12001;
                     url = "/get/resource/83e15ae56d952a76252d6978a96bb9d71418458729795424256.jpeg";
                 },
                                 {
                     bigImgUrl = "<null>";
                     catgType = B;
                     content = "<null>";
                     defLangId = "<null>";
                     deviceType = "<null>";
                     imgUrl = "<null>";
                     name = "5145447c628bb4355e72cdc91e66b310.gif";
                     offerId = "<null>";
                     productId = "<null>";
                     seq = 1;
                     smallImgUrl = "<null>";
                     type = T;
                     uid = 12002;
                     url = "/get/resource/5145447c628bb4355e72cdc91e66b3101418458756739633152.gif";
                 },
                                 {
                     bigImgUrl = "<null>";
                     catgType = B;
                     content = "<null>";
                     defLangId = "<null>";
                     deviceType = "<null>";
                     imgUrl = "<null>";
                     name = "ea6b8f3c3ae5758be7cc9747ca099d3b.jpeg";
                     offerId = "<null>";
                     productId = "<null>";
                     seq = 2;
                     smallImgUrl = "<null>";
                     type = T;
                     uid = 12003;
                     url = "/get/resource/ea6b8f3c3ae5758be7cc9747ca099d3b1418458783507681280.jpeg";
                 }
             );
             evaluationComments = "not good\Uff0cjust 1 star\Uff01";
             isAnonymous = N;
             isUseful = N;
             labels = "<null>";
             offerEvaluationId = 17001;
             product =             {
                 imgUrl = "/get/resource/\U7eff1417747328839847936.png";
                 orderItemId = 41001;
                 price = 3000;
                 productId = 2551;
                 productName = "\U5c0f\U7c7311 Green";
                 productRemark = "{\"Color\":\"Green\"}";
             };
             rate = 1;
             ratingDate = "<null>";
             reply = "<null>";
             review =             {
                 contents =                 (
                                         {
                         bigImgUrl = "<null>";
                         catgType = B;
                         content = "<null>";
                         defLangId = "<null>";
                         deviceType = "<null>";
                         imgUrl = "<null>";
                         name = "133313902154898500526081405808531088740352.png";
                         offerId = "<null>";
                         productId = "<null>";
                         seq = 0;
                         smallImgUrl = "<null>";
                         type = T;
                         uid = 10004;
                         url = "/get/resource/1333139021548985005260814058085310887403521419496659875926016.png";
                     }
                 );
                 isUseful = N;
                 reviewComments = "invite the new person";
                 reviewDate = "2021-07-26 11:16:00";
                 reviewTime = "-135";
                 usefulCnt = 0;
             };
             selLabelIds = "<null>";
             usefulCnt = 0;
             user =             {
                 nickName = 17366287044;
                 photo = "/get/resource/0CR9CC45-72EC-4522-9D8E-RB8491192E011467123501889622016.jpeg";
             };
         }
     );
     
     store =     {
         fields =         (
                         {
                 fieldCode = RATE;
                 fieldName = "Quality of Goods";
             },
                         {
                 fieldCode = RATE1;
                 fieldName = "Service Attitude";
             },
                         {
                 fieldCode = RATE2;
                 fieldName = "Logistics Service";
             }
         );
         rate = 1;
         rate1 = 2;
         rate2 = 3;
         rate3 = "<null>";
         rate4 = "<null>";
         rate5 = "<null>";
         rate6 = "<null>";
         rate7 = "<null>";
         rate8 = "<null>";
         rate9 = "<null>";
         storeId = 11;
         storeLogo = "<null>";
         storeName = "Apple Store";
     };
 }

 **/

@end

NS_ASSUME_NONNULL_END
