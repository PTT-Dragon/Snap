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

@interface CartViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic,strong) NSMutableArray *addressArr;
@property (nonatomic,strong) UIButton *addressBtn;
@property (nonatomic,weak) addressModel *selAddModel;
@end

@implementation CartViewController

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




@end
