//
//  CategoryRankFilterViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import "CategoryRankFilterViewController.h"
#import "YHRegularLayout.h"
#import "CategoryRankFilterItem.h"
#import "CategoryRankModel.h"
#import "UIButton+EnlargeTouchArea.h"
#import "CategoryRankFilterHeader.h"
#import "CategoryRankFilterInputItem.h"
#import "CategoryRankFilterCacheModel.h"

@interface CategoryRankFilterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, readwrite, strong) UIView *bottomView;
@property (nonatomic, readwrite, strong) UIButton *resetBtn;
@property (nonatomic, readwrite, strong) UIButton *confirmBtn;
@property (nonatomic, readwrite, strong) UIButton *closeBtn;
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray *> *dataArray;
@end


#define FooterHeight 78

@implementation CategoryRankFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadSubviews];
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)loadSubviews {
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.resetBtn];
    [self.bottomView addSubview:self.confirmBtn];
}

- (void)layout {
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(statuBarHei + 8);
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(16);
        make.height.mas_equalTo(46);
        make.right.equalTo(self.confirmBtn.mas_left).offset(-6);
        make.width.equalTo(self.confirmBtn.mas_width);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(46);
        make.left.equalTo(self.resetBtn.mas_right).offset(6);
        make.width.equalTo(self.resetBtn.mas_width);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(FooterHeight);
    }];
}

#pragma mark - Event
- (void)dismiss:(void(^)(void))complete {
    [self dismissViewControllerAnimated:YES completion:^{
        !complete ?: complete();
    }];
}

- (void)cancel {
    [self dismiss:^{
        !self.filterRefreshBlock ?: self.filterRefreshBlock(CategoryRankFilterRefreshCancel,self.model);
    }];
}

- (void)reset {
    self.model.filterCache = nil;
    self.model.priceModel = nil;
    [self.dataArray removeAllObjects];
    [self dismiss:^{
        !self.filterRefreshBlock ?: self.filterRefreshBlock(CategoryRankFilterRefreshReset,self.model);
    }];
}

