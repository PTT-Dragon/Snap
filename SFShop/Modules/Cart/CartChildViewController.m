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
#import "CartChooseCouponView.h"
#import "CouponModel.h"
#import "EmptyView.h"
#import "SysParamsModel.h"

@interface CartChildViewController ()<UITableViewDelegate,UITableViewDataSource,CartTableViewCellDelegate,CartTitleCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray <CouponModel *>*couponDataSource;
@property (nonatomic,strong) NSMutableArray *campaignsDataSource;
@property (nonatomic,strong) CartModel *cartModel;
@property (nonatomic, strong) EmptyView *emptyView;

@end

@implementation CartChildViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDatas];
}
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
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(90);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.cartModel.validCarts.count) {
        CartListModel *model = self.cartModel.invalidCarts[section-self.cartModel.validCarts.count];
        return model.shoppingCarts.count+1;
    }
    CartListModel *model = self.cartModel.validCarts[section];
    NSArray *arr = self.campaignsDataSource[section];
    __block NSInteger count = 0;
    [arr enumerateObjectsUsingBlock:^(CartCampaignsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += obj.shoppingCarts.count;
    }];
    return model.shoppingCarts.count+1+arr.count;
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
    NSLog(@"%ld-----%ld",indexPath.section,indexPath.row);
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
    CartItemModel *model;
    if (indexPath.row > listModel.shoppingCarts.count) {
        NSArray <CartCampaignsModel *>*arr = self.campaignsDataSource[indexPath.section];
        CartCampaignsModel *campaignsModel = arr[indexPath.row-listModel.shoppingCarts.count-1];
        model = campaignsModel.shoppingCarts.firstObject;
    }else{
        model = listModel.shoppingCarts[indexPath.row-1];
    }
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
    if (indexPath.row == 0) {
        return nil;
    }
    //删除
    CartListModel *listModel;
    if (indexPath.section >= self.cartModel.validCarts.count) {
        listModel = self.cartModel.invalidCarts[indexPath.section-self.cartModel.validCarts.count];
        
    }else{
        listModel = self.cartModel.validCarts[indexPath.section];
        
    }
    CartItemModel *model;
    if (indexPath.row > listModel.shoppingCarts.count) {
        NSArray <CartCampaignsModel *>*arr = self.campaignsDataSource[indexPath.section];
        CartCampaignsModel *campaignsModel = arr[indexPath.row-listModel.shoppingCarts.count-1];
        model = campaignsModel.shoppingCarts.firstObject;
    }else{
        model = listModel.shoppingCarts[indexPath.row-1];
    }
    MPWeakSelf(self)
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [SFNetworkManager post:SFNet.cart.del parameters:@{@"cartIds":@[model.shoppingCartId]} success:^(id  _Nullable response) {
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Delete_success")];
            [weakself loadDatas];
        } failed:^(NSError * _Nonnull error) {
            
        }];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"trash"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    //移到收藏列表
    UIContextualAction *topRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Move to\nfavourite" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self addToFavoriteWithID:model.shoppingCartId];
    }];
    topRowAction.image = [UIImage imageNamed:@"love-3"];
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
    return kLocalizedString(@"Delete");
}
- (void)loadDatas
{
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_reduceFlag ? @"true": @"false" forKey:@"reduceFlag"];
    [params setValue:_addModel.contactStdId forKey:@"stdAddrId"];
    [SFNetworkManager get:SFNet.cart.cart parameters:params success:^(id  _Nullable response) {
        weakself.cartModel = [[CartModel alloc] initWithDictionary:response error:nil];
        [weakself handleDatas];
        [weakself.tableView reloadData];
        [weakself.tableView.mj_header endRefreshing];
        [weakself calculateAmount];
        [weakself showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself showEmptyView];
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

- (void)showEmptyView {
    if (self.cartModel.validCarts.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
}

- (void)handleDatas
{
    self.campaignsDataSource = [NSMutableArray array];
    [self.cartModel.validCarts enumerateObjectsUsingBlock:^(CartListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray <CartCampaignsModel *>*arr = [NSMutableArray array];
        [obj.campaignGroups enumerateObjectsUsingBlock:^(CartCampaignsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:obj];
        }];
        [self.campaignsDataSource addObject:arr];
    }];
}
- (void)loadCouponsDatasWithStoreId:(NSString *)storeId productArr:(NSArray *)productArr
{
    [MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:storeId forKey:@"storeId"];
    [params setValue:productArr forKey:@"products"];
    [SFNetworkManager post:SFNet.cart.coupons parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        weakself.couponDataSource = [CouponModel arrayOfModelsFromDictionaries:response error:nil];
        [weakself showCouponsView];
    } failed:^(NSError * _Nonnull error) {
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
- (void)showCouponsView
{
    CartChooseCouponView *view = [[NSBundle mainBundle] loadNibNamed:@"CartChooseCouponView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
    view.couponDataSource = self.couponDataSource;
    [[baseTool getCurrentVC].view addSubview:view];
}
#pragma mark - delegate
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
- (void)selCouponWithStoreId:(NSString *)storeId productArr:(nonnull NSArray *)arr
{
    [self loadCouponsDatasWithStoreId:storeId productArr:arr];
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

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoShoppingCarType];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
