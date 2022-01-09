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
#import "AccountActiveCell.h"
#import "InviteViewController.h"
#import "SupportViewController.h"
#import "OrderModel.h"
#import "LoginViewController.h"
#import "LanguageViewController.h"

@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) double couponCount;
@property (nonatomic,assign) double favoriteCount;
@property (nonatomic,assign) double recentCount;
@property (nonatomic,assign) double showInviteImg;
@property (nonatomic,copy) NSString *inviteImgUrl;
@property (nonatomic,strong) OrderNumModel *orderNumModel;
@end

@implementation AccountViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Account");
    _couponCount = 0;
    _favoriteCount = 0;
    _recentCount = 0;
    _dataSource = [NSMutableArray array];
    [_dataSource addObjectsFromArray:
         @[@{@"image":@"add-account",@"title":@"Refers"},
           @{@"image":@"group",@"title":@"Forum"},
           @{@"image":@"most-used",@"title":@"Reviews"},
           @{@"image":@"pin",@"title":@"Address"},
           @{@"image":@"call-centre",@"title":@"Service"},
           @{@"image":@"read",@"title":@"Policies"},
           @{@"image":@"question",@"title":@"FAQ"},
           @{@"image":@"read",@"title":@"Language"}]
    ];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountInfoCell" bundle:nil] forCellReuseIdentifier:@"accountInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountOrderCell" bundle:nil] forCellReuseIdentifier:@"accountOrderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountActiveCell" bundle:nil] forCellReuseIdentifier:@"AccountActiveCell"];
    
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
            self.orderNumModel = nil;
            [self.tableView reloadData];
            LoginViewController *vc = [[LoginViewController alloc] init];
            MPWeakSelf(vc)
            vc.didLoginBlock = ^{
                [weakvc.navigationController popToRootViewControllerAnimated:YES];
//                self.tabBarController.selectedIndex = 0;
            };
            [self.navigationController pushViewController:vc animated:YES];
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
    [SFNetworkManager get:SFNet.order.num parameters:@{} success:^(id  _Nullable response) {
        weakself.orderNumModel = [OrderNumModel yy_modelWithDictionary:response];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [SFNetworkManager get:SFNet.invite.activity parameters:@{} success:^(id  _Nullable response) {
        if ([response[@"success"] isEqualToNumber:@(1)]) {
            weakself.showInviteImg = YES;
        }else{
            weakself.showInviteImg = NO;
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [SFNetworkManager get:SFNet.invite.img parameters:@{} success:^(id  _Nullable response) {
        weakself.inviteImgUrl = response[@"data"];
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
    return 3+_dataSource.count;
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
        cell.numModel = self.orderNumModel;
        return cell;
    }else if (indexPath.row == 2){
        AccountActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountActiveCell"];
        if (self.showInviteImg) {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(self.inviteImgUrl)]];
        }else{
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:@""]];
        }
        return cell;
    }
    NSDictionary *dic = _dataSource[indexPath.row-3];
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
    }else if (indexPath.row == 2){
        return self.showInviteImg ? 140: 0.01;
    }
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        InviteViewController *vc = [[InviteViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row > 2) {
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
            SupportViewController *vc = [[SupportViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:@"Forum"]){
            self.tabBarController.selectedIndex = 2;
        }else if ([cell.label.text isEqualToString:@"Policies"]){
            PolicesViewController *vc = [[PolicesViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:@"FAQ"]){
            FAQViewController *vc = [[FAQViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:@"Language"]) {
            LanguageViewController *vc = [[LanguageViewController alloc] init];
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
