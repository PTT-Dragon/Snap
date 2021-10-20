//
//  CategoryRankCell.h
//  SFShop
//
//  Created by MasterFly on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import "CategoryRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryRankCell : UICollectionViewCell

@property (nonatomic, readwrite, strong) CategoryRankPageInfoListModel *model;

@end

NS_ASSUME_NONNULL_END
