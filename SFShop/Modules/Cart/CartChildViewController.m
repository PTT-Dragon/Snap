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
#import "SysParamsModel.h"
#import "CartEmptyView.h"
#import "ProductSimilarModel.h"
#import "UIViewController+parentViewController.h"
#import "CartViewController.h"
#import "favoriteModel.h"
#import "CategoryRankModel.h"
#import "ProductViewController.h"
#import "ProductSpecAttrsView.h"
#import "ProductStockModel.h"
#import "CartChoosePromotion.h"
#import "NSDictionary+add.h"

@interface CartChildViewController ()<UITableViewDelegate,UITableViewDataSource,CartTableViewCellDelegate,CartTitleCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray <CouponModel *>*couponDataSource;
@property (nonatomic,strong) NSMutableArray *campaignsDataSource;
@property (nonatomic,strong) CartModel *cartModel;
@property (nonatomic, strong) CartEmptyView *emptyView;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *hasCouponArr;
@property (nonatomic, strong) NSArray<ProductStockModel *> *stockModel;
@property (nonatomic,strong) ProductItemModel *selProductModel;
@property (nonatomic, strong) ProductSpecAttrsView *attrView;

@end

@implementation CartChildViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDatasNeedCoupon:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
//    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [self loadDatasNeedCoupon:YES];
//    }];
//    [self.tableView.mj_header beginRefreshing];
}
- (void)initUI
{
    _hasCouponArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartTitleCell" bundle:nil] forCellReuseIdentifier:@"CartTitleCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.offset(16);
        make.right.offset(-16);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(30);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.view.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
}
- (void)setAddModel:(addressModel *)addModel
{
    _addModel = addModel;
    [self loadDatasNeedCoupon:YES];
}
- (void)requestSimilar {
    MPWeakSelf(self)
    NSMutableDictionary *parm = [NSMutableDictionary dictionaryWithDictionary:@{
        @"q": @"",
        @"pageIndex": @(1),
        @"pageSize": @(10),
        @"sortType": @(1),
        @"offerIdList": [NSNull null],
        @"catgIds": @""//默认是外部传入的分类,如果 filter.filterParam 有该字段,会被新值覆盖
    }];
//    MBProgressHUD *hud = [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
//        [hud hideAnimated:YES];
        [weakself.dataArray removeAllObjects];
        weakself.dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        [weakself.dataArray addObjectsFromArray:self.dataModel.pageInfo.list];
        [weakself.emptyView configDataWithSimilarList:weakself.dataArray];
    } failed:^(NSError * _Nonnull error) {
//        [hud hideAnimated:YES];
        [MBProgressHUD showTopErrotMessage: [NSMutableString getErrorMessage:error][@"message"]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.cartModel.validCarts.count) {
        CartListModel *model = self.cartModel.invalidCarts[section-self.cartModel.validCarts.count];
        return model.shoppingCarts.count+1;
    }
    CartListModel *listModel = self.cartModel.validCarts[section];
    return listModel.shoppingCarts.count+1+listModel.campaignGroupsShoppingCarts.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cartModel.validCarts.count+self.cartModel.invalidCarts.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartListModel *listModel;
    if (indexPath.section >= self.cartModel.validCarts.count) {
        listModel = self.cartModel.invalidCarts[indexPath.section-self.cartModel.validCarts.count];
    }else{
        listModel = self.cartModel.validCarts[indexPath.section];
    }
    BOOL showView = NO;
    __block CGFloat labelHei = 0;
    if (indexPath.row > listModel.campaignGroupsShoppingCarts.count) {
        showView = NO;
    }else{
        showView = YES;
        CartItemModel * model = listModel.campaignGroupsShoppingCarts[indexPath.row-1];
        [listModel.campaignGroups enumerateObjectsUsingBlock:^(CartCampaignsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.campaignId isEqualToString:model.campaignId]) {
                labelHei = [obj.campaignName jk_heightWithFont:kFontLight(12) constrainedToWidth:150];
                *stop = YES;
            }
        }];
    }
    return indexPath.row == 0 ? 45: showView ? 140+labelHei: 117;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld-----%ld",indexPath.section,indexPath.row);
    if (indexPath.row == 0) {
        CartTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTitleCell"];
        cell.leftMargin.constant = 0;
        cell.rightMargin.constant = 0;
        cell.section = indexPath.section;
        CartListModel *model;
        if (indexPath.section >= self.cartModel.validCarts.count) {
            model = self.cartModel.invalidCarts[indexPath.section-self.cartModel.validCarts.count];
            cell.isInvalid = YES;
        }else{
            model = self.cartModel.validCarts[indexPath.section];
            cell.isInvalid = NO;
            NSString *hasCoupon = _hasCouponArr[indexPath.section];
            cell.hasCoupon = [hasCoupon isEqualToString:@"Y"];
        }
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    CartListModel *listModel;
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartTableViewCell"];
    cell.leftMargin.constant = 0;
    cell.rightMargin.constant = 0;
    if (indexPath.section >= self.cartModel.validCarts.count) {
        listModel = self.cartModel.invalidCarts[indexPath.section-self.cartModel.validCarts.count];
        cell.isInvalid = YES;
    }else{
        listModel = self.cartModel.validCarts[indexPath.section];
        cell.isInvalid = NO;
    }
    CartItemModel *model;
    if (indexPath.row > listModel.campaignGroupsShoppingCarts.count) {
        //普通商品
        model = listModel.shoppingCarts[indexPath.row-listModel.campaignGroupsShoppingCarts.count-1];
        cell.showCampaignsView = NO;
    }else{
        //参与活动的商品
        
//        model = campaignsModel.shoppingCarts.firstObject;
        model = listModel.campaignGroupsShoppingCarts[indexPath.row-1];
        cell.showCampaignsView = YES;
        [listModel.campaignGroups enumerateObjectsUsingBlock:^(CartCampaignsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.campaignId isEqualToString:model.campaignId]) {
                cell.campaignsModel = obj;
                *stop = YES;
            }
        }];
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

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 10)];
//    view.backgroundColor = RGBColorFrom16(0xf5f5f5);
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 10;
//}

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
    if (indexPath.row > listModel.campaignGroups.count) {
        model = listModel.shoppingCarts[indexPath.row-listModel.campaignGroups.count-1];
    }else{
        NSArray <CartCampaignsModel *>*arr = listModel.campaignGroups;//self.campaignsDataSource[indexPath.section];
        CartCampaignsModel *campaignsModel = arr[indexPath.row-1];
        model = campaignsModel.shoppingCarts.firstObject;
    }
    
    MPWeakSelf(self)
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:kLocalizedString(@"Delete") handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        UserModel *userModel = [FMDBManager sharedInstance].currentUser;
        if (userModel) {
            [SFNetworkManager post:SFNet.cart.del parameters:@{@"cartIds":@[model.shoppingCartId]} success:^(id  _Nullable response) {
                [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Delete_success")];
                [weakself loadDatasNeedCoupon:YES];
            } failed:^(NSError * _Nonnull error) {
                
            }];
        }else{
            NSMutableArray *listArr = [NSMutableArray array];
            [listArr addObjectsFromArray:self.cartModel.validCarts];
            [self.cartModel.validCarts enumerateObjectsUsingBlock:^(CartListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObjectsFromArray:obj.shoppingCarts];
                [obj.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                    if ([obj2.productId isEqualToString:model.productId]) {
                        [arr removeObject:obj2];
                        *stop = YES;
                        *stop2 = YES;
                        obj.shoppingCarts = arr;
                        if (obj.shoppingCarts.count == 0) {
                            [listArr removeObject:obj];
                            self.cartModel.validCarts = listArr;
                        }
                        [self updateLocalData];
                        [self loadDatasNeedCoupon:YES];
                    }
                }];
            }];
        }
        
    }];
    deleteRowAction.image = [UIImage imageNamed:@"trash"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    //移到收藏列表
    UIContextualAction *topRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:kLocalizedString(@"MOVE_TO_FAVOURITE") handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
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
- (void)updateLocalData
{
    //更新本地存储的购物车信息
    NSDictionary *dic = [NSDictionary dictionary];
    dic = [dic dicFromObject:self.cartModel];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"arrayKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)loadDatasNeedCoupon:(BOOL)needUpdateCoupon
{
    MPWeakSelf(self)
    UserModel *userModel = [FMDBManager sharedInstance].currentUser;
    if (!userModel && !_reduceFlag) {
        NSDictionary *aaaaa = [[NSUserDefaults standardUserDefaults] objectForKey:@"arrayKey"];
        self.cartModel = [[CartModel alloc] initWithDictionary:aaaaa error:nil];
        NSInteger i = 0;
        [self.hasCouponArr removeAllObjects];
        for (CartListModel *listModel in weakself.cartModel.validCarts) {
            [self.hasCouponArr addObject:@"N"];
            NSMutableArray *arr = [NSMutableArray array];
            [listModel.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:@{@"productId":obj.productId,@"offerCnt":obj.num}];
                [listModel.campaignGroups enumerateObjectsUsingBlock:^(CartCampaignsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [arr addObject:@{@"productId":obj.productId,@"offerCnt":obj.num}];
                    }];
                }];
            }];
            i++;
        }
