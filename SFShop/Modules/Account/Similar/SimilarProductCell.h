//
//  SimilarProductCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/27.
//

#import <UIKit/UIKit.h>
#import "ProductSimilarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SimilarProductCell : UICollectionViewCell
- (void)setContent:(ProductSimilarModel *)model;
@end

NS_ASSUME_NONNULL_END
