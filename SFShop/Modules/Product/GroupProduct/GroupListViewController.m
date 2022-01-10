//
//  GroupListViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/16.
//

#import "GroupListViewController.h"
#import "CategoryRankModel.h"
#import "GroupFilterCell.h"
#import "GroupBuyListCell.h"
#import "ProductViewController.h"
#import "GroupTopImgCell.h"
#import <MJRefresh/MJRefresh.h>
#import "CategoryRankFilterViewController.h"


@interface GroupListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;
@property (nonatomic, readwrite, assign) CategoryRankType currentType;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@end

@implementation GroupListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Group_buy");
    [self initUI];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self loadDatas:self.pageIndex sortType:self.currentType filter:self.filterCacheModel];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self loadDatas:self.pageIndex sortType:self.currentType filter:self.filterCacheModel];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}
- (void)initUI
{
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupBuyListCell" bundle:nil] forCellReuseIdentifier:@"GroupBuyListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupTopImgCell" bundle:nil] forCellReuseIdentifier:@"GroupTopImgCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 280: indexPath.row == 1 ? KScale(64): 136;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        GroupTopImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTopImgCell"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:@"https://www.smartfrenshop.com/static/GroupBy.95d35058.png"]];
        return cell;
    }else if (indexPath.row == 1){
        GroupFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupFilterCell"];
        if (!cell) {
            cell = [[GroupFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupFilterCell" type:self.currentType];
            __weak __typeof(self)weakSelf = self;
            cell.clickFilterBlock = ^(CategoryRankType type) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                switch (type) {
                    case CategoryRankTypePopularity:
                    case CategoryRankTypeSales:
                    case CategoryRankTypePriceDescending:
                    case CategoryRankTypePriceAscending: {
                        [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
                        strongSelf.currentType = type;
                        [strongSelf.tableView.mj_header beginRefreshing];
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
        return cell;
    }
    GroupBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupBuyListCell"];
    cell.model = self.dataArray[indexPath.row-2];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryRankPageInfoListModel *model = self.dataArray[indexPath.row-2];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = model.offerId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadDatas:(NSInteger)currentPage sortType:(CategoryRankType)type filter:(CategoryRankFilterCacheModel *)filter
{
    MPWeakSelf(self)
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
        @"q": @"",
        @"pageIndex": @(currentPage),
        @"pageSize": @(10),
        @"sortType": [NSString stringWithFormat:@"%ld",type],
        @"offerIdList": [NSNull null],
        @"campaignType":@"4"//参照h5 有可能是动态
//        @"catgIds": @(self.model.inner.catgId)//默认是外部传入的分类,如果 filter.filterParam 有该字段,会被新值覆盖
    }];
    [parm addEntriesFromDictionary:filter.filterParam];
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        weakself.dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.dataArray addObjectsFromArray:self.dataModel.pageInfo.list];
//        [self refreshNoItemsStatus];
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
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
        [self.tableView.mj_header beginRefreshing];
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}



- (CategoryRankFilterCacheModel *)filterCacheModel {
    if (_filterCacheModel == nil) {
        _filterCacheModel = [[CategoryRankFilterCacheModel alloc] init];
        self.filterCacheModel.minPrice = -1;//初始化为-1,传参时,传入@""表示没有指定min价格
        self.filterCacheModel.maxPrice = -1;//初始化为-1,传参时,传入@""表示没有指定max价格
    }
    return _filterCacheModel;
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}

@end
