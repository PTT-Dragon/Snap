//
//  CategorySideTableView.h
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategorySideTableView : UITableView<UITableViewDataSource>

@property (nonatomic, readwrite, strong) NSMutableArray<CategoryModel *> *dataArray;

@end

NS_ASSUME_NONNULL_END
