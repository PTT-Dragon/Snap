//
//  CouponCenterChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/27.
//

#import "CouponCenterChildViewController.h"
#import "CouponCenterCell.h"
#import "CouponModel.h"
#import <MJRefresh/MJRefresh.h>

@interface CouponCenterChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;

@end

@implementation CouponCenterChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.tableView registerNib:[UINib nibWithNibName:@"CouponCenterCell" bundle:nil] forCellReuseIdentifier:@"CouponCenterCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(10);
    }];
    [self loadDatas];
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [self loadMoreDatas];
    }];
}
- (void)loadDatas
{
    self.page = 1;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.coupon.center parameters:@{@"pageSize":@(5),@"pageIndex":@"1",@"couponCateId":_couponCatgId} success:^(id  _Nullable response) {
        [weakself.dataSource removeAllObjects];
        NSArray *arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            [weakself.dataSource addObject:[[CouponModel alloc] initWithDictionary:dic error:nil]];
        }
        [weakself.tableView reloadData];
        NSInteger pageNum = [response[@"pageNum"] integerValue];
        NSInteger pages = [response[@"pages"] integerValue];
        if (pageNum >= pages) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)loadMoreDatas
{
    self.page ++;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.coupon.center parameters:@{@"pageSize":@(5),@"pageIndex":@(self.page),@"couponCateId":_couponCatgId} success:^(id  _Nullable response) {
        NSArray *arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            [weakself.dataSource addObject:[[CouponModel alloc] initWithDictionary:dic error:nil]];
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponCenterCell"];
    cell.block = ^{
        [self loadDatas];
    };
    [cell setContent:self.dataSource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195;
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
@end
