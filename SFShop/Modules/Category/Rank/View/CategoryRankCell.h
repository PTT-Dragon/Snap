//
//  CategoryRankCell.h
//  SFShop
//
//  Created by MasterFly on 2021/10/12.
//

#import <UIKit/UIKit.h>
#import "CategoryRankModel.h"
#import "ProductSimilarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryRankCell : UICollectionViewCell

/// 0: colletion 样式 1:tableview 样式 (⚠️,这个需要在数据源之前赋值)
@property (nonatomic, readwrite, assign) NSInteger showType;

/// 数据源
@property (nonatomic, readwrite, strong) CategoryRankPageInfoListModel *model;

/// 数据源2
@property (nonatomic, strong) ProductSimilarModel *similarModel;

@end

NS_ASSUME_NONNULL_END
