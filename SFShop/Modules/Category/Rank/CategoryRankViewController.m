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
#import "SceneManager.h"

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
@property (nonatomic, readwrite, assign, getter=isInitLoad) BOOL initLoad;//是否初始加载
@property (nonatomic, readwrite, assign, getter=isReloadFilter) BOOL reloadFilter;//是否刷新筛选标签
@property (nonatomic, readwrite, strong) CollectionHeaderEmptyView *emptyView;//是否显示空视图

@end

@implementation CategoryRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.initLoad = YES;
    self.reloadFilter = YES;
    self.currentType = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadsubviews];
    self.navSearchView.activeSearch = self.activeSearch;
    if (!self.activeSearch) {
        [self.collectionView.mj_header beginRefreshing];
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


/*
 1、搜索会重置所有的筛选和外部传入的初始化参数
 2、筛选会重置传入的初始化参数
 */
- (void)loadDatas:(NSInteger)currentPage sortType:(CategoryRankType)type filter:(CategoryRankFilterCacheModel *)filter {
    //默认参数
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
        @"q": filter.qs ? filter.qs: @"",
        @"pageIndex": @(currentPage),
        @"pageSize": @(10),
        @"sortType": [NSString stringWithFormat:@"%ld",type],
        @"offerIdList": [NSNull null],
    }];
    //添加外部传入参数
    if (self.initLoad) {
        if (self.model.inner.catgRela.objValue.objId.length > 0) {
            [parm setObject:self.model.inner.catgRela.objValue.objId forKey:@"catgIds"];
        }
        if (self.model.inner.catgRela.objValue.filteredProductsRela.count) {
            [parm addEntriesFromDictionary:self.model.inner.catgRela.objValue.filteredProductsRela];
        }
    }
    //添加筛选参数
    [parm addEntriesFromDictionary:filter.filterParam];
    NSLog(@"");
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        CategoryRankModel *dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        if (self.reloadFilter) {
            self.dataModel = dataModel;
            self.reloadFilter = NO;
        }
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
        }
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.dataArray addObjectsFromArray:dataModel.pageInfo.list];
        [self refreshNoItemsStatus];
        [self.collectionView reloadData];
        if (dataModel.pageInfo.list.count < 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
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
        CategoryRankModel *rankModel  = [CategoryRankModel yy_modelWithDictionary:response];
        [self.dataArray addObjectsFromArray:rankModel.pageInfo.list];
        [self.collectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
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
    
    self.collectionView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.currentPage += 1;
        if (!self.showEmptyView) {
            [self loadDatas:self.currentPage sortType:self.currentType filter:self.filterCacheModel];
        } else {
            [MBProgressHUD hideFromKeyWindow];
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - Event
- (void)jumpToFilterDetail {
    //加载缓存配置到数据层    
    self.dataModel.filterCache = self.filterCacheModel;
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        if (type != CategoryRankFilterRefreshCancel) {
            [self resetIfEmpty];
            [self disableInitParam];
            self.dataModel = model;
            self.filterCacheModel = self.dataModel.filterCache;
            [self.collectionView.mj_header beginRefreshing];
        }
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

/// 点击搜索之前，会重置所有的选中和传入的初始化参数
- (void)resetAllCacheParam {
    self.dataModel.filterCache = nil;
    self.filterCacheModel = nil;
    [self disableInitParam];
}

/// 点击搜索或者进行筛选时前，会重置传入的初始化参数
- (void)disableInitParam {
    self.initLoad = NO;
}

- (void)resetFilter {
    self.reloadFilter = YES;
}

- (void)resetSort {
    self.currentType = CategoryRankTypeSales;
    [self.headSelectorView nonUserBehaviorSelected:CategoryRankTypeSales];
}

/// 筛选后，会重置隐藏空页面
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
    productVC.productId = ((CategoryRankPageInfoListModel *)self.dataArray[indexPath.row]).productId.integerValue;
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
        backItem.itemActionBlock = ^(SFSearchState state,SFSearchModel *model,BOOL isSelected) {
            if (self.shouldBackToHome && state == SFSearchStateInFocuActive) {
                [SceneManager transToHome];
            } else if (state == SFSearchStateInUnActive || state == SFSearchStateInFocuActive) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        SFSearchItem *rightItem = [SFSearchItem new];
        rightItem.icon = @"nav_addition";
        rightItem.selectedIcon = @"nav_addtion_list";
        rightItem.itemActionBlock = ^(SFSearchState state,SFSearchModel * _Nullable model,BOOL isSelected) {
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
            [strongSelf resetIfEmpty];
            [strongSelf resetAllCacheParam];
            [strongSelf resetFilter];
            [strongSelf resetSort];
            strongSelf.filterCacheModel.qs = qs;
            [strongSelf.collectionView.mj_header beginRefreshing];
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
        _headSelectorView = [[CategoryRankHeadSelectorView alloc] initWithFrame:CGRectMake(0, navBarHei + 10, MainScreen_width, KScale(64)) type:CategoryRankTypeSales];
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
        _filterCacheModel.minPrice = -1;//初始化为-1,传参时,传入@""表示没有指定min价格
        _filterCacheModel.maxPrice = -1;//初始化为-1,传参时,传入@""表示没有指定max价格
    }
    return _filterCacheModel;
}

@end
