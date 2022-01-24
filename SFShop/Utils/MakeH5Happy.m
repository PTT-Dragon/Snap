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
    [replacedHtmlString stringByAppendingFormat:@""];
    replacedHtmlString = [replacedHtmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    replacedHtmlString = [replacedHtmlString stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    replacedHtmlString = [replacedHtmlString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    replacedHtmlString = [replacedHtmlString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    replacedHtmlString = [replacedHtmlString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    
    
//    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
//                       "<head> \n"
//                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
//                       "<style type=\"text/css\"> \n"
//                       "body {font-size:15px;}\n"
//                       "</style> \n"
//                       "</head> \n"
//                       "<body>"
//                       "<script type='text/javascript'>"
//                       "window.onload = function(){\n"
//                       "var $img = document.getElementsByTagName('img');\n"
//                       "for(var p in  $img){\n"
//                       " $img[p].style.width = '100%%';\n"
//                       "$img[p].style.height ='auto'\n"
//                       "}\n"
//                       "}"
//                       "</script>%@"
//                       "</body>"
//                       "</html>",replacedHtmlString];
    
    
    return replacedHtmlString;
}

@end
