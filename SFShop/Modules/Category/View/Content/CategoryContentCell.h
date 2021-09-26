//
//  CategoryContentCell.h
//  SFShop
//
//  Created by MasterFly on 2021/9/26.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryContentCell : UICollectionViewCell

@property (nonatomic, readwrite, strong) CategoryModel *model;

@end

NS_ASSUME_NONNULL_END
