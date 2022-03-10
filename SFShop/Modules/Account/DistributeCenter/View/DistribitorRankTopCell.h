//
//  DistribitorRankTopCell.h
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol DistribitorRankTopCellDelegate <NSObject>

- (void)selProductListType:(NSInteger)type;
- (void)toPRoductList;
@end

@interface DistribitorRankTopCell : UITableViewCell
@property (nonatomic,assign) id<DistribitorRankTopCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
