//
//  SFSearchView.m
//  SFShop
//
//  Created by MasterFly on 2021/10/25.
//

#import "SFSearchView.h"
#import "YHRegularLayout.h"
#import "SFSearchCollectionCell.h"
#import "SFSearchSectionHeadView.h"
#import "SFSearchModel.h"
#import "NSString+Add.h"

@interface SFSearchView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@end

@implementation SFSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews {
    [self addSubview:self.collectionView];
}

- (void)layout {
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.dataArray objectAtIndex:section] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SFSearchSectionHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SFSearchSectionHeadView" forIndexPath:indexPath];
        return view;
    }
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFSearchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SFSearchCollectionCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 0;
    SFSearchModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (!model.width) {
        width = [model.name calWidth:[UIFont systemFontOfSize:14] lineMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter limitSize:CGSizeMake(200, 32)] + 12 * 2;
    }
    return CGSizeMake(100 , 32);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(MainScreen_width, 52);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(MainScreen_width, 0.0001);
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if(!_collectionView){
        YHRegularLayout *flow = [[YHRegularLayout alloc] init];
        flow.minimumInteritemSpacing = 8;
        flow.minimumLineSpacing = 8;
        flow.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        flow.headerReferenceSize = CGSizeMake(MainScreen_width, 13);
        flow.footerReferenceSize = CGSizeMake(MainScreen_width, 13);
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height - navBarHei) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:SFSearchCollectionCell.class forCellWithReuseIdentifier:@"SFSearchCollectionCell"];
        [_collectionView registerClass:SFSearchSectionHeadView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SFSearchSectionHeadView"];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        SFSearchModel *model = [SFSearchModel new];
        model.name = @"测试";
        model.sectionTitle = @"组标题";
        [_dataArray addObject:@[model]];
    }
    return _dataArray;
}

@end
