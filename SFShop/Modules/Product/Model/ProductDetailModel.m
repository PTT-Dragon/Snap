//
//  ProductDetailModel.m
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "ProductDetailModel.h"
#import "NSString+Add.h"

@implementation ProductCarouselImgModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ProductAttrValueModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end


@implementation ProductAttrModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ProductItemModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ProductDetailModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ProductEvalationReplayModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation ProductEvalationModel
- (CGFloat)itemHie
{
    //计算label高度
    CGFloat labelHei = 0;
    labelHei = [self.evaluationComments calHeightWithFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width-24, MAXFLOAT)];
    //计算图片高度
    CGFloat itemHei = (MainScreen_width-34-30)/4;
    CGFloat imageHei = 0;
    imageHei = self.evaluationContents.count == 0 ? 0: self.evaluationContents.count < 4 ? itemHei+5: self.evaluationContents.count < 8 ? 2*itemHei+10: 3* itemHei + 15;
    return labelHei + imageHei+78;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
