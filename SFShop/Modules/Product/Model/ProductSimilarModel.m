//
//  ProductSimilarModel.m
//  SFShop
//
//  Created by Jacue on 2021/10/23.
//

#import "ProductSimilarModel.h"

@implementation ProductSimilarModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (CGFloat)height {
    CGFloat titleHeight = [NSString jk_heightTextContent:self.offerName withSizeFont:14 withMaxSize:CGSizeMake((MainScreen_width - KScale(12) * 3 - KScale(16) * 2)/2, 47)] + KScale(12);
                    
    CGFloat imageHeight = KScale(160);
    CGFloat tagHeight = 0;
    if (self.sppType.length> 0) {
        tagHeight = KScale(16) + KScale(16);
    }
    
    CGFloat gradeHeight = 0;
    if (self.evaluationAvg > 0 || self.evaluationCnt > 0) {
        gradeHeight = KScale(12) + KScale(12);
    }
    CGFloat priceHeight = KScale(6) + KScale(14);
    CGFloat discountHeight = self.discountPercent > 0 ? (KScale(4) + KScale(14)) : 0;
    CGFloat bottomSpace = 10;
    CGFloat theHeight = imageHeight + tagHeight + titleHeight + priceHeight + discountHeight + gradeHeight + bottomSpace;
    return theHeight;
}
@end
