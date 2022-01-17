//
//  ReviewChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/21.
//

#import "ReviewChildViewController.h"
#import "OrderModel.h"
#import "ReviewCell.h"
#import "ReviewDetailViewController.h"
#import "ProductViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "EmptyView.h"

@interface ReviewChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) EmptyView *emptyView;

@end

@implementation ReviewChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewCell" bundle:nil] forCellReuseIdentifier:@"ReviewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(90);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
- (void)loadDatas
{
    _pageIndex = 1;
    NSString *evaluateFlag = _type == 1 ? @"N": @"Y";
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.order.list parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(10),@"evaluateFlag":evaluateFlag} success:^(id  _Nullable response) {
        [weakself.tableView.mj_header endRefreshing];
        NSArray *arr = response[@"list"];
        if (kArrayIsEmpty(arr)) {
            return;
        }
        for (NSDictionary *dic in arr) {
            [weakself.dataSource addObject:[[OrderModel alloc] initWithDictionary:dic error:nil]];
        }
        [weakself showEmptyView];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself showEmptyView];
        [weakself.tableView.mj_header endRefreshing];
    }];
}

- (void)showEmptyView {
    if (self.dataSource.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
}

- (void)loadMoreDatas
{
    _pageIndex ++;
    NSString *evaluateFlag = _type == 1 ? @"N": @"Y";
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.order.list parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(10),@"evaluateFlag":evaluateFlag} success:^(id  _Nullable response) {
        [weakself.tableView.mj_footer endRefreshing];
        NSArray *arr = response[@"list"];
        if (kArrayIsEmpty(arr)) {
            return;
        }
        for (NSDictionary *dic in arr) {
            [weakself.dataSource addObject:[[OrderModel alloc] initWithDictionary:dic error:nil]];
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
    [cell setContent:self.dataSource[indexPath.row] type:_type];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *subModel = self.dataSource[indexPath.row];
    return _type == 1 ? 168: [subModel.canReview isEqualToString:@"Y"] ? 299 : 257;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *model = self.dataSource[indexPath.row];
    if (_type == 2) {
        ReviewDetailViewController *vc = [[ReviewDetailViewController alloc] init];
        vc.orderItemId = model.orderId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    ProductViewController *vc = [[ProductViewController alloc] init];
    orderItemsModel *itemModel = model.orderItems.firstObject;
    vc.offerId = itemModel.offerId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
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

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoPurchaseType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
