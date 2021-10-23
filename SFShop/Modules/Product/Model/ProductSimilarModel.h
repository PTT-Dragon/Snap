//
//  ProductSimilarModel.h
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductSimilarModel : JSONModel

// 当前价格
@property(nonatomic, assign) NSInteger salesPrice;
// 市场价
@property(nonatomic, assign) NSInteger marketPrice;
// 折扣
@property(nonatomic, assign) NSInteger discountPercent;
// 图片
@property(nonatomic, strong) NSString <Optional> *imgUrl;
// 产品标题
@property(nonatomic, strong) NSString <Optional> *offerName;


@end

NS_ASSUME_NONNULL_END
