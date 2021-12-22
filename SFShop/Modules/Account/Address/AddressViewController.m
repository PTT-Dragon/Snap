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
//    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
//        [self loadMoreDatas];
//    }];
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
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self deleteCellWithRow:indexPath.row];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"删除"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
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
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    addressModel *model = self.dataSource[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    !self.addressBlock?:self.addressBlock(model);
}

- (void)deleteCellWithRow:(NSInteger)row
{
    addressModel *model = self.dataSource[row];
    MPWeakSelf(self)
    [SFNetworkManager post:[SFNet.address setAddressDeleteOfdeliveryAddressId:model.deliveryAddressId] parameters:@{} success:^(id  _Nullable response) {
        [weakself.dataSource removeObjectAtIndex:row];
        [weakself.tableView reloadData];
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