//        [self handleDatas];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self calculateAmount];
        [self performSelector:@selector(showEmptyView) withObject:nil afterDelay:0.1];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_reduceFlag ? @"true": @"false" forKey:@"reduceFlag"];
    [params setValue:_addModel.contactStdId forKey:@"stdAddrId"];
    [SFNetworkManager get:SFNet.cart.cart parameters:params success:^(id  _Nullable response) {
        weakself.cartModel = [[CartModel alloc] initWithDictionary:response error:nil];
        
        if (needUpdateCoupon) {
            NSInteger i = 0;
            [weakself.hasCouponArr removeAllObjects];
            for (CartListModel *listModel in weakself.cartModel.validCarts) {
                [weakself.hasCouponArr addObject:@"N"];
                NSMutableArray *arr = [NSMutableArray array];
                [listModel.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [arr addObject:@{@"productId":obj.productId,@"offerCnt":obj.num}];
                }];
                [listModel.campaignGroups enumerateObjectsUsingBlock:^(CartCampaignsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [arr addObject:@{@"productId":obj.productId,@"offerCnt":obj.num}];
                    }];
                }];
                [weakself loadCouponsDatasWithStoreId:listModel.storeId productArr:arr row:i];
                i++;
            }
        }
        [weakself handleDatas];
        [weakself.tableView.mj_header endRefreshing];
        [weakself calculateAmount];
        [weakself showEmptyView];
    } failed:^(NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself showEmptyView];
        [MBProgressHUD hideFromKeyWindow];
