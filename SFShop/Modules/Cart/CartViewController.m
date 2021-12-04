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
@end

@implementation CartViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Shoppint Cart";
    _addressArr = [NSMutableArray array];
    [self loadDatas];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.address.addressList parameters:@{} success:^(id  _Nullable response) {
        NSError *error;
        [weakself.addressArr addObjectsFromArray:[addressModel arrayOfModelsFromDictionaries:response error:&error]];
        addressModel *model =  weakself.addressArr.firstObject;
        weakself.selAddModel = model;
        weakself.selAddModel.sel = YES;
        [weakself initUI];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)initUI
{
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
    [self.view addSubview:_addressBtn];
    [self updateAddress];
    
    self.menuList = @[@"All", @"Drop in price"];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei+40, MainScreen_width, MainScreen_height-navBarHei-tabbarHei-118);
    [_magicController.magicView reloadData];
    
//    self.magicView.frame = CGRectMake(0, navBarHei, MainScreen_width, self.view.jk_height-20);
//    self.magicView.navigationColor = [UIColor whiteColor];
//    self.magicView.sliderColor = [UIColor jk_colorWithHexString: @"#000000"];
//    self.magicView.sliderHeight = 1.0f;
//    self.magicView.layoutStyle = VTLayoutStyleDivide;
//    self.magicView.switchStyle = VTSwitchStyleDefault;
//    self.magicView.navigationHeight = 40.f;
//    self.magicView.dataSource = self;
//    self.magicView.delegate = self;
//    self.magicView.scrollEnabled = NO;
//    [self.magicView reloadData];
    [self.view addSubview:self.bottomView];
}
- (void)updateAddress
{
    [_addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@%@",_selAddModel.province,_selAddModel.city,_selAddModel.district,_selAddModel.street,_selAddModel.contactAddress] forState:0];
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

#pragma mark - 计算购物车选中总价
- (void)calculateAmount:(CartModel *)model
{
    self.amountLabel.text = [NSString stringWithFormat:@"RP %.f",model.totalPrice];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"RP %.f",model.totalPrice];
    self.priceLabel.text = [NSString stringWithFormat:@"RP %.f",model.totalOfferPrice];
    self.preferentialAmountLabel.text = [NSString stringWithFormat:@"-RP %.f",model.totalDiscount];
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.jk_height-78, MainScreen_width, 78)];
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

@end
