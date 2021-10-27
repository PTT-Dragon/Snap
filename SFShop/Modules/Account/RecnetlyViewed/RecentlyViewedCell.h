//
//  RecentlyViewedCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/25.
//

#import <UIKit/UIKit.h>
#import "RecentlyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentlyViewedCell : UITableViewCell
- (void)setContent:(RecentlyModel *)model;
@end

NS_ASSUME_NONNULL_END
