//
//  setViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/25.
//

#import "setViewController.h"
#import "SetTopCell.h"
#import "accountSubCell.h"
#import "SetLogOutCell.h"
#import "SecurityCenterViewController.h"
#import "PolicesViewController.h"
#import "changeUserInfoVC.h"
#import "PublicAlertView.h"
#import "AddressViewController.h"
#import "LanguageViewController.h"

@interface setViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation setViewController
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
    self.title = kLocalizedString(@"Setting");
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    _dataSource = [NSMutableArray array];
    [_dataSource addObjectsFromArray:@[@{@"image":@"",@"title":kLocalizedString(@"My_Address")},@{@"image":@"",@"title":kLocalizedString(@"Security_center")},@{@"image":@"",@"title":kLocalizedString(@"LANGUGE")},@{@"image":@"",@"title":kLocalizedString(@"Policies")}]];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetTopCell" bundle:nil] forCellReuseIdentifier:@"SetTopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetLogOutCell" bundle:nil] forCellReuseIdentifier:@"SetLogOutCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1 ? 4: 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SetTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTopCell"];
        return cell;
    }else if (indexPath.section == 1){
        NSDictionary *dic = _dataSource[indexPath.row];
        accountSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSubCell"];
        cell.label.text = dic[@"title"];
        return cell;
    }else if (indexPath.section == 2){
        accountSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSubCell"];
        cell.label.text = kLocalizedString(@"Share_shop");
        return cell;
    }
    SetLogOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetLogOutCell"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 122;
    }else if (indexPath.row == 1){
        return 56;
    }
    return 56;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 15)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        SecurityCenterViewController *vc = [[SecurityCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        LanguageViewController *vc = [[LanguageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3){
        MPWeakSelf(self)
        PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:@"confirm to logout" btnTitle:@"LOGOUT" block:^{
            [SFNetworkManager post:SFNet.account.logout success:^(id  _Nullable response) {
                [MBProgressHUD autoDismissShowHudMsg:@"LogOut Success"];
                [[FMDBManager sharedInstance] deleteUserData];
                [baseTool removeVCFromNavigation:weakself];                
            } failed:^(NSError * _Nonnull error) {
                
            }];
        } btn2Title:@"CANCEL" block2:^{
            
        }];
        [self.view addSubview:alert];
    }else if (indexPath.section == 1 && indexPath.row == 3){
        PolicesViewController *vc = [[PolicesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0){
        changeUserInfoVC *vc = [[changeUserInfoVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        AddressViewController *vc = [[AddressViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
