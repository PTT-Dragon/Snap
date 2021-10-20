//
//  favoriteModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/20.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

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
/**
 {
brandId = 202;
brandName = OPPO;
currencySymbol = Rp;
cutRate = "0%";
evaluationAvg = 5;
evaluationCnt = 4;
evaluationRate = 1;
goodsIntroduce = "<null>";
imgUrl = "/get/resource/\U4e3b\U56fe 21405803944797671424.jpg";
labels =             (
);
markdownPrice = 0;
marketPrice = 1599000;
offerId = 1206;
offerName = "Oppo Enco Q1 TWS";
offerType = P;
productId = 2328;
productName = "Oppo Enco Q1 TWS JERUK";
salesCnt = 8;
salesPrice = 1440000;
storeId = 15;
storeLogoUrl = "/get/resource/f11450338409762656256.jpg";
storeName = NeuKoo;
subheadName = "";
topDate = "2021-10-17 20:42:05";
userCollectionOfferId = 20001;
}
 **/
@end

NS_ASSUME_NONNULL_END
