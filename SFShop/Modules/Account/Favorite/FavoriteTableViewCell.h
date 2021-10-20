//
//  FavoriteTableViewCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import <UIKit/UIKit.h>
#import "favoriteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTableViewCell : UITableViewCell
- (void)setContent:(favoriteModel *)model;
@end

NS_ASSUME_NONNULL_END
