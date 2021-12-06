//
//  AddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"
#import "addressModel.h"
#import <MJRefresh/MJRefresh.h>

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,AddAddressViewControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"My Address";
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
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
    [SFNetworkManager get:SFNet.address.addressList parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.dataSource removeAllObjects];
        for (NSDictionary *dic in response) {
            addressModel *model = [[addressModel alloc] initWithDictionary:dic error:nil];
            [weakself.dataSource addObject:model];
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreDatas
{
    _pageIndex ++;
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.address.addressList parameters:@{@"pageIndex":@(_pageIndex),@"pageSize":@(10)} success:^(id  _Nullable response) {
        [weakself.tableView.mj_footer endRefreshing];
        for (NSDictionary *dic in response) {
            addressModel *model = [[addressModel alloc] initWithDictionary:dic error:nil];
            [weakself.dataSource addObject:model];
        }
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
    [cell setContent:self.dataSource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 132;
}
- (IBAction)addAction:(UIButton *)sender {
    AddAddressViewController *vc = [[AddAddressViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)addNewAddressSuccess
{
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
