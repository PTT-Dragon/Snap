//
//  MGCShareCollectionViewCell.h
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/5/6.
//

#import <UIKit/UIKit.h>
#import "MGCShareItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGCShareCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MGCShareItemModel *itemModel;

- (void)configDataWithItemModel:(MGCShareItemModel *)itemModel;

@end

NS_ASSUME_NONNULL_END
