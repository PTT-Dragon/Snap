//
//  AccountViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "AccountViewController.h"
#import "accountInfoCell.h"
#import "accountOrderCell.h"
#import "accountSubCell.h"
#import "AddressViewController.h"
#import "FavoriteViewController.h"
#import "PolicesViewController.h"
#import "ReviewViewController.h"
#import "InviteViewController.h"
#import "FAQViewController.h"
#import "DistributeCenterViewController.h"


@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) double couponCount;
@property (nonatomic,assign) double favoriteCount;
@property (nonatomic,assign) double recentCount;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.hidden = YES;
    self.title = @"Account";
    _couponCount = 0;
    _favoriteCount = 0;
    _recentCount = 0;
    _dataSource = [NSMutableArray array];
    [_dataSource addObjectsFromArray:@[@{@"image":@"00350_Distributor_Center",@"title":@"Refers"},@{@"image":@"00350_Distributor_Center",@"title":@"Forum"},@{@"image":@"00350_Distributor_Center",@"title":@"Reviews"},@{@"image":@"00350_Distributor_Center",@"title":@"Address"},@{@"image":@"00350_Distributor_Center",@"title":@"Service"},@{@"image":@"00350_Distributor_Center",@"title":@"Policies"},@{@"image":@"00350_Distributor_Center",@"title":@"FAQ"}]];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountInfoCell" bundle:nil] forCellReuseIdentifier:@"accountInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountOrderCell" bundle:nil] forCellReuseIdentifier:@"accountOrderCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
    [self updateDatas];
}
- (void)updateDatas
{
    [self loadUserInfo];
    FMDBManager *dbManager = [FMDBManager sharedInstance];
    
    @weakify(self)
    [RACObserve(dbManager, currentUser) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        if (!model || [model.accessToken isEqualToString:@""]) {
            //登出状态
            [self.tableView reloadData];
        }else{
            if (model.userRes.distributorDto) {
                [self.dataSource insertObject:@{@"image":@"00350_Distributor_Center",@"title":@"Distributor  Center"} atIndex:0];
                [self.tableView reloadData];
            }
            [self loadData];
        }
    }];
}
- (void)loadData
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.coupon.num parameters:@{} success:^(id  _Nullable response) {
        NSNumber *num = response;
        weakself.couponCount = num.doubleValue;
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [SFNetworkManager get:SFNet.favorite.num parameters:@{} success:^(id  _Nullable response) {
        NSNumber *num = response[@"totalNum"];
        weakself.favoriteCount = num.doubleValue;
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [SFNetworkManager get:SFNet.recent.num parameters:@{} success:^(id  _Nullable response) {
        NSNumber *num = response[@"totalOfferViewNum"];
        weakself.recentCount = num.doubleValue;
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    
}
- (void)loadUserInfo
{
    [SFNetworkManager get:SFNet.account.userInfo success:^(id  _Nullable response) {
        userResModel *resModel = [[userResModel alloc] initWithDictionary:response error:nil];
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        [model setUserRes:resModel];
        [[FMDBManager sharedInstance] updateUser:model ofAccount:model.account];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2+_dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        accountInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountInfoCell"];
        cell.couponCount = self.couponCount;
        cell.favoriteCount = self.favoriteCount;
        cell.recentCount = self.recentCount;
        [cell updateData];
        return cell;
    }else if (indexPath.row == 1){
        accountOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountOrderCell"];
        return cell;
    }
    NSDictionary *dic = _dataSource[indexPath.row-2];
    accountSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSubCell"];
    cell.label.text = dic[@"title"];
    cell.imgView.image = [UIImage imageNamed:dic[@"image"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 175;
    }else if (indexPath.row == 1){
        return 134;
    }
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 1) {
        accountSubCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.label.text isEqualToString:@"Distributor  Center"]) {
            DistributeCenterViewController *vc = [[DistributeCenterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:@"Refers"]){
            InviteViewController *vc = [[InviteViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:@"Reviews"]){
            ReviewViewController *vc = [[ReviewViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:@"Address"]){
            AddressViewController *vc = [[AddressViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:@"Service"]){
            
        }else if ([cell.label.text isEqualToString:@"Forum"]){
            self.tabBarController.selectedIndex = 2;
        }else if ([cell.label.text isEqualToString:@"Policies"]){
            PolicesViewController *vc = [[PolicesViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:@"FAQ"]){
            FAQViewController *vc = [[FAQViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
