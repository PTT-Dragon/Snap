//
//  CommunitySelectTableViewCell.h
//  SFShop
//
//  Created by Lufer on 2022/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunitySelectTableViewCell : UITableViewCell

+ (instancetype)selectCellWithTableView:(UITableView *)tableView
                                 cellId:(NSString *)cellId;

- (void)configDataWithTitle:(NSString *)title
             isFavoriteType:(BOOL)isFavoriteType isRecommend:(BOOL)isRecommend;
@end

NS_ASSUME_NONNULL_END
