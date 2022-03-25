//
//  PosterViewCell.h
//  SFShop
//
//  Created by 游挺 on 2022/3/25.
//

#import <UIKit/UIKit.h>
#import "DistributorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosterViewCell : UICollectionViewCell
@property (nonatomic,strong) PosterPosterModel *model;
@property (nonatomic,strong) DistributorRankProductModel *productModel;
@end

NS_ASSUME_NONNULL_END
