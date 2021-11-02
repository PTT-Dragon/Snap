//
//  DistributorModel.h
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

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

@end

@interface DistributorModel : JSONModel
@property (nonatomic,strong) KolOrderStatusNumModel *kolOrderStatusNum;
@property (nonatomic,strong) KolDayMonthSaleModel *kolDayMonthSale;
@property (nonatomic,strong) DistributionSettlementDtoModel *distributionSettlementDto;
@property (nonatomic,copy) NSString <Optional>*sysKolCampaignId;
@end

NS_ASSUME_NONNULL_END
