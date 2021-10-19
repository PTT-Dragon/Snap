//
//  ArticleDetailModel.h
//  SFShop
//
//  Created by Jacue on 2021/9/25.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ArticleProduct;

@interface ArticleProduct : JSONModel

@property(nonatomic, strong) NSString <Optional> *attrValues;
@property(nonatomic, strong) NSString <Optional> *imgUrl;
@property(nonatomic, strong) NSString <Optional> *productName;
@property(nonatomic, assign) NSInteger offerId;
@property(nonatomic, assign) NSInteger productId;
@property(nonatomic, assign) NSInteger salesPrice;
//@property(nonatomic, assign) NSInteger specialPrice;

@end

@interface ArticleDetailModel : JSONModel

@property(nonatomic, strong) NSArray<NSString *> <Optional> *articlePictures;
@property(nonatomic, strong) NSString <Optional> *publisherName;
@property(nonatomic, strong) NSString <Optional> *profilePicture;
@property(nonatomic, strong) NSString <Optional> *articleDetail;
// 是否点赞
@property(nonatomic, strong) NSString <Optional> *isUseful;
@property(nonatomic, assign) NSInteger viewCnt;
@property(nonatomic, assign) NSInteger usefulCnt;
@property(nonatomic, assign) NSInteger replyCnt;
@property(nonatomic, strong) NSArray <ArticleProduct *> <ArticleProduct> *products;
@property(nonatomic, strong) NSString <Optional> *createdDate;


@end

NS_ASSUME_NONNULL_END
