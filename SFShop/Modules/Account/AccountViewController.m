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
@property (nonatomic,assign) double unreadMessageCount;
@property (nonatomic,assign) double favoriteCount;
@property (nonatomic,assign) double recentCount;
@property (nonatomic,assign) double showInviteImg;
@property (nonatomic,copy) NSString *inviteImgUrl;
@property (nonatomic,strong) OrderNumModel *orderNumModel;
@end

@implementation AccountViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self loadData];
    [self loadUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Account");
    NSLog(@"======aaaaaaaaaaa");
    _unreadMessageCount = 0;
    _favoriteCount = 0;
    _recentCount = 0;
    _dataSource = [NSMutableArray array];
    [_dataSource addObjectsFromArray:
         @[@{@"image":@"add-account",@"title":kLocalizedString(@"REFERS")},
           @{@"image":@"group",@"title":kLocalizedString(@"Community")},
           @{@"image":@"most-used",@"title":kLocalizedString(@"RATING")},
           @{@"image":@"pin",@"title":kLocalizedString(@"ADDRESS")},
           @{@"image":@"call-centre",@"title":kLocalizedString(@"SERVICE")},
           @{@"image":@"read",@"title":kLocalizedString(@"Policies")},
           @{@"image":@"question",@"title":kLocalizedString(@"FAQ")}]
    ];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountInfoCell" bundle:nil] forCellReuseIdentifier:@"accountInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountOrderCell" bundle:nil] forCellReuseIdentifier:@"accountOrderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountActiveCell" bundle:nil] forCellReuseIdentifier:@"AccountActiveCell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(0);
    }];
    [baseTool updateCartNum];
    [self updateDatas];
}
- (void)updateDatas
{
    FMDBManager *dbManager = [FMDBManager sharedInstance];
    
    @weakify(self)
    [RACObserve(dbManager, currentUser) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        if (!model || [model.accessToken isEqualToString:@""]) {
            //登出状态
            self.orderNumModel = nil;
            [self.tableView reloadData];
            if ([[baseTool getCurrentVC] isKindOfClass:[LoginViewController class]] || ![[baseTool getCurrentVC] isKindOfClass:[AccountViewController class]]) {
                return;
            }
            LoginViewController *vc = [[LoginViewController alloc] init];
            MPWeakSelf(vc)
            MPWeakSelf(self)
            vc.didLoginBlock = ^{
                [weakvc.navigationController popToRootViewControllerAnimated:YES];
                [weakself performSelector:@selector(setTabbarSel) withObject:nil afterDelay:0.5];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if (model.userRes.distributorDto) {
                __block BOOL hasAdd = NO;
                [self.dataSource enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj[@"image"] isEqualToString:@"00350_Distributor_Center"]) {
                        hasAdd = YES;
                    };
                }];
                if (!hasAdd) {
                    [self.dataSource insertObject:@{@"image":@"00350_Distributor_Center",@"title":kLocalizedString(@"Distributor_center")} atIndex:0];
                    [self.tableView reloadData];
                }                
            }
            [self loadData];
        }
    }];
}
- (void)setTabbarSel
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
}
- (void)loadData
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.account.messageNum parameters:@{} success:^(id  _Nullable response) {
        NSNumber *num = response;
        weakself.unreadMessageCount = num.doubleValue;
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
        cell.favoriteCount = self.favoriteCount;
        cell.recentCount = self.recentCount;
        cell.noReadMessageCount = self.unreadMessageCount;
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
        return 175+statuBarHei;
    }else if (indexPath.row == 1){
        return 134;
    }else if (indexPath.row == 2){
        return (self.showInviteImg && ![self.inviteImgUrl isKindOfClass:[NSNull class]]) ? 140: 0.01;
    }
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        if (!model) {
            MPWeakSelf(self)
            LoginViewController *vc = [[LoginViewController alloc] init];
            vc.didLoginBlock = ^{
                [[baseTool getCurrentVC].navigationController popViewControllerAnimated: YES];
                [weakself performSelector:@selector(setTabbarSel) withObject:nil afterDelay:0.5];
            };
            [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
            return;
        }
        InviteViewController *vc = [[InviteViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row > 2) {
        accountSubCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.label.text isEqualToString:kLocalizedString(@"Distributor_center")]) {
            DistributeCenterViewController *vc = [[DistributeCenterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:kLocalizedString(@"REFERS")]){
            UserModel *model = [FMDBManager sharedInstance].currentUser;
            if (!model) {
                MPWeakSelf(self)
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.didLoginBlock = ^{
                    [[baseTool getCurrentVC].navigationController popViewControllerAnimated: YES];
                    [weakself performSelector:@selector(setTabbarSel) withObject:nil afterDelay:0.5];
                };
                [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
                return;
            }
            InviteViewController *vc = [[InviteViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:kLocalizedString(@"RATING")]){
            UserModel *model = [FMDBManager sharedInstance].currentUser;
            if (!model) {
                MPWeakSelf(self)
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.didLoginBlock = ^{
                    [[baseTool getCurrentVC].navigationController popViewControllerAnimated: YES];
                    [weakself performSelector:@selector(setTabbarSel) withObject:nil afterDelay:0.5];
                };
                [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
                return;
            }
            ReviewViewController *vc = [[ReviewViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:kLocalizedString(@"ADDRESS")]){
            AddressViewController *vc = [[AddressViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];            
        }else if ([cell.label.text isEqualToString:kLocalizedString(@"SERVICE")]){
            SupportViewController *vc = [[SupportViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:kLocalizedString(@"Community")]){
            self.tabBarController.selectedIndex = 2;
        }else if ([cell.label.text isEqualToString:kLocalizedString(@"Policies")]){
            PolicesViewController *vc = [[PolicesViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:kLocalizedString(@"FAQ")]){
            FAQViewController *vc = [[FAQViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([cell.label.text isEqualToString:kLocalizedString(@"LANGUGE")]) {
            LanguageViewController *vc = [[LanguageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
