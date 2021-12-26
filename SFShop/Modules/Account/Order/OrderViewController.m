//
//  OrderViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import "OrderViewController.h"
#import "OrderChildViewController.h"
#import "SFSearchNav.h"
#import "OrderModel.h"

@interface OrderViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSArray *typeList;
@property(nonatomic, strong) NSArray<NSString *> *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@property (nonatomic,strong) VTMagicController *magicController;
@property (nonatomic,strong) OrderNumModel *orderNumModel;

@end

@implementation OrderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Orders";
    self.menuList = @[@"All", @"ToPay", @"ToShip",@"ToReceive",@"Completed",@"Canceled"];
    self.typeList = @[@(OrderListType_All),@(OrderListType_ToPay),@(OrderListType_ToShip),@(OrderListType_ToReceive),@(OrderListType_Successful),@(OrderListType_Cancel)];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height-navBarHei);
    self.magicController.currentPage = self.selType == OrderListType_All ? 1: 2;
    self.currentMenuIndex = self.magicController.currentPage;
    [_magicController.magicView reloadData];
    [self.view addSubview:self.navSearchView];
    [self loadOrderNum];
}
- (void)loadOrderNum
{
    [MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.order.num parameters:@{} success:^(id  _Nullable response) {
        weakself.orderNumModel = [OrderNumModel yy_modelWithDictionary:response];
        [weakself layoutSubview];
        [MBProgressHUD hideFromKeyWindow];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
    }];
}
- (void)layoutSubview
{
    NSString *all = [NSString stringWithFormat:@"ALL(%ld)",self.orderNumModel.toPayNum+self.orderNumModel.toReceiveNum+self.orderNumModel.toDeliveryNum+self.orderNumModel.completedNum+self.orderNumModel.canceledNum];
    NSString *topay = [NSString stringWithFormat:@"ToPay(%ld)",self.orderNumModel.toPayNum];
    NSString *toship = [NSString stringWithFormat:@"ToShip(%ld)",self.orderNumModel.toDeliveryNum];
    NSString *shiped = [NSString stringWithFormat:@"ToReceive(%ld)",self.orderNumModel.toReceiveNum];
    NSString *complete = [NSString stringWithFormat:@"Completed(%ld)",self.orderNumModel.completedNum];
    NSString *cancel = [NSString stringWithFormat:@"Canceled(%ld)",self.orderNumModel.canceledNum];
    self.menuList = @[all,topay,toship,shiped,complete,cancel];
    [self.magicController.magicView reloadMenuTitles];
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
    static NSString *gridId = @"order.childController.identifier";
    OrderChildViewController *orderViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//    if (!orderViewController) {
        orderViewController = [[OrderChildViewController alloc] init];
//    }
    NSNumber *a = [self.typeList objectAtIndex:pageIndex];
    orderViewController.type = a.integerValue;
    return orderViewController;
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
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor redColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.scrollEnabled = NO;
    }
    return _magicController;
}

- (SFSearchNav *)navSearchView {
    if (_navSearchView == nil) {
        SFSearchItem *backItem = [SFSearchItem new];
        backItem.icon = @"nav_back";
        backItem.itemActionBlock = ^(SFSearchModel *model,BOOL isSelected) {
            [self.navigationController popViewControllerAnimated:YES];
        };
        SFSearchItem *rightItem = [SFSearchItem new];
        rightItem.icon = @"more-horizontal";
        rightItem.selectedIcon = @"more-vertical";
        rightItem.itemActionBlock = ^(SFSearchModel * _Nullable model,BOOL isSelected) {
            
        };
        __weak __typeof(self)weakSelf = self;
        _navSearchView = [[SFSearchNav alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, navBarHei + 10) backItme:backItem rightItem:rightItem searchBlock:^(NSString * _Nonnull qs) {
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            OrderChildViewController *vc = self.magicController.currentViewController;
            vc.searchText = qs;
        }];
    }
    return _navSearchView;
}
    
    
@end
