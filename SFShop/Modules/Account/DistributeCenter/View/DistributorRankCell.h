//
//  DistributorRankCell.h
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import <UIKit/UIKit.h>
#import "DistributorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributorRankCell : UITableViewCell
@property (nonatomic,weak) DistributorRankProductModel *model;
@property (nonatomic,assign) NSInteger rank;
@property (nonatomic,strong) DistributorModel *centerModel;
@end

NS_ASSUME_NONNULL_END
