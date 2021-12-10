//
//  ProductReviewLabelCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"
#import "FlashSaleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductReviewLabelCell : UICollectionViewCell
@property (nonatomic,strong) ProductEvalationLabelsModel *model;
@property (nonatomic,strong) FlashSaleCtgModel *ctgModel;
@end

NS_ASSUME_NONNULL_END
