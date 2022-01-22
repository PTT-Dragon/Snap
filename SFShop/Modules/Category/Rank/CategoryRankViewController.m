//
//  CategoryRankViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import "CategoryRankViewController.h"
#import "CommunityWaterfallLayout.h"
#import "CategoryRankModel.h"
#import "CategoryRankCell.h"
#import <MJRefresh/MJRefresh.h>
#import "CategoryRankHeadSelectorView.h"
#import "CategoryRankFilterViewController.h"
#import "CategoryRankFilterCacheModel.h"
#import "SFSearchNav.h"
#import "SFSearchView.h"
#import "ProductViewController.h"
#import "CategoryRankNoItemsView.h"
#import "CollectionHeaderEmptyView.h"

@interface CategoryRankViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CommunityWaterfallLayoutProtocol>

@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) CategoryRankHeadSelectorView *headSelectorView;
@property (nonatomic, readwrite, strong) CommunityWaterfallLayout *waterfallLayout;
@property (nonatomic, readwrite, assign) NSInteger currentPage;
@property (nonatomic, readwrite, assign) CategoryRankType currentType;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;
@property (nonatomic, readwrite, assign) BOOL showType;//显示类型 0:colletion 1:list
@property (nonatomic, readwrite, assign) BOOL showEmptyView;//是否显示空视图
@property (nonatomic, readwrite, strong) CollectionHeaderEmptyView *emptyView;//是否显示空视图

@end

