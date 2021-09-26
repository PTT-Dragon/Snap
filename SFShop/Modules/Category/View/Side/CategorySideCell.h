//
//  CategorySideCell.h
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategorySideCell : UITableViewCell

@property (nonatomic, readwrite, strong) CategoryModel *model;

@end

NS_ASSUME_NONNULL_END
