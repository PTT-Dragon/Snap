//
//  RelationOrderChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/12.
//

#import "RelationOrderChildViewController.h"
#import "RelationOrderCell.h"
#import <MJRefresh/MJRefresh.h>
#import "DistributorModel.h"
//#import "RelationOrderDetailViewController.h"

@interface RelationOrderChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation RelationOrderChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RelationOrderCell" bundle:nil] forCellReuseIdentifier:@"RelationOrderCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.bottom.mas_equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadDatas
{
    _pageIndex = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.orders parameters:@{@"settState":_type,@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:[RelationOrderListModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreDatas
{
    _pageIndex ++;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.distributor.orders parameters:@{@"settState":_type,@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [weakself.dataSource addObjectsFromArray:[RelationOrderListModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelationOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationOrderCell"];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;//self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelationOrderListModel *model = self.dataSource[indexPath.row];
//    RelationOrderDetailViewController *vc = [[RelationOrderDetailViewController alloc] init];
//    vc.orderId = model.orderId;
//    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = RGBColorFrom16(0xf5f5f5);
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
