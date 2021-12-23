//
//  CartChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartChildViewController.h"
#import "CartTableViewCell.h"
#import "CartTitleCell.h"
#import <MJRefresh/MJRefresh.h>

@interface CartChildViewController ()<UITableViewDelegate,UITableViewDataSource,CartTableViewCellDelegate,CartTitleCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) CartModel *cartModel;

@end

@implementation CartChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)initUI
{
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartTitleCell" bundle:nil] forCellReuseIdentifier:@"CartTitleCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.cartModel.validCarts.count) {
        CartListModel *model = self.cartModel.invalidCarts[section-self.cartModel.validCarts.count];
        return model.shoppingCarts.count+1;
    }
    CartListModel *model = self.cartModel.validCarts[section];
    return model.shoppingCarts.count+1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cartModel.validCarts.count+self.cartModel.invalidCarts.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 70: 117;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CartTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTitleCell"];
        CartListModel *model;
        if (indexPath.section >= self.cartModel.validCarts.count) {
            model = self.cartModel.invalidCarts[indexPath.section-self.cartModel.validCarts.count];
            cell.isInvalid = YES;
        }else{
            model = self.cartModel.validCarts[indexPath.section];
            cell.isInvalid = NO;
        }
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    CartListModel *listModel;
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCell"];
    if (indexPath.section >= self.cartModel.validCarts.count) {
        listModel = self.cartModel.invalidCarts[indexPath.section-self.cartModel.validCarts.count];
        cell.isInvalid = YES;
    }else{
        listModel = self.cartModel.validCarts[indexPath.section];
        cell.isInvalid = NO;
    }
    CartItemModel *model = listModel.shoppingCarts[indexPath.row-1];
    cell.model = model;
    cell.delegate = self;
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
    CartItemModel *model = indexPath.section < self.cartModel.validCarts.count ? [self.cartModel.validCarts[indexPath.section] shoppingCarts][indexPath.row-1] : [self.cartModel.invalidCarts[indexPath.section-self.cartModel.validCarts.count] shoppingCarts][indexPath.row-1] ;
    MPWeakSelf(self)
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [SFNetworkManager post:SFNet.cart.del parameters:@{@"cartIds":@[model.shoppingCartId]} success:^(id  _Nullable response) {
            [MBProgressHUD autoDismissShowHudMsg:@"DELETE SUCCESS"];
            [weakself loadDatas];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"删除"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    //移到收藏列表
    UIContextualAction *topRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Move to\nfavourite" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self addToFavoriteWithID:model.shoppingCartId];
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

//_addModel ? _addModel.contactStdId: @""
- (void)loadDatas
{
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_reduceFlag ? @"true": @"false" forKey:@"reduceFlag"];
    [params setValue:_addModel.contactStdId forKey:@"stdAddrId"];
    [SFNetworkManager get:SFNet.cart.cart parameters:params success:^(id  _Nullable response) {
        weakself.cartModel = [[CartModel alloc] initWithDictionary:response error:nil];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        [weakself calculateAmount];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)addToFavoriteWithID:(NSString *)offerId
{
    //添加到收藏列表
    [SFNetworkManager post:SFNet.cart.collection parametersArr:@[offerId] success:^(id  _Nullable response) {
        [self loadDatas];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)calculateAmount
{
    [self.delegate calculateAmount:self.cartModel];
}
- (void)modifyCartInfoWithDic:(NSDictionary *)dic
{
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.cart.modify parameters:@{@"carts":@[dic]} success:^(id  _Nullable response) {
        [weakself loadDatas];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [self.tableView reloadData];
}
- (void)selAll:(BOOL)selAll storeId:(nonnull NSString *)storeId
{
    NSMutableArray *modifyArr = [NSMutableArray array];
    for (CartListModel *subModel in _cartModel.validCarts) {
        if ([subModel.storeId isEqualToString:storeId]) {
            for (CartItemModel *itemModel in subModel.shoppingCarts) {
                itemModel.isSelected = selAll ? @"Y": @"N";
                NSDictionary *dic = [itemModel toDictionary];
                [modifyArr addObject:dic];
            }
            [self.tableView reloadData];
            MPWeakSelf(self)
            [SFNetworkManager post:SFNet.cart.modify parameters:@{@"carts":modifyArr} success:^(id  _Nullable response) {
                [weakself loadDatas];
            } failed:^(NSError * _Nonnull error) {
                
            }];
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