- (void)confirm {
    [self dismiss:^{
        !self.filterRefreshBlock ?: self.filterRefreshBlock(CategoryRankFilterRefreshUpdate,self.model);
    }];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankFilterModel *cellModel = self.dataArray[indexPath.section][indexPath.row];
    if ([cellModel isKindOfClass:CategoryRankFilterModel.class]) {
        
        BOOL originSelected = cellModel.isSelected;
        BOOL isSupportMul = cellModel.isSupportMul;
        
        //先全部重置isSelected
        if (!isSupportMul) {
            NSArray *arr = self.dataArray[indexPath.section];
            for (CategoryRankFilterModel *filter in arr) {
                filter.isSelected = NO;
            }
        }
        
        //设置当前的selected
        CategoryRankFilterModel *model = cellModel;
        model.isSelected = !originSelected;
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        
        //存储数据到缓存中
        if ([cellModel isKindOfClass:CategoryRankServiceModel.class]) {
            self.model.filterCache.serverId = model.isSelected?model.idStr:nil;
        } else if ([cellModel isKindOfClass:CategoryRankBrandModel.class]) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[self.model.filterCache.brandId componentsSeparatedByString:@","]];
            if (!arr.count && self.model.filterCache.brandId.length > 0) {
                [arr addObject:self.model.filterCache.brandId];
            }
            if (model.isSelected && ![arr containsObject:model.idStr]) {
                [arr addObject:model.idStr];
            } else if (!model.isSelected && [arr containsObject:model.idStr]) {
                [arr removeObject:model.idStr];
            }
            NSString *brandId = [arr componentsJoinedByString:@","];
            self.model.filterCache.brandId = brandId;
        } else if ([cellModel isKindOfClass:CategoryRankCategoryModel.class]) {
            self.model.filterCache.categoryId = model.isSelected?model.idStr:nil;
        } else if ([cellModel isKindOfClass:CategoryRankEvaluationModel.class]) {
            self.model.filterCache.evaluationId = model.isSelected?model.idStr:nil;
        } else if ([cellModel isKindOfClass:CategoryRankAttrModel.class]) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.model.filterCache.offerAttrValues];
            CategoryRankAttrModel *removeModel = nil;
            for (CategoryRankAttrModel *cacheModel in self.model.filterCache.offerAttrValues) {
                if ([cacheModel.idStr isEqualToString:model.idStr]) {
                    removeModel = cacheModel;
                }
            }
            if (model.isSelected && !removeModel) {
                [arr addObject:model];
            } else if (!model.isSelected && removeModel) {
                [arr removeObject:removeModel];
            }
            self.model.filterCache.offerAttrValues = arr;
        }
    }
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
        CategoryRankFilterHeader *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryRankFilterHeader" forIndexPath:indexPath];
        CategoryRankFilterModel *model = [self.dataArray objectAtIndex:indexPath.section].firstObject;
        view.titleLabel.text = model.groupName;
        return view;
    }
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cellModel = self.dataArray[indexPath.section][indexPath.row];
    if ([cellModel isKindOfClass:CategoryRankFilterModel.class]) {
        CategoryRankFilterItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankFilterItem" forIndexPath:indexPath];
        CategoryRankFilterModel *model = cellModel;
        cell.model = model;
        return cell;
    } else if ([cellModel isKindOfClass:CategoryRankPriceModel.class]){
        CategoryRankPriceModel *model = cellModel;
        CategoryRankFilterInputItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankFilterInputItem" forIndexPath:indexPath];
        __weak __typeof(self)weakSelf = self;
        cell.priceIntervalBlock = ^(NSInteger price, BOOL minOrMax) {
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            if (minOrMax) {
                model.minPrice = price;
                strongSelf.model.filterCache.minPrice = price;
            } else {
                model.maxPrice = price;
                strongSelf.model.filterCache.maxPrice = price;
            }
        };
        cell.model = cellModel;
        return cell;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 0;
    id cellModel = self.dataArray[indexPath.section][indexPath.row];
    if ([cellModel isKindOfClass:CategoryRankFilterModel.class]) {
        CategoryRankFilterModel *model = cellModel;
        width = [model.name calWidth:[UIFont systemFontOfSize:14] lineMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter limitSize:CGSizeMake(MainScreen_width - 16 * 2, 32)] + 12 * 2;
    } else if ([cellModel isKindOfClass:CategoryRankPriceModel.class]) {
        return CGSizeMake(MainScreen_width - 16 * 2 , 46);
    }
    return CGSizeMake(width , 32);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(MainScreen_width, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(MainScreen_width, 16);
}

#pragma mark - Getter
- (void)setModel:(CategoryRankModel *)model {
    _model = model;
    
    CategoryRankPriceModel *priceModel = [CategoryRankPriceModel new];
    priceModel.minPrice = model.filterCache.minPrice;
    priceModel.maxPrice = model.filterCache.maxPrice;
    model.priceModel = priceModel;
    
    //组装需要显示的数据
    NSMutableArray *arr = [NSMutableArray array];
//    if (model.serviceIds && model.serviceIds.count > 0) {
//        [arr addObject:model.serviceIds];
//    }
    if (model.catgIds && model.catgIds.count > 0) {
        [arr addObject:model.catgIds];
    }
    if (model.brandIds && model.brandIds.count > 0) {
        [arr addObject:model.brandIds];
    }
    if (model.priceModel) {
        [arr addObject:@[model.priceModel]];
    }
    if (model.evaluations && model.evaluations.count > 0) {
        [arr addObject:model.evaluations];
    }
    if (model.offerAttrValues && model.offerAttrValues.count > 0) {
        [arr addObject:model.offerAttrValues];
    }
    for (NSArray *subArr in arr) {
        if (subArr.count) {
            [self.dataArray addObject:[NSMutableArray arrayWithArray:subArr]];
        }
    }
    
    //选中数据
    for (CategoryRankServiceModel *subModel in model.serviceIds) {
        if (subModel.idStr && [subModel.idStr isEqualToString:model.filterCache.serverId]) {
            subModel.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankCategoryModel *subModel in model.catgIds) {
        if (subModel.idStr && [subModel.idStr isEqualToString:model.filterCache.categoryId]) {
            subModel.isSelected = YES;
            break;
        }
    }

    for (CategoryRankBrandModel *subModel in model.brandIds) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[model.filterCache.brandId componentsSeparatedByString:@","]];
        if (!arr.count && model.filterCache.brandId.length > 0) {
            [arr addObject:model.filterCache.brandId];
        }
        for (NSString *idStr in arr) {
            if (subModel.idStr && [subModel.idStr isEqualToString:idStr]) {
                subModel.isSelected = YES;
            }
        }
    }

    for (CategoryRankEvaluationModel *subModel in model.evaluations) {
        if (subModel.idStr && [subModel.idStr isEqualToString:model.filterCache.evaluationId]) {
            subModel.isSelected = YES;
            break;
        }
    }

    for (CategoryRankAttrModel *subModel in model.offerAttrValues) {
        for (CategoryRankAttrModel *cacheModel in model.filterCache.offerAttrValues) {
            if (subModel.idStr && [subModel.idStr isEqualToString:cacheModel.idStr]) {
                subModel.isSelected = YES;
            }
        }
    }
}

- (UICollectionView *)collectionView {
    if(!_collectionView){
        YHRegularLayout *flow = [[YHRegularLayout alloc] init];
        flow.minimumInteritemSpacing = 8;
        flow.minimumLineSpacing = 8;
        flow.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        flow.headerReferenceSize = CGSizeMake(MainScreen_width, 13);
        flow.footerReferenceSize = CGSizeMake(MainScreen_width, 13);
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height - navBarHei - FooterHeight) collectionViewLayout:flow];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:CategoryRankFilterInputItem.class forCellWithReuseIdentifier:@"CategoryRankFilterInputItem"];
        [_collectionView registerClass:CategoryRankFilterItem.class forCellWithReuseIdentifier:@"CategoryRankFilterItem"];
        [_collectionView registerClass:CategoryRankFilterHeader.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CategoryRankFilterHeader"];
        [_collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _collectionView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_closeBtn setImage:[UIImage imageNamed:@"nav_close_bold"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)resetBtn {
    if (_resetBtn == nil) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        [_resetBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_resetBtn setTitle:@"RESET" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor jk_colorWithHexString:@"#FF1659"] forState:UIControlStateNormal];
        _resetBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#FF1659"].CGColor;
        _resetBtn.layer.borderWidth = 1;
        _resetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _resetBtn;
}

- (UIButton *)confirmBtn {
    if (_confirmBtn == nil) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_confirmBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor jk_colorWithHexString:@"#FF1659"]];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _confirmBtn;
}

- (NSMutableArray<NSMutableArray *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
