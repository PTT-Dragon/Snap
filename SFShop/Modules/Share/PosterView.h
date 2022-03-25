//
//  PosterView.h
//  SFShop
//
//  Created by 游挺 on 2022/3/24.
//

#import <UIKit/UIKit.h>
#import "DistributorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosterView : UIView
@property (nonatomic,strong) NSArray <PosterPosterModel *>*posterModelArr;
@property (nonatomic,strong) DistributorRankProductModel *productModel;
@end

NS_ASSUME_NONNULL_END
