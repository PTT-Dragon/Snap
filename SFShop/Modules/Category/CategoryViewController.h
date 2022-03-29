//
//  CategoryViewController.h
//  SFShop
//
//  Created by MasterFly on 2021/9/24.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryViewController : UIPageViewController
@property (nonatomic,strong) CategoryModel *selCategoryModel;//记录选中的分类
@end

NS_ASSUME_NONNULL_END
