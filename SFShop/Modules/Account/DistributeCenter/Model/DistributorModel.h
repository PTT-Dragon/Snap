//
//  DistributorModel.h
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RelationOrderItemModel <NSObject>

@end

@interface DistributorRankProductModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *distriSpuLibId;
@property (nonatomic,copy) NSString <Optional> *offerId;
@property (nonatomic,copy) NSString <Optional> *productId;
@property (nonatomic,copy) NSString <Optional> *offerName;
@property (nonatomic,copy) NSString <Optional> *commission;
@property (nonatomic,copy) NSString <Optional> *commissionRate;
@property (nonatomic,copy) NSString <Optional> *imgUrl;
@property (nonatomic,copy) NSString <Optional> *salesCnt;
@property (nonatomic,copy) NSString <Optional> *salesPrice;
@property (nonatomic,copy) NSString <Optional> *marketPrice;
@property (nonatomic,copy) NSString <Optional> *discountPercent;
@end

@interface DistributionSettlementDtoModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *distributorId;
@property (nonatomic,copy) NSString <Optional> *settledCommission;
@property (nonatomic,copy) NSString <Optional> *withdrawnCommission;
@property (nonatomic,copy) NSString <Optional> *lockedCommission;
@property (nonatomic,copy) NSString <Optional> *balanceCommission;
@property (nonatomic,copy) NSString <Optional> *receivableCommission;
@end

@interface KolDayMonthSaleModel : JSONModel

@end

@interface KolOrderStatusNumModel : JSONModel
@property (nonatomic,assign) NSInteger pendingNum;
@property (nonatomic,assign) NSInteger settledNum;
@end

@interface DistributorModel : JSONModel
@property (nonatomic,strong) KolOrderStatusNumModel *kolOrderStatusNum;
@property (nonatomic,strong) KolDayMonthSaleModel *kolDayMonthSale;
@property (nonatomic,strong) DistributionSettlementDtoModel *distributionSettlementDto;
@property (nonatomic,copy) NSString <Optional>*sysKolCampaignId;
@end

@interface DistributorCommissionModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*distributorId;
@property (nonatomic,copy) NSString <Optional>*settledCommission;
@property (nonatomic,copy) NSString <Optional>*withdrawnCommission;
@property (nonatomic,copy) NSString <Optional>*lockedCommission;
@property (nonatomic,copy) NSString <Optional>*balanceCommission;
@property (nonatomic,copy) NSString <Optional>*receivableCommission;
@end

@interface IncomeOrWithdrawListModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*charge;
@property (nonatomic,copy) NSString <Optional>*commissionOperType;
@property (nonatomic,copy) NSString <Optional>*createdDate;
@property (nonatomic,copy) NSString <Optional>*distributorId;
@property (nonatomic,copy) NSString <Optional>*relaId;
@property (nonatomic,copy) NSString <Optional>*relaSn;
@end

@interface RelationOrderItemModel : JSONModel
@property (nonatomic,copy) NSString *imagUrl;
/**
 {
canEvaluate = "<null>";
canReturn = "<null>";
canReview = "<null>";
catgId = 239;
createdDate = "2021-10-26 15:29:24";
deliveryCnt = 1;
discountPrice = 0;
evaluation = "<null>";
freightTemplateId = 2;
height = 1;
imagUrl = "/get/resource/HJ-ST-NA-A2381405789823066836992.jpg";
isNeedDelivery = "<null>";
length = 1;
offerCnt = 1;
offerId = 1250;
offerName = "Pulpen cahaya karakter kartun unicorn 0.5mm";
offerPrice = 68000;
orderId = 98002;
orderItemId = 98002;
orderNbr = "<null>";
orderPrice = 68000;
productCode = "HJ-ST-NA-A238";
productId = 2428;
productName = "Pulpen cahaya karakter kartun unicorn 0.5mm Dinosaurus Ungu + Unicorn Merah Muda + Dinosaurus Biru + Unicorn Putih + Unicorn Ungu + Unicorn Biru";
productRemark = "{\"Color\":\"Dinosaurus Ungu + Unicorn Merah Muda + Dinosaurus Biru + Unicorn Putih + Unicorn Ungu + Unicorn Biru\"}";
salesPrice = 0;
serviceTypes = "<null>";
storeId = 15;
supplierId = 1;
supplierOfferCode = "<null>";
unit = "";
unitPrice = "<null>";
vatPrice = 0;
warehouseId = 2;
weight = 13;
width = 1;
}
 **/
