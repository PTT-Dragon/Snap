//
//  FlashSaleModel.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "FlashSaleModel.h"

@implementation FlashSaleModel

@end

@implementation FlashSaleDateModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
@implementation FlashSaleCtgModel
- (float)width
{
    return [self.catalogName calWidth:kFontRegular(14) lineMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter limitSize:CGSizeMake(MAXFLOAT, 62)]+24;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
@implementation ProductImgContentModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
@implementation FlashSaleProductModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end