//        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}

- (void)showEmptyView {
    [self.tableView.mj_header endRefreshing];
    if ([[UIViewController currentTopViewController] isKindOfClass:[CartViewController class]]) {
        CartViewController *cartVC = (CartViewController *)[UIViewController currentTopViewController];
        CGFloat bottomH = CGFLOAT_MIN;
        if (self.cartModel.validCarts.count > 0 || self.cartModel.invalidCarts.count > 0) {
            bottomH = 78;
            self.emptyView.hidden = YES;
            self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
            self.tableView.backgroundColor = RGBColorFrom16(0xf5f5f5);
        } else {
            self.emptyView.hidden = NO;
            [self requestSimilar];
            self.view.backgroundColor = [UIColor whiteColor];
            self.tableView.backgroundColor = [UIColor whiteColor];
        }
        [cartVC.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(bottomH);
        }];
    }
}

- (void)handleDatas
{
    [self.cartModel.validCarts enumerateObjectsUsingBlock:^(CartListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSMutableArray <CartCampaignsModel *>*arr = [NSMutableArray array];
        NSMutableArray <CartItemModel *>*arr = [NSMutableArray array];
        [obj.campaignGroups enumerateObjectsUsingBlock:^(CartCampaignsModel *  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            [obj2.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                [arr addObject:obj3];
            }];
        }];
        obj.campaignGroupsShoppingCarts = arr;
    }];
    [self.tableView reloadData];
}
- (void)loadCouponsDatasWithStoreId:(NSString *)storeId productArr:(NSArray *)productArr
{
//    //[MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:storeId forKey:@"storeId"];
    [params setValue:productArr forKey:@"products"];
    [SFNetworkManager post:SFNet.cart.coupons parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        weakself.couponDataSource = [CouponModel arrayOfModelsFromDictionaries:response error:nil];
        [weakself showCouponsView];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)loadCouponsDatasWithStoreId:(NSString *)storeId productArr:(NSArray *)productArr row:(NSInteger)row
{
    if (productArr.count == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:storeId forKey:@"storeId"];
    [params setValue:productArr forKey:@"products"];
    [SFNetworkManager post:SFNet.cart.coupons parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSMutableArray *arr = [NSMutableArray array];
        arr = [CouponModel arrayOfModelsFromDictionaries:response error:nil];
        for (NSInteger i = 0; i<self.hasCouponArr.count; i++) {
            if (self.hasCouponArr.count > row) {
                [self.hasCouponArr replaceObjectAtIndex:row  withObject:(arr.count == 0 ? @"N":@"Y")];
            }
        }
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)addToFavoriteWithID:(NSString *)offerId
{
    //添加到收藏列表
    [SFNetworkManager post:SFNet.cart.collection parametersArr:@[offerId] success:^(id  _Nullable response) {
        [self loadDatasNeedCoupon:NO];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)calculateAmount
{
    [self.delegate calculateAmount:self.cartModel];
}

- (void)showCouponsView
{
    CartChooseCouponView *view = [[NSBundle mainBundle] loadNibNamed:@"CartChooseCouponView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height-tabbarHei);
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
            for (CartCampaignsModel *itemModel in subModel.campaignGroups) {
                for (CartItemModel *itemItemModel in itemModel.shoppingCarts) {
                    itemItemModel.isSelected = selAll ? @"Y": @"N";
                    NSDictionary *dic = [itemItemModel toDictionary];
                    [modifyArr addObject:dic];
                }
            }
            [self.tableView reloadData];
            UserModel *model = [FMDBManager sharedInstance].currentUser;
            if (!model) {
                [self.cartModel.validCarts enumerateObjectsUsingBlock:^(CartListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.storeId isEqualToString:storeId]) {
                        [obj.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                            obj2.isSelected = selAll ? @"Y": @"N";
                        }];
                    }
                }];
                [self updateLocalData];
                [self loadDatasNeedCoupon:NO];
            }else{
                MPWeakSelf(self)
                [SFNetworkManager post:SFNet.cart.modify parameters:@{@"carts":modifyArr} success:^(id  _Nullable response) {
                    [weakself loadDatasNeedCoupon:NO];
                } failed:^(NSError * _Nonnull error) {
                    
                }];
            }
        }
    }
}
- (void)modifyCartInfoWithDic:(NSDictionary *)dic
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (!model) {
        CartItemModel *itemModel = [[CartItemModel alloc] initWithDictionary:dic error:nil];
        [self.cartModel.validCarts enumerateObjectsUsingBlock:^(CartListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                if ([obj2.productId isEqualToString:itemModel.productId]) {
                    obj2 = itemModel;
                }
            }];
        }];
        [self updateLocalData];
        [self loadDatasNeedCoupon:NO];
        return;
    }
    MPWeakSelf(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@[dic] forKey:@"carts"];
    [SFNetworkManager post:SFNet.cart.modify parameters:params success:^(id  _Nullable response) {
        [weakself loadDatasNeedCoupon:NO];
    } failed:^(NSError * _Nonnull error) {
        
    }];
    [self.tableView reloadData];
}
- (void)promotionWithModel:(CartItemModel *)model CartCampaignsModel:(CartCampaignsModel *)campaignsModel
{
    CartChoosePromotion *view = [[NSBundle mainBundle] loadNibNamed:@"CartChoosePromotion" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height-tabbarHei);
    view.model = model;
    view.block = ^(CartItemModel * _Nonnull itemModel) {
        [self modifyCartInfoWithDic:[itemModel toDictionary]];
    };
    [_vc.view addSubview:view];
}
- (void)skuActionWithModel:(CartItemModel *)model
{
    [self loadProductInfoWithModel:model];
}
- (void)selCouponWithStoreId:(NSString *)storeId productArr:(nonnull NSArray *)arr
{
    [self loadCouponsDatasWithStoreId:storeId productArr:arr];
}
- (void)selCouponWithStoreId:(NSString *)storeId productArr:(nonnull NSArray *)arr row:(NSInteger)row
{
    [self loadCouponsDatasWithStoreId:storeId productArr:arr row:row];
}