@end

@class OrderModel;

@interface RelationOrderListModel : JSONModel
@property (nonatomic,strong) NSArray <RelationOrderItemModel>* orderItems;
@property (nonatomic,copy) NSString *createdDate;
@property (nonatomic,copy) NSString *distributorId;
@property (nonatomic,copy) NSString *distributorName;
@property (nonatomic,copy) NSString *kolCommission;
@property (nonatomic,copy) NSString *kolMobilePhone;
@property (nonatomic,copy) NSString *orderDate;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *orderNbr;
@property (nonatomic,copy) NSString *orderPrice;
@property (nonatomic,copy) NSString *orderState;
@property (nonatomic,copy) NSString *settState;
@property (nonatomic,copy) NSString *stateDate;
@property (nonatomic,copy) NSString *storeId;
@property (nonatomic,copy) NSString *storeLogoUrl;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *updateDate;
/**
 {
 = "2021-10-26 15:29:32";
 = 1007;
 = Steven;
 = 15096;
 = "173******7044";
 = "2021-10-26 15:29:24";
 = 98002;
orderItems =             (
                 
);
 = O202110261529248036;
 = 68000;
 = D;
 = Settled;
 = "2021-11-14 00:00:00";
 = 15;
 = "/get/resource/f11460116260238004224.jpg";
 = NeuKoo;
 = "2021-11-14 00:00:00";
}
 **/
@end

@class OrderDetailModel;

@interface RelationOrderDetailModel : JSONModel
@property (nonatomic,copy) NSString *createdDate;
@property (nonatomic,copy) NSString *distributorId;
@property (nonatomic,copy) NSString *distributorName;
@property (nonatomic,copy) NSString *kolCommission;
@property (nonatomic,copy) NSString *kolMobilePhone;
@property (nonatomic,copy) NSString *orderDate;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *orderNbr;
@property (nonatomic,copy) NSString *orderPrice;
@property (nonatomic,copy) NSString *settState;
@property (nonatomic,copy) NSString *stateDate;
@property (nonatomic,copy) NSString *storeId;
@property (nonatomic,copy) NSString *storeLogoUrl;
@property (nonatomic,copy) NSString *storeName;
@property (nonatomic,copy) NSString *updateDate;
@property (nonatomic,strong) OrderDetailModel *orderDetail;

