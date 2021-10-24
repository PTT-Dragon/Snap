//
//  CategoryRankFilterItem.h
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import <UIKit/UIKit.h>
#import "CategoryRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryRankFilterItem : UICollectionViewCell

@property (nonatomic, readwrite, strong) CategoryRankFilterModel *model;

@end

NS_ASSUME_NONNULL_END
