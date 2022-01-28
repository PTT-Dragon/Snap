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
#import "EmptyView.h"
#import <OYCountDownManager/OYCountDownManager.h>

@interface OrderChildViewController ()<UITableViewDelegate,UITableViewDataSource,OrderListBottomCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, strong) UIButton *gotoShopping;

@end

@implementation OrderChildViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex = 1;
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListItemCell" bundle:nil] forCellReuseIdentifier:@"OrderListItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListBottomCell" bundle:nil] forCellReuseIdentifier:@"OrderListBottomCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListStateCell" bundle:nil] forCellReuseIdentifier:@"OrderListStateCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.bottom.mas_equalTo(self.view);
    }];
    [kCountDownManager start];
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
    [self.view addSubview:self.gotoShopping];
    [self.gotoShopping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(24);
        make.right.bottom.mas_offset(-24);
        make.height.mas_offset(46);
    }];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *model = self.dataSource[indexPath.section];
    if (indexPath.row == model.orderItems.count+1) {
        return;
    }
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.orderId = model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 10)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)setType:(OrderListType)type
{
    _type = type;
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - cell.delegate
- (void)refreshDatas
{
    if (self.block) {
        self.block();
    }
    [self loadDatas];
}
- (void)loadDatas
{
    NSString *state = _type == OrderListType_All ? @"": _type == OrderListType_ToPay ? @"A": _type == OrderListType_ToShip ? @"B,F,G": _type == OrderListType_ToReceive ? @"C": _type == OrderListType_Cancel ? @"E": _type == OrderListType_Successful ? @"D": @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_searchText forKey:@"q"];
    [params setValue:@(_pageIndex) forKey:@"pageIndex"];
    [params setValue:@(20) forKey:@"pageSize"];
    [params setValue:state forKey:@"states"];
    @weakify(self);
    [SFNetworkManager get:SFNet.order.list parameters:params success:^(id  _Nullable response) {
        @strongify(self);
        if (self->_pageIndex == 1) {
            [self.dataSource removeAllObjects];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *arr = response[@"list"];
        if (!kArrayIsEmpty(arr)) {
            for (NSDictionary *dic in arr) {
                [self.dataSource addObject:[[OrderModel alloc]initWithDictionary:dic error:nil]];
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
    self.gotoShopping.hidden = self.emptyView.hidden;
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - <click event>
- (void)gotoShoppingEvent{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - <lazying>
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
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

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoOrderType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

- (UIButton *)gotoShopping{
    
    if (!_gotoShopping) {
        
        _gotoShopping = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoShopping setTitle:kLocalizedString(@"Go_Shopping") forState:UIControlStateNormal];
        [_gotoShopping setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_gotoShopping setBackgroundColor:[UIColor jk_colorWithHexString:@"FF1659"]];
        [_gotoShopping addTarget:self action:@selector(gotoShoppingEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }return _gotoShopping;
}

@end
