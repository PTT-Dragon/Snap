//
//  ProductDetailModel.h
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "JSONModel.h"
#import "CartModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProductCarouselImgModel;
@protocol ProductAttrModel;
@protocol ProductAttrValueModel;
@protocol ProdSpcAttrsModel;
@protocol ProductItemModel;

@interface ProductCarouselImgModel: JSONModel

@property(nonatomic, assign) NSInteger contentId;
@property(nonatomic, strong) NSString *contentType;
@property(nonatomic, assign) NSInteger seq;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *imgUrl;
@property(nonatomic, strong) NSString *bigImgUrl;
@property(nonatomic, strong) NSString *smallImgUrl;

@end

@interface ProductAttrValueModel: JSONModel

@property(nonatomic, assign) NSInteger seq;
@property(nonatomic, strong) NSString *value;

@end


@interface ProductAttrModel: JSONModel

@property(nonatomic, strong) NSString *attrId;
@property(nonatomic, assign) NSInteger seq;
@property(nonatomic, strong) NSString *attrName;
@property(nonatomic, strong) NSArray <ProductAttrValueModel *> <ProductAttrValueModel> *attrValues;

@end

@interface ProductItemModel: JSONModel

@property(nonatomic, assign) NSInteger productId;
@property(nonatomic, strong) NSString *productName;
@property(nonatomic, strong) NSString *productRemark;
@property(nonatomic, assign) NSInteger salesPrice;
@property(nonatomic, assign) NSInteger marketPrice;
@property(nonatomic, assign) NSInteger minBuyCount;
@property(nonatomic, assign) NSInteger maxBuyCount;
@property(nonatomic, strong) NSString *isCollection;
@property(nonatomic, strong) NSString *imgUrl;
@property (nonatomic,strong) NSArray <ProdSpcAttrsModel *> <ProdSpcAttrsModel> *prodSpcAttrs;

@end

@interface ProductDetailModel : JSONModel

@property(nonatomic, assign) NSInteger offerId;
@property(nonatomic, strong) NSString *offerType;
@property(nonatomic, strong) NSString *isNeedDelivery;
@property(nonatomic, strong) NSString *deliveryMode;
@property(nonatomic, strong) NSString *offerName;
@property(nonatomic, strong) NSString *subheadName;
@property(nonatomic, assign) NSInteger salesPrice;
@property(nonatomic, assign) NSInteger marketPrice;
@property(nonatomic, strong) NSString *goodsIntroduce;
@property(nonatomic, strong) NSString *goodsDetails;
@property(nonatomic, assign) NSInteger storeId;
@property(nonatomic, strong) NSString *storeName;
@property(nonatomic, strong) NSString *storeType;
@property(nonatomic, strong) NSString *storeLogoUrl;
@property(nonatomic, strong) NSString *uccAccount;
@property(nonatomic, strong) NSArray <ProductAttrModel *> <ProductAttrModel> *offerSpecAttrs;
@property(nonatomic, strong) NSArray <ProductCarouselImgModel *> <ProductCarouselImgModel> *carouselImgUrls;
@property(nonatomic, strong) NSArray *offerAttrValues;
@property(nonatomic, strong) NSArray <ProductItemModel *> <ProductItemModel> *products;

@end

NS_ASSUME_NONNULL_END
