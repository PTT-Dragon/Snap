//
//  DistributeProductListChildVC.m
//  SFShop
//
//  Created by 游挺 on 2022/3/9.
//

#import "DistributeProductListChildVC.h"
#import <MJRefresh/MJRefresh.h>
#import "EmptyView.h"
#import "DistributorModel.h"
#import "DistributorRankCell.h"
#import "ProductViewController.h"


@interface DistributeProductListChildVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation DistributeProductListChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColorFrom16(0xffffff);
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributorRankCell" bundle:nil] forCellReuseIdentifier:@"DistributorRankCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.bottom.mas_equalTo(self.view);
    }];
    self.pageIndex = 1;
    _dataSource = [NSMutableArray array];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self loadDatas];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.pageIndex += 1;
        [self loadDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(90);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DistributorRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributorRankCell"];
    cell.model = self.dataSource[indexPath.section];
    cell.rank = 10000;
    cell.centerModel = self.centerModel;
    cell.contentView.layer.borderColor = RGBColorFrom16(0xdddddd).CGColor;
    cell.contentView.layer.borderWidth = 1;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DistributorRankProductModel *model = self.dataSource[indexPath.section];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = model.offerId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 10)];
    view.backgroundColor = RGBColorFrom16(0xffffff);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 0.01)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_searchText forKey:@"q"];
    [params setValue:@(self.pageIndex) forKey:@"pageIndex"];
    [params setValue:@(20) forKey:@"pageSize"];
    [params setValue:@"1" forKey:@"sortType"];
    if ([_isHistory isEqualToString:@"Y"]) {
        [params setValue:@"Y" forKey:@"isHistory"];
    }
    @weakify(self);
    [SFNetworkManager get:SFNet.distributor.offers parameters:params success:^(id  _Nullable response) {
        @strongify(self);
        if (self->_pageIndex == 1) {
            [self.dataSource removeAllObjects];
        }//pageNum pages
        [self.tableView.mj_header endRefreshing];
        NSInteger pageNum = [response[@"pageNum"] integerValue];
        NSInteger pages = [response[@"pages"] integerValue];
        if (pageNum >= pages) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        NSArray *arr = response[@"list"];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [self.dataSource addObject:[[DistributorRankProductModel alloc]initWithDictionary:dic error:nil]];
            }
        }
        [self.tableView reloadData];
        [self showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        @strongify(self);
        [self showEmptyView];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)showEmptyView {
    if (self.dataSource.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
}


#pragma mark - <lazying>
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = RGBColorFrom16(0xffffff);
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

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoCouponType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
