//
//  DistributorInfoCell.h
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import <UIKit/UIKit.h>
#import "DistributorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DistributorInfoCell : UITableViewCell
@property (nonatomic,weak) DistributionSettlementDtoModel *model;
- (void)setContent:(DistributionSettlementDtoModel *)model type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
