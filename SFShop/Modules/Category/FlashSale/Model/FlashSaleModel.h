//
//  FlashSaleModel.h
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlashSaleModel : JSONModel

@end

@interface FlashSaleDateModel : JSONModel
@property (nonatomic,copy) NSString *campaignId;
@property (nonatomic,copy) NSString *campaignName;
@property (nonatomic,copy) NSString *cmpState;
@property (nonatomic,copy) NSString *effDate;
@property (nonatomic,copy) NSString *expDate;
@property (nonatomic,copy) NSString *activityTimeInterval;
@property (nonatomic,copy) NSString *now;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,assign) float discountPercent;
@property (nonatomic,assign) float flsaleSaleQtyPercent;
@property (nonatomic,assign) float specialPrice;
@property (nonatomic,assign) NSInteger stockNum;



@end

@interface ProductImgContentModel : JSONModel
@property (nonatomic,copy) NSString *url;
@end

@interface FlashSaleCtgModel : JSONModel
@property (nonatomic,copy) NSString *catalogId;
@property (nonatomic,copy) NSString *cmpTypeId;
@property (nonatomic,copy) NSString *catalogName;
@property (nonatomic,copy) NSString *catalogCode;
@property (nonatomic,assign) BOOL sel;
@property (nonatomic,assign) float width;
@end

@interface FlashSaleProductModel : JSONModel
@property (nonatomic,strong) ProductImgContentModel *productImgContent;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *productImg;
@property (nonatomic,copy) NSString *productName;
@property (nonatomic,copy) NSString *specialPrice;
@property (nonatomic,copy) NSString *salesPrice;
@property (nonatomic,assign) double productSalePercent;
@property (nonatomic,assign) double stockNum;
@property (nonatomic,copy) NSString *offerId;
@property (nonatomic,copy) NSString *offerName;
@property (nonatomic,copy) NSString *discountPercent;
@property (nonatomic,copy) NSString *currencySymbol;
@property (nonatomic,copy) NSString *sppType;
@property (nonatomic,copy) NSString *evaluationAvg;
@property (nonatomic,assign) double evaluationCnt;
@property (nonatomic,assign) double productCmpSaleNum;





@end

NS_ASSUME_NONNULL_END
