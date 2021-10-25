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
@property (nonatomic,strong) NSArray <orderItemsModel>*orderItems;

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

NS_ASSUME_NONNULL_END
