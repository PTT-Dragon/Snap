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
#import "UIButton+EnlargeTouchArea.h"



@interface GroupListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;
@property (nonatomic, readwrite, assign) CategoryRankType currentType;
@property (nonatomic,strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@end

@implementation GroupListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Group_buy");
    [self initUI];
    self.currentType = 2;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self loadDatas:self.pageIndex sortType:self.currentType filter:self.filterCacheModel];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.pageIndex ++;
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
        make.top.mas_equalTo(self.view.mas_top).offset(0);
    }];
    self.backBtn.layer.zPosition = 1;
    self.shareBtn.layer.zPosition = 1;
    self.titleLabel.layer.zPosition = 1;
    self.titleImgView.layer.zPosition = 1;
    [self.backBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.shareBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.shareBtn];
    self.titleLabel.text = @"Group buy";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count+2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 280: indexPath.row == 1 ? KScale(64): 136;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        GroupTopImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupTopImgCell"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/static/GroupBy.95d35058.png",Host]]];
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
    if (indexPath.row > 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CategoryRankPageInfoListModel *model = self.dataArray[indexPath.row-2];
        ProductViewController *vc = [[ProductViewController alloc] init];
        vc.offerId = model.offerId;
        vc.productId = model.productId.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
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
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        if (type != CategoryRankFilterRefreshCancel) {
            self.dataModel = model;
            self.filterCacheModel = model.filterCache;
            [self.tableView.mj_header beginRefreshing];
        }
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}
- (IBAction)backAction:(UIButton *)sender {
    [[baseTool getCurrentVC].navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareAction:(UIButton *)sender {
    NSString *shareUrl = [NSString stringWithFormat:@"%@/product/GroupBuy",Host];
    [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
}



- (CategoryRankFilterCacheModel *)filterCacheModel {
    if (_filterCacheModel == nil) {
        _filterCacheModel = [[CategoryRankFilterCacheModel alloc] init];
        _filterCacheModel.minPrice = -1;//初始化为-1,传参时,传入@""表示没有指定min价格
        _filterCacheModel.maxPrice = -1;//初始化为-1,传参时,传入@""表示没有指定max价格
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
        _tableView.showsVerticalScrollIndicator = NO;
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
