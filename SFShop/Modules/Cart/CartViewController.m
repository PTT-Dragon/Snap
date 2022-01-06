//
//  CartViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "CartViewController.h"
#import "addressModel.h"
#import "CartChooseAddressViewController.h"
#import "CartChildViewController.h"
#import "ProductCheckoutViewController.h"
#import "CartModel.h"
#import "OrderLogisticsModel.h"
#import "CouponsAvailableModel.h"

@interface CartViewController ()<VTMagicViewDelegate, VTMagicViewDataSource,CartChildViewControllerDelegate>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic,strong) NSMutableArray *addressArr;
@property (nonatomic,strong) UIButton *addressBtn;
@property (nonatomic,weak) addressModel *selAddModel;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) UIView *detailBgView;
@property (strong, nonatomic) UIButton *checkBtn;
@property (nonatomic,strong) UILabel *amountLabel;
@property (nonatomic,strong) UIButton *totalBtn;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *preferentialAmountLabel;
@property (nonatomic,strong) UILabel *totalAmountLabel;
@property (nonatomic,strong) VTMagicController *magicController;
@property (nonatomic,strong) CartModel *cartModel;
@end

@implementation CartViewController
- (BOOL)shouldCheckLoggedIn
{
    return NO;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Shopping_Cart");
    _addressArr = [NSMutableArray array];
    [self updateDatas];NSLocalizedString(@"test", nil);
    [self initUI];
    [self updateSubviews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)updateDatas
{
    FMDBManager *dbManager = [FMDBManager sharedInstance];
    @weakify(self)
    [RACObserve(dbManager, currentUser) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self loadAddressDatas];
    }];
}
- (void)loadAddressDatas
{
    MPWeakSelf(self)
    [MBProgressHUD showHudMsg:@""];
    [SFNetworkManager get:SFNet.address.addressList parameters:@{} success:^(id  _Nullable response) {
        NSError *error;
        [MBProgressHUD hideFromKeyWindow];
        [weakself.addressArr removeAllObjects];
        [weakself.addressArr addObjectsFromArray:[addressModel arrayOfModelsFromDictionaries:response error:&error]];
        addressModel *model =  weakself.addressArr.firstObject;
        weakself.selAddModel = model;
        weakself.selAddModel.sel = YES;
        [weakself updateSubviews];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (void)initUI
{
    [self.view addSubview:self.addressBtn];
    NSString *allCount = [NSString stringWithFormat:@"All(%ld)",self.cartModel.validCarts.count];
    NSString *dropCount = [NSString stringWithFormat:@"Drop in price(%ld)",0];
    self.menuList = @[allCount, dropCount];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei+40, MainScreen_width, MainScreen_height-navBarHei-tabbarHei-118);
    [_magicController.magicView reloadData];
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(78);
    }];
}
- (void)updateSubviews
{
    [self updateAddress];
}
- (void)updateAddress
{
    if (!_selAddModel) {
        [_addressBtn setTitle:@"Set You Address" forState:0];
    }else{
        [_addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@%@",_selAddModel.province,_selAddModel.city,_selAddModel.district,_selAddModel.street,_selAddModel.contactAddress] forState:0];
    }
    for (addressModel *model in self.addressArr) {
        if ([model.deliveryAddressId isEqualToString:_selAddModel.deliveryAddressId]) {
            model.sel = YES;
        }else{
            model.sel = NO;
        }
    }
}
- (void)toAddressListVC
{
    CartChooseAddressViewController *vc = [[CartChooseAddressViewController alloc] init];
    vc.addressListArr = self.addressArr;
    vc.view.frame = CGRectMake(0, 0, self.view.jk_width, self.view.jk_height);
    MPWeakSelf(self)
    vc.selBlock = ^(addressModel * model) {
        weakself.selAddModel = model;
        [weakself updateAddress];
    };
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
}
/// VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return self.menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor: [UIColor jk_colorWithHexString: @"#7B7B7B"] forState:UIControlStateNormal];
        [menuItem setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Trueno" size:17.f];
    }
    [menuItem setSelected: (itemIndex == self.currentMenuIndex)];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"myFavorite.childController.identifier";
    CartChildViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!gridViewController) {
        gridViewController = [[CartChildViewController alloc] init];
        gridViewController.addModel = _selAddModel;
        gridViewController.reduceFlag = (pageIndex == 0) ? NO: YES;
        gridViewController.delegate = self;
    }
    return gridViewController;
}

/// VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    NSLog(@"pageIndex:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
    self.currentMenuIndex = pageIndex;
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
//    viewController.view.frame = magicView.bounds;
    NSLog(@"pageIndex:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

- (void)btnClick:(UIButton *)btn {
    // TODO: 跳转checkout页
    MPWeakSelf(self)
    NSArray <CartListModel *> *items = self.cartModel.validCarts;
    NSString *deliveryMode = [[items.firstObject shoppingCarts].firstObject deliveryMode];//派送模式
    NSString *storeId = [items.firstObject storeId];//购买id
    NSMutableArray *products = [NSMutableArray array];
    NSMutableArray *productDetailModels = [NSMutableArray array];
    NSMutableArray *attrValues = [NSMutableArray array];
    NSMutableArray *productIds = [NSMutableArray array];
    NSMutableArray *counts = [NSMutableArray array];
    for (CartListModel *model in items) {
        for (CartItemModel *cartItem in model.shoppingCarts) {
            //判断是否选中..真牛逼
            if ([cartItem.isSelected isEqualToString:@"Y"]) {
                [products addObject:@{@"productId":cartItem.productId,@"offerCnt":cartItem.num}];
                ProductDetailModel *subModel = [[ProductDetailModel alloc] init];
                subModel.storeName = model.storeName;
                subModel.offerName = cartItem.productName;
                subModel.salesPrice = cartItem.salesPrice;
                subModel.storeId = model.storeId.intValue;
                ProductCarouselImgModel *img = [[ProductCarouselImgModel alloc] init];
                img.imgUrl = cartItem.imgUrl;
                subModel.carouselImgUrls = @[img];
                [productDetailModels addObject:subModel];
                [counts addObject:@(cartItem.num.intValue)];
                [attrValues addObject:@"测试分类"];
                [productIds addObject:cartItem.productId];
            }
        }
    }
    
    if (!self.selAddModel.deliveryAddressId ||  [self.selAddModel.deliveryAddressId isEqualToString:@""]
        || !storeId || [storeId isEqualToString:@""]) {
        [MBProgressHUD autoDismissShowHudMsg:@"Set You Address"];
        return;
    }
    
    NSDictionary *logisticsParams = @{
        @"deliveryAddressId": self.selAddModel.deliveryAddressId,
        @"deliveryMode":deliveryMode,
        @"stores": @[
                @{
                    @"storeId": storeId,
                    @"products": products
                }
        ],
    };
    NSMutableDictionary *calcfeeParams = [NSMutableDictionary dictionaryWithDictionary:logisticsParams];
    [calcfeeParams addEntriesFromDictionary:@{
        @"sourceType": @"GWCGM", // TODO:此处参考h5
    }];
    
    [MBProgressHUD showHudMsg:@"Calculating..."];
    __block ProductCalcFeeModel *feeModel = nil;
    __block OrderLogisticsModel *logisticsModel = nil;
    __block CouponsAvailableModel *couponsModel = nil;
    dispatch_group_t group = dispatch_group_create();
    //请求结算数据
    
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [SFNetworkManager post:SFNet.order.calcfee parameters: calcfeeParams success:^(id  _Nullable response) {
            feeModel = [[ProductCalcFeeModel alloc] initWithDictionary:response error:nil];
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"Calcfee Failed!"];
            dispatch_group_leave(group);
        }];
    });
    
    //请求配送数据
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [SFNetworkManager post:SFNet.order.logistics parameters:logisticsParams success:^(id  _Nullable response) {
            NSDictionary *data = ((NSArray *)response).firstObject;
            logisticsModel = [[OrderLogisticsModel alloc] initWithDictionary:data error:nil];
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"logistics Failed!"];
            dispatch_group_leave(group);
        }];
    });
    
    //请求商品优惠券数据
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        [SFNetworkManager post:SFNet.order.couponsAvailable parameters:logisticsParams success:^(id  _Nullable response) {
            couponsModel = [[CouponsAvailableModel alloc] initWithDictionary:response error:nil];
            dispatch_group_leave(group);
        } failed:^(NSError * _Nonnull error) {
            [MBProgressHUD autoDismissShowHudMsg: @"logistics Failed!"];
            dispatch_group_leave(group);
        }];
    });

    //获取数据,并进入结算页面
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideFromKeyWindow];
        if (!feeModel) {
            return;
        }
        
        if (!logisticsModel) {
            return;
        }
        
        if (!couponsModel) {
            NSLog(@"");
        }
        
        ProductCheckoutViewController *vc = [[ProductCheckoutViewController alloc] init];
        [vc setProductModels:productDetailModels
                  attrValues:attrValues
                  productIds:productIds
              logisticsModel:logisticsModel
                 couponModel:couponsModel
                addressModel:weakself.selAddModel
                    feeModel:feeModel
                       count:counts
                  sourceType:@"GWCGM"];
        [weakself.navigationController pushViewController:vc animated:YES];
    });

}

