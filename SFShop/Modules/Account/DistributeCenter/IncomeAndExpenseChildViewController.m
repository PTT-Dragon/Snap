//
//  IncomeAndExpenseChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/12.
//

#import "IncomeAndExpenseChildViewController.h"
#import "IncomeAndExpenseCell.h"
#import <MJRefresh/MJRefresh.h>
#import "DistributorModel.h"
#import "EmptyView.h"

@interface IncomeAndExpenseChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, readwrite, assign) NSInteger currentPage;
@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation IncomeAndExpenseChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xffffff);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"IncomeAndExpenseCell" bundle:nil] forCellReuseIdentifier:@"IncomeAndExpenseCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.bottom.mas_equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadDatas
{
    self.currentPage = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.commissionList parameters:@{@"pageSize":@(10),@"pageIndex":@(self.currentPage),@"commissionOperType":_commissionType} success:^(id  _Nullable response) {
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:[IncomeOrWithdrawListModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView.mj_header endRefreshing];
        NSInteger pageNum = [response[@"pageNum"] integerValue];
        NSInteger pages = [response[@"pages"] integerValue];
        if (pageNum >= pages) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreDatas
{
    self.currentPage ++;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.commissionList parameters:@{@"pageSize":@(10),@"pageIndex":@(self.currentPage),@"commissionOperType":_commissionType} success:^(id  _Nullable response) {
        [weakself.dataSource addObjectsFromArray:[IncomeOrWithdrawListModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        NSInteger pageNum = [response[@"pageNum"] integerValue];
        NSInteger pages = [response[@"pages"] integerValue];
        if (pageNum >= pages) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeAndExpenseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IncomeAndExpenseCell"];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
@end
