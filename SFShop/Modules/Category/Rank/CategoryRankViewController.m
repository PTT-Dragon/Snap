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
#import "NSString+Add.h"
#import <MJRefresh/MJRefresh.h>
#import "CategoryRankHeadSelectorView.h"
#import "CategoryRankFilterViewController.h"
#import "CategoryRankFilterCacheModel.h"
#import "SFSearchNav.h"

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

@end

@implementation CategoryRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadsubviews];
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadDatas:(NSInteger)currentPage sortType:(CategoryRankType)type filter:(CategoryRankFilterCacheModel *)filter {
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
        @"q": @"",
        @"pageIndex": @(currentPage),
        @"pageSize": @(10),
        @"sortType": [NSString stringWithFormat:@"%ld",type],
        @"offerIdList": [NSNull null],
        @"catgIds": @(self.model.inner.catgId)//默认是外部传入的分类,如果 filter.filterParam 有该字段,会被新值覆盖
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
        [self.collectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:error.localizedDescription];
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadsubviews {
    [self.view addSubview:self.navSearchView];
    [self.view addSubview:self.headSelectorView];
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadDatas:self.currentPage sortType:self.currentType filter:self.filterCacheModel];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage += 1;
        [self loadDatas:self.currentPage sortType:self.currentType filter:self.filterCacheModel];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)layout {
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
        [self.collectionView.mj_header beginRefreshing];
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count > 0?1:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankCell" forIndexPath:indexPath];
    CategoryRankPageInfoListModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    return cell;
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankPageInfoListModel *cellModel = self.dataArray[indexPath.row];
    if (!cellModel.height) {
        CGFloat titleHeight = [cellModel.offerName calHeightWithFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width - KScale(12) * 3 - KScale(16) * 2, 100)];
        CGFloat imageHeigjt = KScale(166);
        CGFloat tagHeight = KScale(14);
        CGFloat priceHeight = KScale(14);
        CGFloat discountHeight = KScale(14);
        CGFloat levelHeight = KScale(12);
        cellModel.height = imageHeigjt + KScale(16) + tagHeight + KScale(12) + titleHeight + KScale(16) + priceHeight + KScale(4) + discountHeight + KScale(12) + levelHeight + KScale(25);
    }
    return cellModel.height;
}

#pragma mark - getter
- (SFSearchNav *)navSearchView {
    if (_navSearchView == nil) {
        SFSearchItem *backItem = [SFSearchItem new];
        backItem.icon = @"nav_back";
        
        SFSearchItem *rightItem = [SFSearchItem new];
        rightItem.icon = @"nav_addition";
        _navSearchView = [[SFSearchNav alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, navBarHei) backItme:backItem rightItem:rightItem];
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, navBarHei + KScale(64), MainScreen_width, MainScreen_height - navBarHei - KScale(64)) collectionViewLayout:_waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor clearColor];

        [_collectionView registerClass:CategoryRankCell.class forCellWithReuseIdentifier:@"CategoryRankCell"];
    }
    return _collectionView;
}

- (CategoryRankHeadSelectorView *)headSelectorView {
    if (_headSelectorView == nil) {
        _headSelectorView = [[CategoryRankHeadSelectorView alloc] initWithFrame:CGRectMake(0, navBarHei, MainScreen_width, KScale(64)) type:CategoryRankTypePopularity];
        __weak __typeof(self)weakSelf = self;
        _headSelectorView.clickFilterBlock = ^(CategoryRankType type) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            switch (type) {
                case CategoryRankTypePopularity:
                case CategoryRankTypeSales:
                case CategoryRankTypePriceDescending:
                case CategoryRankTypePriceAscending: {
                    [MBProgressHUD showHudMsg:@"加载中"];
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
