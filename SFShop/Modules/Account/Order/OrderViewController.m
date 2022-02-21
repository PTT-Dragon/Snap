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
#import "BaseMoreView.h"

@interface OrderViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSArray *typeList;
@property(nonatomic, strong) NSArray<NSString *> *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@property (nonatomic,strong) VTMagicController *magicController;
@property (nonatomic,strong) OrderNumModel *orderNumModel;
@property (nonatomic,strong) BaseMoreView *moreView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic,copy) NSString *searchText;

@end

@implementation OrderViewController

- (BOOL)shouldCheckLoggedIn {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"My_orders");
    [self layoutSubviews];
    [self loadOrderNum];
    [self addNoti];
    
}
- (void)addNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadOrderNum) name:@"KRefreshOrderNum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMoreView) name:@"KBaseMoreViewHidden" object:nil];;
}
- (void)hideMoreView
{
    [self.navSearchView clickRightBtn];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KRefreshOrderNum" object:nil];
}

- (void)layoutSubviews
{
    _searchText = @"";
    self.menuList = @[@"All", @"ToPay", @"ToShip",@"ToReceive",@"Completed",@"Canceled"];
    self.typeList = @[@(OrderListType_All),@(OrderListType_ToPay),@(OrderListType_ToShip),@(OrderListType_ToReceive),@(OrderListType_Successful),@(OrderListType_Cancel)];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei+10, MainScreen_width, MainScreen_height-navBarHei-10);
    
    [_magicController.magicView reloadData];
    NSInteger page = self.selType == OrderListType_All ? 0: self.selType == OrderListType_ToPay ? 1: self.selType == OrderListType_ToShip ? 2: self.selType == OrderListType_ToReceive ? 3: 0;
    [self.magicController switchToPage:page animated:YES];
    [self.view addSubview:self.navSearchView];
}

- (void)loadOrderNum {
    //[MBProgressHUD showHudMsg:@""];
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.order.num parameters:@{@"q":_searchText} success:^(id  _Nullable response) {
        weakself.orderNumModel = [OrderNumModel yy_modelWithDictionary:response];
        [weakself layoutSubview];
        [MBProgressHUD hideFromKeyWindow];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
    }];
}
- (void)layoutSubview {
    NSString *all = [NSString stringWithFormat:@"%@(%ld)",kLocalizedString(@"ALL"),self.orderNumModel.toPayNum+self.orderNumModel.toReceiveNum+self.orderNumModel.toDeliveryNum+self.orderNumModel.completedNum+self.orderNumModel.canceledNum];
    NSString *topay = [NSString stringWithFormat:@"%@(%ld)",kLocalizedString(@"TO_PAY"),self.orderNumModel.toPayNum];
    NSString *toship = [NSString stringWithFormat:@"%@(%ld)",kLocalizedString(@"TO_SHIP"),self.orderNumModel.toDeliveryNum];
    NSString *shiped = [NSString stringWithFormat:@"%@(%ld)",kLocalizedString(@"TO_RECEIVE"),self.orderNumModel.toReceiveNum];
    NSString *complete = [NSString stringWithFormat:@"%@(%ld)",kLocalizedString(@"COMPLETED"),self.orderNumModel.completedNum];
    NSString *cancel = [NSString stringWithFormat:@"%@(%ld)",kLocalizedString(@"CANCELLED"),self.orderNumModel.canceledNum];
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
        menuItem.titleLabel.font = kFontRegular(14);
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
    MPWeakSelf(self)
    orderViewController.block = ^{
        [weakself loadOrderNum];
    };
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
        _magicController.magicView.sliderColor = [UIColor blackColor];
        _magicController.magicView.itemSpacing = 80;
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
        backItem.itemActionBlock = ^(SFSearchState state,SFSearchModel *model,BOOL isSelected) {
            if (state == SFSearchStateInUnActive || state == SFSearchStateInFocuActive) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        SFSearchItem *rightItem = [SFSearchItem new];
        rightItem.icon = @"more-horizontal";
        rightItem.selectedIcon = @"more-vertical";
        __weak __typeof(self)weakSelf = self;
        rightItem.itemActionBlock = ^(SFSearchState state,SFSearchModel * _Nullable model,BOOL isSelected) {
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            if (isSelected) {
                strongSelf.navSearchView.textField.hidden = YES;
                strongSelf.navSearchView.backBtn.hidden = YES;
                strongSelf.titleLabel.hidden = NO;
                [strongSelf.moreView removeFromSuperview];
                strongSelf.moreView = [[BaseMoreView alloc] init];
                [strongSelf.view addSubview:self.moreView];
                [strongSelf.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(0);
                    make.top.mas_equalTo(self.navSearchView.mas_bottom);
                }];
            }else{
                strongSelf.navSearchView.backBtn.hidden = NO;
                strongSelf.titleLabel.hidden = YES;
                strongSelf.navSearchView.textField.hidden = NO;
                [strongSelf.moreView removeFromSuperview];
            }
        };
        _navSearchView = [[SFSearchNav alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, navBarHei + 10) backItme:backItem rightItem:rightItem searchBlock:^(NSString * _Nonnull qs) {
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            OrderChildViewController *vc = strongSelf.magicController.currentViewController;
            vc.searchText = qs;
            self.searchText = qs;
            [self loadOrderNum];
        }];
        [_navSearchView addSubview:self.titleLabel];
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_navSearchView.mas_centerY).offset(10);
            make.left.mas_equalTo(_navSearchView.mas_left).offset(20);
        }];
    }
    return _navSearchView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font =kFontBlod(16);
        _titleLabel.text = kLocalizedString(@"DIRECT_FUNCTION");
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}
@end
