//
//  AddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "EmptyView.h"
#import "AddressTitleCell.h"
#import "BaseNavView.h"
#import "BaseMoreView.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,AddAddressViewControllerDelegate,BaseNavViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;

@end

@implementation AddressViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView {
    [_moreView removeFromSuperview];
    _moreView = [[BaseMoreView alloc] init];
    [self.view addSubview:_moreView];
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataSource = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTitleCell" bundle:nil] forCellReuseIdentifier:@"AddressTitleCell"];
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(@"My_Address")];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) { 
        make.top.mas_equalTo(self.navView.mas_bottom).offset(20);
        make.left.offset(16);
        make.right.offset(-16);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
//    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
//        [self loadMoreDatas];
//    }];
    [self.tableView.mj_header beginRefreshing];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_top).offset(90);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-120);
    }];
    [self.addBtn setTitle:kLocalizedString(@"ADD_ADDRESS") forState:0];
}
- (void)updateUserInfo
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    [[FMDBManager sharedInstance] updateUser:model ofAccount:model.account];
    
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
        [weakself updateUserInfo];
        [weakself showEmptyView];
    } failed:^(NSError * _Nonnull error) {
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
    return self.dataSource.count == 0 ? 0: self.dataSource.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AddressTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTitleCell"];
        return cell;
    }
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
    [cell setContent:self.dataSource[indexPath.row-1]];
    MPWeakSelf(self)
    cell.block = ^(addressModel * _Nonnull model) {
        AddAddressViewController *vc = [[AddAddressViewController alloc] init];
        vc.model = model;
        vc.delegate = weakself;
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 49: 132;
}
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self deleteCellWithRow:indexPath.row];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UIContextualAction *defaultAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"set default" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self setDefaultWithRow:indexPath.row];
    }];
    defaultAction.backgroundColor = RGBColorFrom16(0xeab861);
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction,defaultAction]];
    return config;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
 
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kLocalizedString(@"Delete");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    addressModel *model = self.dataSource[indexPath.row - 1];
    !self.addressBlock?:self.addressBlock(model);
}

- (void)deleteCellWithRow:(NSInteger)row
{
    addressModel *model = self.dataSource[row-1];
    MPWeakSelf(self)
    [SFNetworkManager post:[SFNet.address setAddressDeleteOfdeliveryAddressId:model.deliveryAddressId] parameters:@{} success:^(id  _Nullable response) {
        [weakself.dataSource removeObjectAtIndex:row-1];
        [weakself.tableView reloadData];
        [weakself showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [weakself showEmptyView];
    }];
}
- (void)setDefaultWithRow:(NSInteger)row
{
    addressModel *model = self.dataSource[row-1];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:model.deliveryAddressId forKey:@"deliveryAddressId"];
    [params setValue:@"Y" forKey:@"isDefault"];
    MPWeakSelf(self)
    [SFNetworkManager post:[SFNet.address setAddressModifyOfdeliveryAddressId:model.deliveryAddressId] parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"ADD SUCCESS"];
        [weakself.tableView.mj_header beginRefreshing];
    } failed:^(NSError * _Nonnull error) {
        
    }];
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
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = RGBColorFrom16(0xf5f5f5);
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoAddressType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
