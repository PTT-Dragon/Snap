//
//  RefundViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "RefundViewController.h"
#import "RefundCell.h"
#import "refundModel.h"
#import "RefundDetailViewController.h"
#import <MJRefresh/MJRefresh.h>


@interface RefundViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UISearchBar *searchBar;

@end

@implementation RefundViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Refund_Return");
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RefundCell" bundle:nil] forCellReuseIdentifier:@"RefundCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+70);
    }];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundCell"];
    [cell setContent:self.dataSource[indexPath.row]];
    cell.block = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    refundModel *model = self.dataSource[indexPath.row];
    CGFloat hei = [model.state isEqualToString:@"F"] ? 246: [model.state isEqualToString:@"D"] ? 246: [model.state isEqualToString:@"E"] ? 246: [model.state isEqualToString:@"G"] ? 246: [model.state isEqualToString:@"X"] ? 246: [model.state isEqualToString:@"A"] ? 286: 286;
    return  hei;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    refundModel *model = self.dataSource[indexPath.row];
    RefundDetailViewController *vc = [[RefundDetailViewController alloc] init];
    vc.orderApplyId = model.orderApplyId;
    vc.block = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loadDatas
{
    [MBProgressHUD showHudMsg:@""];
    _pageIndex = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.refund.refundList parameters:@{@"q":_searchBar.text,@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        [weakself.tableView.mj_header endRefreshing];
        [weakself.dataSource removeAllObjects];
        [weakself.dataSource addObjectsFromArray:[refundModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreDatas
{
    [MBProgressHUD showHudMsg:@""];
    _pageIndex ++;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.refund.refundList parameters:@{@"q":_searchBar.text,@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.dataSource addObjectsFromArray:[refundModel arrayOfModelsFromDictionaries:response[@"list"] error:nil]];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - search.delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.tableView.mj_header beginRefreshing];
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
- (UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHei, MainScreen_width, 70)];
        _searchView.backgroundColor = [UIColor whiteColor];
        [_searchView addSubview:self.searchBar];
    }
    return _searchView;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(16, 13, MainScreen_width-32, 46)];
        _searchBar.placeholder = kLocalizedString(@"Search");
        _searchBar.delegate = self;
    }
    return _searchBar;
}
@end
