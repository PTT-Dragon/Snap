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

NS_ASSUME_NONNULL_END
