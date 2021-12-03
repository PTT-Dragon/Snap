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
@property (strong, nonatomic) UIButton *checkBtn;
@property (nonatomic,strong) UILabel *amountLabel;
@property (nonatomic,strong) UIButton *totalBtn;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UILabel *preferentialAmountLabel;
@property (nonatomic,strong) UILabel *totalAmountLabel;
@end

@implementation CartViewController
- (void)awakeFromNib
{
    [super awakeFromNib];
    
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
    _addressBtn.frame = CGRectMake(0, 0, MainScreen_width, 20);
    _addressBtn.backgroundColor = [UIColor whiteColor];
    _addressBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_addressBtn jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self toAddressListVC];
    }];
    [_addressBtn setTitleColor:RGBColorFrom16(0x7b7b7b) forState:0];
    _addressBtn.titleLabel.font = CHINESE_SYSTEM(13);
    [self.view addSubview:_addressBtn];
    [self updateAddress];
    
    self.menuList = @[@"All", @"Drop in price"];
    
    self.magicView.frame = CGRectMake(0, navBarHei, MainScreen_width, self.view.jk_height-20);
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = [UIColor jk_colorWithHexString: @"#000000"];
    self.magicView.sliderHeight = 1.0f;
    self.magicView.layoutStyle = VTLayoutStyleDivide;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.navigationHeight = 40.f;
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
    self.magicView.scrollEnabled = NO;
    [self.magicView reloadData];
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
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.jk_height-78, MainScreen_width, 78)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.checkBtn];
        [_bottomView addSubview:self.amountLabel];
    }
    return _bottomView;
}
- (UIView *)detailView
{
    if (!_detailView) {
        _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.jk_height-78, MainScreen_width, 78)];
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
    }
    return _detailView;
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
        [_totalBtn setTitle:@"" forState:0];
    }
    return _totalBtn;
}
- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 39, 200, 19)];
        _amountLabel.font = [UIFont fontWithName:@"System SemiBold" size:16];
        _amountLabel.text = @"RP";
    }
    return _amountLabel;
}


@end