#pragma mark - 购物车相关
- (void)loadProductInfoWithModel:(CartItemModel *)model
{
    [SFNetworkManager get:[SFNet.offer getDetailOf: model.offerId.integerValue] parameters:@{} success:^(id  _Nullable response) {
        ProductDetailModel *detailModel = [[ProductDetailModel alloc] initWithDictionary: response error: nil];
        [self requestStockWithDetailModel:detailModel model:model];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
/**
 请求库存信息
 */
- (void)requestStockWithDetailModel:(ProductDetailModel *)detailModel model:(CartItemModel *)model {
    NSArray *arr = [detailModel.products jk_map:^id(ProductItemModel *object) {
        NSArray *inCmpIdList = model.campaignId ? @[model.campaignId] : @[];
        return @{
            @"productId": @(object.productId),
            @"offerCnt": @1,
            @"inCmpIdList": inCmpIdList
        };
    }];
    NSDictionary *param = @{
        @"stdAddrId": self.addModel ? self.addModel.contactStdId : @"1488",
                       @"stores": @[
                           @{
                               @"storeId": @(detailModel.storeId),
                               @"products": arr
                           }
                       ]
    };
    [SFNetworkManager post:SFNet.offer.stock parameters: param success:^(id  _Nullable response) {
        self.stockModel = [ProductStockModel arrayOfModelsFromDictionaries:response error:nil];
        [self showAttrsViewWithAttrType:cartType model:model productModel:detailModel stockModel:self.stockModel];
//        [self.stockModel  enumerateObjectsUsingBlock:^(ProductStockModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
//            [obj1.products enumerateObjectsUsingBlock:^(SingleProductStockModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
//                if (obj2.productId.integerValue == weakself.productId) {
//                    weakself.deliveryLabel.text = [NSString stringWithFormat:@"%@-%@day(s)", obj2.minDeliveryDays, obj2.maxDeliveryDays];
//                    *stop1 = YES;
//                    *stop2 = YES;
//                }
//            }];
//        }];
    } failed:^(NSError * _Nonnull error) {
        
    }];

}

- (void)showAttrsViewWithAttrType:(ProductSpecAttrsType)type model:(CartItemModel *)model productModel:(ProductDetailModel *)productDetailModel stockModel:(NSArray<ProductStockModel *> *)stockModel{
    self.selProductModel = [productDetailModel.products jk_filter:^BOOL(ProductItemModel *object) {
        return object.productId == model.productId.integerValue;
    }].firstObject;
    _attrView = [[ProductSpecAttrsView alloc] init];
    _attrView.attrsType = type;
//    _attrView.campaignsModel = model.campaigns;
    _attrView.selProductModel = self.selProductModel;
    _attrView.stockModel = stockModel;
    _attrView.model = productDetailModel;
    MPWeakSelf(self)
    MPWeakSelf(_attrView)
    _attrView.buyOrCartBlock = ^(ProductSpecAttrsType type) {
        switch (type) {
            case cartType:// 加入购物车
            {
                [weakself addToCartWithModel:model productModel:productDetailModel];
            }
                break;
            case buyType://购买
//            case groupSingleBuyType://团购活动单人购买
//            case groupBuyType://团购
//            {
//
//            }
                break;
            default:
                break;
        }
        weak_attrView.dismissBlock();
    };
    _attrView.dismissBlock = ^{
        [weak_attrView removeFromSuperview];
        
        
    };
    _attrView.chooseAttrBlock = ^() {
        weakself.selProductModel = weakself.attrView.selProductModel;
    };
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [rootView addSubview:_attrView];
    [_attrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(rootView);
        make.bottom.equalTo(_vc.view.mas_bottom).offset(0);
    }];
}
- (void)addToCartWithModel:(CartItemModel *)model productModel:(ProductDetailModel *)productDetailModel
{
    //在这里修改productid
    model.productId = [NSString stringWithFormat:@"%ld",self.selProductModel.productId];
    NSMutableArray *modifyArr = [NSMutableArray array];
    NSDictionary *dic = [model toDictionary];
    [modifyArr addObject:dic];
    
    [self.tableView reloadData];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.cart.modify parameters:@{@"carts":modifyArr} success:^(id  _Nullable response) {
        [weakself loadDatasNeedCoupon:NO];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage: error.localizedDescription];
    }];
}



- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
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

- (CartEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[CartEmptyView alloc] init];
        _emptyView.hidden = YES;
        _emptyView.backgroundColor = [UIColor whiteColor];
    }
    return _emptyView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
