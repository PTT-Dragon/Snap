//
//  SecurityCenterViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "SecurityCenterViewController.h"
#import "accountSubCell.h"
#import "ChangePasswordViewController.h"
#import "ChangeMobileOrEmailViewController.h"
#import "forgotPasswordView.h"

@interface SecurityCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation SecurityCenterViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadUserInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Security_center");
    _dataSource = [NSMutableArray array];
    [self updateDatas];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"accountSubCell" bundle:nil] forCellReuseIdentifier:@"accountSubCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei);
    }];
}
- (void)updateDatas
{
    [_dataSource removeAllObjects];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    [_dataSource addObjectsFromArray:@[@{@"image":@"",@"title":kLocalizedString(@"Change_Password")},@{@"image":@"",@"title":kLocalizedString(@"CHANGE_MOBILE"),@"subTitle":([model.userRes.mobilePhone isEqualToString:@""] || !model.userRes.mobilePhone) ? @"Not Set": model.userRes.mobilePhone},@{@"image":@"",@"title":kLocalizedString(@"CHANGE_EMAIL"),@"subTitle":([model.userRes.email isEqualToString:@""] || !model.userRes.email) ? @"Not Set": model.userRes.email}]];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataSource[indexPath.row];
    accountSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSubCell"];
    cell.label.text = dic[@"title"];
    cell.imgView.image = [UIImage imageNamed:@""];
    cell.subTitleLabel.text = dic[@"subTitle"];
    cell.labelLeading.constant = 25;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        forgotPasswordView *view = [[NSBundle mainBundle] loadNibNamed:@"forgotPasswordView" owner:self options:nil].firstObject;
        view.type = resetType;
        view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
        [self.view addSubview:view];
//        ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        ChangeMobileOrEmailViewController *vc = [[ChangeMobileOrEmailViewController alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ChangeMobileOrEmailViewController *vc = [[ChangeMobileOrEmailViewController alloc] init];
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)loadUserInfo
{
    [SFNetworkManager get:SFNet.account.userInfo success:^(id  _Nullable response) {
        userResModel *resModel = [[userResModel alloc] initWithDictionary:response error:nil];
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        [model setUserRes:resModel];
        [[FMDBManager sharedInstance] updateUser:model ofAccount:model.account];
        [self updateDatas];
    } failed:^(NSError * _Nonnull error) {
        
    }];
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
