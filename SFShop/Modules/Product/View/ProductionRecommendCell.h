//
//  ProductionRecommendCell.h
//  SFShop
//
//  Created by Jacue on 2021/12/26.
//

#import <UIKit/UIKit.h>
#import "ProductSimilarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductionRecommendCell : UICollectionViewCell

@property (nonatomic, readwrite, strong) ProductSimilarModel *model;

@end

NS_ASSUME_NONNULL_END
