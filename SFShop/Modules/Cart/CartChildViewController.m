//
//  CartChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartChildViewController.h"
#import "CartTableViewCell.h"
#import "CartTitleCell.h"
#import "CartModel.h"

@interface CartChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) CartModel *cartModel;

@end

@implementation CartChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDatas];
    [self initUI];
}
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartTitleCell" bundle:nil] forCellReuseIdentifier:@"CartTitleCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CartListModel *model = self.cartModel.validCarts[section];
    return model.shoppingCarts.count+1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cartModel.validCarts.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 70: 117;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CartTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTitleCell"];
        cell.model = self.cartModel.validCarts[indexPath.section];
        return cell;
    }
    CartListModel *listModel = self.cartModel.validCarts[indexPath.section];
    CartItemModel *model = listModel.shoppingCarts[indexPath.row-1];
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCell"];
    cell.model = model;
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 10)];
    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        
    }];
    deleteRowAction.image = [UIImage imageNamed:@"删除"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    //置顶
    UIContextualAction *topRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Move to\nfavourite" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self.tableView reloadData];
    }];
    topRowAction.image = [UIImage imageNamed:@"bookmark-0"];
    topRowAction.backgroundColor = RGBColorFrom16(0xFF1659);
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction,topRowAction]];
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


- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.cart.cart parameters:@{@"reduceFlag":_reduceFlag ? @"true": @"false",@"stdAddrId":_addModel.deliveryAddressId} success:^(id  _Nullable response) {
        weakself.cartModel = [[CartModel alloc] initWithDictionary:response error:nil];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
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
