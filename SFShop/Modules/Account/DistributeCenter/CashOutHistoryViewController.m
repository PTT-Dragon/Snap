//
//  CashOutHistoryViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/2.
//

#import "CashOutHistoryViewController.h"
#import "CashOutHistoryCell.h"
#import <MJRefresh/MJRefresh.h>
#import "DistributorModel.h"
#import "CashOutDetailVC.h"


@interface CashOutHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, readwrite, assign) NSInteger currentPage;

@end

@implementation CashOutHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"SEARCH_DISCOVERY");
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CashOutHistoryCell" bundle:nil] forCellReuseIdentifier:@"CashOutHistoryCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadDatas];
    }];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self loadDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.cashOutList parameters:@{@"pageSize":@(10),@"pageIndex":@(self.currentPage)} success:^(id  _Nullable response) {
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:[CashOutHistoryListModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
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
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CashOutHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CashOutHistoryCell"];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CashOutDetailVC *vc = [[CashOutDetailVC alloc] init];
    vc.model = self.dataSource[indexPath.row];
    vc.block = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
