//
//  CategoryContentCollectionView.h
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryContentCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, readwrite, strong) NSMutableArray<NSArray<CategoryModel *> *> *dataArray;

@end

NS_ASSUME_NONNULL_END