#pragma mark - 计算购物车选中总价
- (void)calculateAmount:(CartModel *)model
{
    self.cartModel = model;
    self.amountLabel.text = [NSString stringWithFormat:@"RP %.f",model.totalPrice];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"RP %.f",model.totalPrice];
    self.priceLabel.text = [NSString stringWithFormat:@"RP %.f",model.totalOfferPrice];
    self.preferentialAmountLabel.text = [NSString stringWithFormat:@"-RP %.f",model.totalDiscount];
    __block NSInteger count = 0;
    [self.cartModel.validCarts enumerateObjectsUsingBlock:^(CartListModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.campaignGroups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            count += 1;
        }];
    }];
    NSString *allCount = [NSString stringWithFormat:@"All(%ld)",self.cartModel.validCarts.count+count];
    /**
        降价标签的数量未完成 因为没数据
     **/
    NSString *dropCount = [NSString stringWithFormat:@"Drop in price(%ld)",self.cartModel.validCarts.count];
    self.menuList = @[allCount,dropCount];
    [self.magicController.magicView reloadMenuTitles];
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.checkBtn];
        [_bottomView addSubview:self.amountLabel];
        [_bottomView addSubview:self.totalBtn];
    }
    return _bottomView;
}
- (UIView *)detailView
{
    if (!_detailView) {
        _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, self.detailBgView.jk_height-320, MainScreen_width, 320)];
        _detailView.backgroundColor = [UIColor whiteColor];
        [_detailView addSubview:self.priceLabel];
        [_detailView addSubview:self.preferentialAmountLabel];
        [_detailView addSubview:self.totalAmountLabel];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 23, MainScreen_width-100, 17)];
        titleLabel.text = @"Details of preferential amount";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = CHINESE_MEDIUM(14);
        [_detailView addSubview:titleLabel];
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImage:[UIImage imageNamed:@"nav_close_bold"] forState:0];
        delBtn.frame = CGRectMake(MainScreen_width-40, 16, 24, 24);
        @weakify(self)
        [[delBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.detailBgView removeFromSuperview];
        }];
        [_detailView addSubview:delBtn];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 74, 120, 17)];
        label1.text = @"Product price";
        label1.font = CHINESE_MEDIUM(14);
        [_detailView addSubview:label1];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 103, 170, 17)];
        label2.text = @"Preferential amount";
        label2.font = CHINESE_MEDIUM(14);
        [_detailView addSubview:label2];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 132, 120, 17)];
        label3.text = @"Total";
        label3.font = CHINESE_MEDIUM(14);
        [_detailView addSubview:label3];
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 153, 170, 17)];
        label4.text = @"(without shipping/coupons)";
        label4.textColor = RGBColorFrom16(0x555555);
        label4.font = CHINESE_MEDIUM(12);
        [_detailView addSubview:label4];
    }
    return _detailView;
}
- (UIView *)detailBgView
{
    if (!_detailBgView) {
        _detailBgView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height-navBarHei-tabbarHei-78)];
        _detailBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [_detailBgView addSubview:self.detailView];
    }
    return _detailBgView;
}
- (UIButton *)checkBtn
{
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.frame = CGRectMake(MainScreen_width-176, 16, 160, 46);
        _checkBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        [_checkBtn setTitle:@"CHECK OUT" forState:0];
        _checkBtn.titleLabel.font = CHINESE_BOLD(14);
        [_checkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}
- (UIButton *)totalBtn
{
    if (!_totalBtn) {
        _totalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_totalBtn setTitle:@"Total ▴ " forState:0];//▴▾
        _totalBtn.titleLabel.font = CHINESE_SYSTEM(12);
        [_totalBtn setTitleColor:RGBColorFrom16(0x999999) forState:0];
        _totalBtn.frame = CGRectMake(15, 15, 70, 20);
        @weakify(self)
        [[_totalBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            self.totalBtn.selected = !self.totalBtn.selected;
            [self.totalBtn setTitle:self.totalBtn.selected ? @"Total ▾ ": @"Total ▴ " forState:0];
            if (self.totalBtn.selected) {
                [self.view addSubview:self.detailBgView];
            }else{
                [self.detailBgView removeFromSuperview];
            }
            
        }];
    }
    return _totalBtn;
}
- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, 200, 19)];
        _amountLabel.font = [UIFont fontWithName:@"System SemiBold" size:16];
        _amountLabel.text = @"RP";
        _amountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _amountLabel;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen_width-150, 74, 135, 19)];
        _priceLabel.font = [UIFont fontWithName:@"System SemiBold" size:14];
        _priceLabel.text = @"RP";
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
- (UILabel *)totalAmountLabel
{
    if (!_totalAmountLabel) {
        _totalAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen_width-150, 103, 135, 19)];
        _totalAmountLabel.font = [UIFont fontWithName:@"System SemiBold" size:14];
        _totalAmountLabel.text = @"RP";
        _totalAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalAmountLabel;
}
- (UILabel *)preferentialAmountLabel
{
    if (!_preferentialAmountLabel) {
        _preferentialAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainScreen_width-150, 141, 135, 19)];
        _preferentialAmountLabel.font = [UIFont fontWithName:@"System SemiBold" size:14];
        _preferentialAmountLabel.text = @"RP";
        _preferentialAmountLabel.textColor = RGBColorFrom16(0xFF1659);
        _preferentialAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _preferentialAmountLabel;
}
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor redColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.scrollEnabled = NO;
    }
    return _magicController;
}
- (UIButton *)addressBtn
{
    if (!_addressBtn) {
        _addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addressBtn.frame = CGRectMake(0, navBarHei, MainScreen_width, 40);
        _addressBtn.backgroundColor = [UIColor whiteColor];
        _addressBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _addressBtn.titleLabel.numberOfLines = 0;
        [_addressBtn jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self toAddressListVC];
        }];
        [_addressBtn setTitleColor:RGBColorFrom16(0x7b7b7b) forState:0];
        _addressBtn.titleLabel.font = CHINESE_SYSTEM(13);
    }
    return _addressBtn;
}
@end
