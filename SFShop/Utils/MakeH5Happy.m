//
//  MakeH5Happy.m
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "MakeH5Happy.h"
#import "ProductDetailModel.h"

@implementation MakeH5Happy

/**
 此处添加容错，目前数据返回较为杂乱
 <ProductCarouselImgModel>
    [imgUrl]: /get/resource/1113434319518177730561438412161289424896.png
    [contentId]: 31698
    [url]: /get/resource/1113434319518177730561438412161289424896.mp4
    [bigImgUrl]: <nil>
    [contentType]: B
    [smallImgUrl]: <nil>
    [seq]: 1
 </ProductCarouselImgModel>
*/
+ (NSString *)getNonNullCarouselImageOf: (ProductCarouselImgModel *)imgModel {
    if (imgModel.imgUrl) {
        return imgModel.imgUrl;
    }
    if (imgModel.bigImgUrl) {
        return imgModel.bigImgUrl;
    }
    if (imgModel.smallImgUrl) {
        return imgModel.smallImgUrl;
    }
    if (imgModel.url) {
        return imgModel.url;
    }
    return nil;
}

/**
 将h5相对路径替换为绝对路径
 */
+ (NSString *)replaceHtmlSourceOfRelativeImageSource: (NSString *)htmlString {
    NSString *replacedHtmlString = [htmlString stringByReplacingOccurrencesOfString: @"src=\"" withString: [NSString stringWithFormat:@"src=\"%@", Host]];
    return replacedHtmlString;
}

@end
