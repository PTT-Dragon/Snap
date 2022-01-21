//
//  favoriteModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/20.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum :NSUInteger{
    ALLTYPE,
    PRICEDOWNTYPE,
    PROMOTIONTYPE
}FavoriteType;

@interface favoriteModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*brandId;
@property (nonatomic,copy) NSString <Optional>*brandName;
@property (nonatomic,copy) NSString <Optional>*currencySymbol;
@property (nonatomic,copy) NSString <Optional>*cutRate;
@property (nonatomic,copy) NSString <Optional>*evaluationAvg;
@property (nonatomic,copy) NSString <Optional>*evaluationCnt;
@property (nonatomic,copy) NSString <Optional>*evaluationRate;
@property (nonatomic,copy) NSString <Optional>*goodsIntroduce;
@property (nonatomic,copy) NSString <Optional>*imgUrl;
@property (nonatomic,copy) NSString <Optional>*markdownPrice;
@property (nonatomic,copy) NSString <Optional>*marketPrice;
@property (nonatomic,copy) NSString <Optional>*offerId;
@property (nonatomic,copy) NSString <Optional>*offerName;
@property (nonatomic,copy) NSString <Optional>*offerType;
@property (nonatomic,copy) NSString <Optional>*productId;
@property (nonatomic,copy) NSString <Optional>*productName;
@property (nonatomic,copy) NSString <Optional>*salesCnt;
@property (nonatomic,copy) NSString <Optional>*salesPrice;
@property (nonatomic,copy) NSString <Optional>*storeId;
@property (nonatomic,copy) NSString <Optional>*storeLogoUrl;
@property (nonatomic,copy) NSString <Optional>*subheadName;
@property (nonatomic,copy) NSString <Optional>*storeName;
@property (nonatomic,copy) NSString <Optional>*topDate;
@property (nonatomic,copy) NSString <Optional>*userCollectionOfferId;
@end

@interface favoriteVCModel : JSONModel
@property (nonatomic,assign) FavoriteType type;
@property (nonatomic,assign) float maxPrice;
@property (nonatomic,assign) float minPrice;
@property (nonatomic,assign) NSInteger catgId;

@end

@interface FavoriteNumModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*totalNum;
@property (nonatomic,copy) NSString <Optional>*priceDownNum;

@end

NS_ASSUME_NONNULL_END
