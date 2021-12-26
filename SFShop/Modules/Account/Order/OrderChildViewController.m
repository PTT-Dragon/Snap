//
//  OrderChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import "OrderChildViewController.h"
#import "OrderListItemCell.h"
#import "OrderListBottomCell.h"
#import "OrderListStateCell.h"
#import "OrderModel.h"
#import "OrderDetailViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface OrderChildViewController ()<UITableViewDelegate,UITableViewDataSource,OrderListBottomCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;

@end

@implementation OrderChildViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListBottomCell" bundle:nil] forCellReuseIdentifier:@"OrderListBottomCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = self.dataSource[indexPath.section];
    if (indexPath.row == 0) {
        OrderListStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListStateCell"];
        [cell setContent:model];
        return cell;
    }else if (indexPath.row == model.orderItems.count+1){
        OrderListBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListBottomCell"];
        [cell setContent:model];
        cell.delegate = self;
        return cell;
    }
    OrderListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListItemCell"];
    [cell setContent:model.orderItems[indexPath.row-1]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL showBottomView;
    OrderModel *model = self.dataSource[section];
    showBottomView = [model.state isEqualToString:@"E"] ? NO:YES;
    return model.orderItems.count+(showBottomView ? 2: 1);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = self.dataSource[indexPath.section];
    return indexPath.row == 0 ? 40: indexPath.row == model.orderItems.count+1 ? 100: 118;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = self.dataSource[indexPath.section];
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.orderId = model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 10)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}

- (void)setType:(OrderListType)type
{
    _type = type;
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - cell.delegate
- (void)refreshDatas
{
    [self loadDatas];
}
- (void)loadDatas
{
    _pageIndex = 1;
    NSString *state = _type == OrderListType_All ? @"": _type == OrderListType_ToPay ? @"A": _type == OrderListType_ToShip ? @"B,F,G": _type == OrderListType_ToReceive ? @"C": _type == OrderListType_Cancel ? @"E": _type == OrderListType_Successful ? @"D": @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_searchText forKey:@"q"];
    [params setValue:@(_pageIndex) forKey:@"pageIndex"];
    [params setValue:@(20) forKey:@"pageSize"];
    [params setValue:state forKey:@"states"];
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.order.list parameters:params success:^(id  _Nullable response) {
        [weakself.dataSource removeAllObjects];
        [weakself.tableView.mj_header endRefreshing];
        NSArray *arr = response[@"list"];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [weakself.dataSource addObject:[[OrderModel alloc]initWithDictionary:dic error:nil]];
            }
         
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreDatas
{
    _pageIndex ++;
    NSString *state = _type == OrderListType_All ? @"": _type == OrderListType_ToPay ? @"A": _type == OrderListType_ToShip ? @"B,F,G": _type == OrderListType_ToReceive ? @"C": _type == OrderListType_Cancel ? @"E": _type == OrderListType_Successful ? @"D": @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_searchText forKey:@"q"];
    [params setValue:@(_pageIndex) forKey:@"pageIndex"];
    [params setValue:@(20) forKey:@"pageSize"];
    [params setValue:state forKey:@"states"];
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.order.list parameters:params success:^(id  _Nullable response) {
        [weakself.tableView.mj_footer endRefreshing];
        NSArray *arr = response[@"list"];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [weakself.dataSource addObject:[[OrderModel alloc]initWithDictionary:dic error:nil]];
            }            
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    [self.tableView.mj_header beginRefreshing];
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