/**
 {
 orderId = 98002;
 orderNbr = O202110261529248036;
 orderPrice = 68000;
 settState = Settled;
 stateDate = "2021-11-14 00:00:00";
 storeId = 15;
 storeLogoUrl = "/get/resource/f11460116260238004224.jpg";
 storeName = NeuKoo;
 updateDate = "2021-11-14 00:00:00";
     createdDate = "2021-10-26 15:29:32";
     distributorId = 1007;
     distributorName = Steven;
     kolCommission = 15096;
     kolMobilePhone = "173******7044";
     orderDate = "2021-10-26 15:29:24";
     orderDetail =     {
         billAddress =         {
             certNbr = "<null>";
             certTypeId = "<null>";
             contactAddress = "";
             contactEmail = "16337@163.com";
             contactFixNbr = "<null>";
             contactName = "<null>";
             contactNbr = "<null>";
             contactStdId = "<null>";
             postCode = "<null>";
         };
         canEvaluate = "<null>";
         canReview = "<null>";
         cancelReason = "<null>";
         completionDate = "2021-11-06 00:00:00";
         createdDate = "2021-10-26 15:29:24";
         deductionPrice = 0;
         deliveryAddress =         {
             certNbr = "<null>";
             certTypeId = "<null>";
             contactAddress = "\U54e6\U54e6\U54e6\U54e6\U54e6, Banua, Kintamani, Kab.Bangli, Bali";
             contactEmail = "16337@163.com";
             contactFixNbr = "<null>";
             contactName = nong;
             contactNbr = 11111111111;
             contactStdId = 10077;
             postCode = 80652;
         };
         deliveryDate = "<null>";
         deliveryMode = A;
         deliveryState = C;
         deliverys =         (
                         {
                 deliveryDate = "2021-10-26 19:46:29";
                 deliveryItems =                 (
                                         {
                         cnt = 1;
                         createdDate = "";
                         productCode = "HJ-ST-NA-A238";
                         productId = 2428;
                         productName = "Pulpen cahaya karakter kartun unicorn 0.5mm Dinosaurus Ungu + Unicorn Merah Muda + Dinosaurus Biru + Unicorn Putih + Unicorn Ungu + Unicorn Biru";
                         productRemark = "{\"Color\":\"Dinosaurus Ungu + Unicorn Merah Muda + Dinosaurus Biru + Unicorn Putih + Unicorn Ungu + Unicorn Biru\"}";
                         warehouseId = 2;
                         warehouseName = "\U901a\U7528\U4ed3\U5e93";
                     }
                 );
                 deliveryOrderId = 51002;
                 logisticsId = 998;
                 logisticsName = JD;
                 logisticsUrl = "<null>";
                 shippingNbr = 7758757;
                 warehouseName = "\U901a\U7528\U4ed3\U5e93";
             }
         );
         discountPrice = 0;
         isNeedDelivery = "<null>";
         leaveMsg = "";
         logisticsDeductFee = 0;
         logisticsFee = 0;
         logisticsModeId = "<null>";
         logisticsOriFee = 0;
         offerCnt = 1;
         offerPrice = 68000;
         orderId = 98002;
         orderItems =         (
                         {
                 brandId = "<null>";
                 brandName = "<null>";
                 canEvaluate = "<null>";
                 canReturn = "<null>";
                 canReview = "<null>";
                 catgId = 239;
                 catgName = "<null>";
                 discountPrice = 0;
                 imagUrl = "/get/resource/HJ-ST-NA-A2381405789823066836992.jpg";
                 isGift = "<null>";
                 offerCnt = 1;
                 offerId = 1250;
                 offerName = "Pulpen cahaya karakter kartun unicorn 0.5mm";
                 offerPrice = 68000;
                 offerType = "<null>";
                 orderItemId = 98002;
                 orderPrice = 68000;
                 parentId = "<null>";
                 pointExchCharge = 0;
                 pointPrice = 0;
                 productCode = "HJ-ST-NA-A238";
                 productId = 2428;
                 productName = "Pulpen cahaya karakter kartun unicorn 0.5mm Dinosaurus Ungu + Unicorn Merah Muda + Dinosaurus Biru + Unicorn Putih + Unicorn Ungu + Unicorn Biru";
                 productRemark = "{\"Color\":\"Dinosaurus Ungu + Unicorn Merah Muda + Dinosaurus Biru + Unicorn Putih + Unicorn Ungu + Unicorn Biru\"}";
                 returnPrice = "<null>";
                 serviceTypes = "2,3";
                 state = C;
                 storeId = 15;
                 supplierId = 1;
                 supplierOfferCode = "<null>";
                 thirdPartyCodeList = "<null>";
                 unit = "";
                 unitPrice = 68000;
                 vatPrice = 0;
             }
         );
         orderNbr = O202110261529248036;
         orderPrice = 68000;
         packageQty = "<null>";
         paymentMode = A;
         paymentState = S;
         payments = "<null>";
         platformCouponPrice = 0;
         pointExchCharge = 0;
         pointPrice = 0;
         receivedDate = "<null>";
         returnPrice = "<null>";
         sellerComments = "<null>";
         shareBuyOrderId = "<null>";
         shareBuyOrderNbr = "<null>";
         state = D;
         stateDate = "<null>";
         storeCampaignPrice = 0;
         storeCouponPrice = 0;
         storeId = 15;
         storeName = NeuKoo;
         thirdPartyCodeList = "<null>";
         uccAccount = "<null>";
         vatPrice = 0;
     };
     
 
 }

 **/
@end

NS_ASSUME_NONNULL_END
