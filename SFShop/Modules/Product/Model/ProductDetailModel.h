//
//  ProductDetailModel.h
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProductCarouselImgModel;

@interface ProductCarouselImgModel: JSONModel

@property(nonatomic, assign) NSInteger contentId;
@property(nonatomic, strong) NSString <Optional> *contentType;
@property(nonatomic, assign) NSInteger seq;
@property(nonatomic, strong) NSString <Optional> *url;
@property(nonatomic, strong) NSString <Optional> *imgUrl;
@property(nonatomic, strong) NSString <Optional> *bigImgUrl;
@property(nonatomic, strong) NSString <Optional> *smallImgUrl;

@end

@interface ProductDetailModel : JSONModel

@property(nonatomic, assign) NSInteger offerId;
@property(nonatomic, strong) NSString <Optional> *offerType;
@property(nonatomic, strong) NSString <Optional> *isNeedDelivery;
@property(nonatomic, strong) NSString <Optional> *deliveryMode;
@property(nonatomic, strong) NSString <Optional> *offerName;
@property(nonatomic, strong) NSString <Optional> *subheadName;
@property(nonatomic, assign) NSInteger salesPrice;
@property(nonatomic, assign) NSInteger marketPrice;
@property(nonatomic, strong) NSString <Optional> *goodsIntroduce;
@property(nonatomic, strong) NSString <Optional> *goodsDetails;
@property(nonatomic, assign) NSInteger storeId;
@property(nonatomic, strong) NSString <Optional> *storeName;
@property(nonatomic, strong) NSString <Optional> *storeType;
@property(nonatomic, strong) NSString <Optional> *storeLogoUrl;
@property(nonatomic, strong) NSString <Optional> *uccAccount;
@property(nonatomic, strong) NSArray <Optional> *offerSpecAttrs;
@property(nonatomic, strong) NSArray <ProductCarouselImgModel *> <ProductCarouselImgModel> *carouselImgUrls;
@property(nonatomic, strong) NSArray <Optional> *offerAttrValues;
@property(nonatomic, strong) NSArray <Optional> *products;

@end

NS_ASSUME_NONNULL_END
