//
//  MakeH5Happy.h
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ProductCarouselImgModel;

@interface MakeH5Happy : NSObject

// 此处添加容错，目前数据返回较为杂乱(url、imgUrl、bigImgUrl、smallImgUrl)
+ (NSString *)getNonNullCarouselImageOf: (ProductCarouselImgModel *)imgModel;
// 将h5相对路径替换为绝对路径
+ (NSString *)replaceHtmlSourceOfRelativeImageSource: (NSString *)htmlString;

@end

NS_ASSUME_NONNULL_END
