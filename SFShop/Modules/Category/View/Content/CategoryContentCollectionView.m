//
//  CategoryContentCollectionView.m
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import "CategoryContentCollectionView.h"
#import "CategoryContentCell.h"
#import "CategoryContentSectionHeader.h"
#import "CategoryContentSectionFooter.h"

@implementation CategoryContentCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        [self registerClass:[CategoryContentCell class] forCellWithReuseIdentifier:@"CategoryContentCell"];
        [self registerClass:[CategoryContentSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryContentSectionHeader"];
        [self registerClass:[CategoryContentSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CategoryContentSectionFooter"];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryContentCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CategoryContentSectionHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryContentSectionHeader" forIndexPath:indexPath];
        CategoryModel *model = self.dataArray[indexPath.section][indexPath.row];
        view.titleLabel.text = model.inner.catgName;
        return view;
    }
    
    CategoryContentSectionFooter *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CategoryContentSectionFooter" forIndexPath:indexPath];
    return view;
}


#pragma mark - Getter
- (NSMutableArray<NSArray<CategoryModel *> *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