@implementation CategoryRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadsubviews];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadDatas:(NSInteger)currentPage sortType:(CategoryRankType)type filter:(CategoryRankFilterCacheModel *)filter {
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
        @"q": filter.qs ? filter.qs: @"",
        @"pageIndex": @(currentPage),
        @"pageSize": @(10),
        @"sortType": [NSString stringWithFormat:@"%ld",type],
        @"offerIdList": [NSNull null],
        @"catgIds": filter.qs ? @"":@(self.model.inner.catgRela.objValue.objId),//默认是外部传入的分类,如果 filter.filterParam 有该字段,会被新值覆盖
    }];
    [parm addEntriesFromDictionary:filter.filterParam];
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        self.dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
        }
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.dataArray addObjectsFromArray:self.dataModel.pageInfo.list];
        [self refreshNoItemsStatus];
        [self.collectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadDatasIfDataISEmpty  {
    NSDictionary *parm = @{
        @"catgIds" : @"",
        @"q": @"",
        @"pageIndex": @(1),
        @"pageSize": @(10),
        @"sortType": @"1",
    };
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        self.dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        [self.dataArray addObjectsFromArray:self.dataModel.pageInfo.list];
        [self.collectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

- (void)loadsubviews {
    [self.view addSubview:self.navSearchView];
    [self.view addSubview:self.headSelectorView];
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        if (!self.showEmptyView) {
            [self loadDatas:self.currentPage sortType:self.currentType filter:self.filterCacheModel];
        } else {
            [MBProgressHUD hideFromKeyWindow];
            [self.collectionView.mj_header endRefreshing];
        }
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage += 1;
        if (!self.showEmptyView) {
            [self loadDatas:self.currentPage sortType:self.currentType filter:self.filterCacheModel];
        } else {
            [MBProgressHUD hideFromKeyWindow];
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Event
- (void)jumpToFilterDetail {
    //加载缓存配置到数据层
    self.dataModel.filterCache = self.filterCacheModel;
    
    CategoryRankPriceModel *priceModel = [CategoryRankPriceModel new];
    priceModel.minPrice = self.filterCacheModel.minPrice;
    priceModel.maxPrice = self.filterCacheModel.maxPrice;
    self.dataModel.priceModel = priceModel;
    for (CategoryRankServiceModel *model in self.dataModel.serviceIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.serverId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankCategoryModel *model in self.dataModel.catgIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.categoryId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankBrandModel *model in self.dataModel.brandIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.brandId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankEvaluationModel *model in self.dataModel.evaluations) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.evaluationId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        [self resetIfEmpty];
        self.dataModel = model;
        self.filterCacheModel = self.dataModel.filterCache;
        [self.collectionView.mj_header beginRefreshing];
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}

- (void)refreshNoItemsStatus {
    if (!self.dataArray.count) {
        self.showEmptyView = YES;
        [self loadDatasIfDataISEmpty];
    } else {
        self.showEmptyView = NO;
    }
}

- (void)resetIfEmpty {
    if (self.showEmptyView) {
        [self.dataArray removeAllObjects];
        self.showEmptyView = NO;
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductViewController *productVC = [[ProductViewController alloc] init];
    productVC.offerId = ((CategoryRankPageInfoListModel *)self.dataArray[indexPath.row]).offerId;
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankCell" forIndexPath:indexPath];
    CategoryRankPageInfoListModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    cell.showType = self.showType;
    return cell;
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.showType) {
        CategoryRankPageInfoListModel *cellModel = self.dataArray[indexPath.row];
        if (!cellModel.height) {
            
            CGFloat titleHeight = [cellModel.offerName calHeightWithFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width - KScale(12) * 3 - KScale(16) * 2, 100)];
            CGFloat imageHeight = KScale(166);
            CGFloat tagHeight = 0;
            if (cellModel.sppType.length> 0) {
                tagHeight = KScale(14) + KScale(16);
            }
            
            CGFloat gradeHeught = 0;
            if (cellModel.evaluationAvg.length > 0 || cellModel.evaluationCnt > 0) {
                gradeHeught = KScale(12) + KScale(12);
            }
            CGFloat priceHeight = KScale(14);
            CGFloat discountHeight = KScale(14);
            cellModel.height = imageHeight + tagHeight + KScale(12) + titleHeight + KScale(6) + priceHeight + KScale(4) + discountHeight + KScale(12) + gradeHeught + KScale(12);
        }
        return cellModel.height;
    } else {
        return 160;
    }
}

- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showEmptyView) {
        return 400;
    }
    self.emptyView.hidden = YES;
    return 0.01;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeaderEmptyView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kSupplementaryViewKindHeader withReuseIdentifier:@"CollectionHeader" forIndexPath:indexPath];
    [header configDataWithEmptyType:EmptyViewNoProductType];
    if (self.dataArray.count > 0) {
        [header updateTitle:kLocalizedString(@"RECCOMENDATION")];
    } else {
        [header updateTitle:@""];
    }
    header.hidden = !self.showEmptyView;
    self.emptyView = header;
    return header;
}

#pragma mark - Get and Set
- (SFSearchNav *)navSearchView {
    if (_navSearchView == nil) {
        SFSearchItem *backItem = [SFSearchItem new];
        backItem.icon = @"nav_back";
        backItem.itemActionBlock = ^(SFSearchModel *model,BOOL isSelected) {
            [self.navigationController popViewControllerAnimated:YES];
        };
        SFSearchItem *rightItem = [SFSearchItem new];
        rightItem.icon = @"nav_addition";
        rightItem.selectedIcon = @"nav_addtion_list";
        rightItem.itemActionBlock = ^(SFSearchModel * _Nullable model,BOOL isSelected) {
            self.showType = isSelected;
            if (self.showType) {
                self.waterfallLayout.columns = 1;
                self.waterfallLayout.columnSpacing = 0;
                self.waterfallLayout.insets = UIEdgeInsetsZero;
            } else {
                self.waterfallLayout.columns = 2;
                self.waterfallLayout.columnSpacing = KScale(12);
                self.waterfallLayout.insets = UIEdgeInsetsMake(KScale(12), KScale(16), KScale(12), KScale(16));
            }
            [self.collectionView reloadData];
        };
        __weak __typeof(self)weakSelf = self;
        _navSearchView = [[SFSearchNav alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, navBarHei + 10) backItme:backItem rightItem:rightItem searchBlock:^(NSString * _Nonnull qs) {
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            if (![qs isEqualToString:strongSelf.filterCacheModel.qs]) {
                [strongSelf resetIfEmpty];
                strongSelf.filterCacheModel.qs = qs;
                [strongSelf.collectionView.mj_header beginRefreshing];
            }
        }];
    }
    return _navSearchView;
}

- (UICollectionView *)collectionView {
    if(!_collectionView){
        _waterfallLayout = [[CommunityWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = KScale(12);
        _waterfallLayout.insets = UIEdgeInsetsMake(KScale(12), KScale(16), KScale(12), KScale(16));
        
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 10 + navBarHei + KScale(64), MainScreen_width, MainScreen_height - 10 - navBarHei - KScale(64)) collectionViewLayout:_waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor clearColor];

        [_collectionView registerClass:CategoryRankCell.class forCellWithReuseIdentifier:@"CategoryRankCell"];
        [_collectionView registerClass:CollectionHeaderEmptyView.class forSupplementaryViewOfKind:kSupplementaryViewKindHeader withReuseIdentifier:@"CollectionHeader"];
    }
    return _collectionView;
}

- (CategoryRankHeadSelectorView *)headSelectorView {
    if (_headSelectorView == nil) {
        _headSelectorView = [[CategoryRankHeadSelectorView alloc] initWithFrame:CGRectMake(0, navBarHei + 10, MainScreen_width, KScale(64)) type:CategoryRankTypePopularity];
        __weak __typeof(self)weakSelf = self;
        _headSelectorView.clickFilterBlock = ^(CategoryRankType type) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            switch (type) {
                case CategoryRankTypePopularity:
                case CategoryRankTypeSales:
                case CategoryRankTypePriceDescending:
                case CategoryRankTypePriceAscending: {
                    [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
                    strongSelf.currentType = type;
                    [strongSelf.collectionView.mj_header beginRefreshing];
                }
                    break;
                case CategoryRankTypeDetail:
                    [strongSelf jumpToFilterDetail];
                    break;
                default:
                    break;
            }
        };
    }
    return _headSelectorView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (CategoryRankFilterCacheModel *)filterCacheModel {
    if (_filterCacheModel == nil) {
        _filterCacheModel = [[CategoryRankFilterCacheModel alloc] init];
        self.filterCacheModel.minPrice = -1;//初始化为-1,传参时,传入@""表示没有指定min价格
        self.filterCacheModel.maxPrice = -1;//初始化为-1,传参时,传入@""表示没有指定max价格
    }
    return _filterCacheModel;
}

@end
