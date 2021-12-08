//
//  MyCouponViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/9/26.
//

#import "MyCouponViewController.h"
#import "MyCouponChildViewController.h"
#import "CouponCenterChildViewController.h"
#import <VTMagic/VTMagic.h>
#import "CouponCenterViewController.h"

@interface MyCouponViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSArray *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic,strong) VTMagicController *magicController;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *couponCenterBtn;
@end

@implementation MyCouponViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Coupon";
    self.menuList = @[@"Available", @"Expired", @"Used"];
    self.articleCatgIdList = @[@(CouponType_Available),@(CouponType_Expired),@(CouponType_Used)];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height-navBarHei-78);
    [_magicController.magicView reloadData];
    [self.view addSubview:self.bottomView];
    
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
    static NSString *gridId = @"myCoupon.childController.identifier";
    MyCouponChildViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!gridViewController) {
        gridViewController = [[MyCouponChildViewController alloc] init];
        NSNumber *a = self.articleCatgIdList[pageIndex];
        gridViewController.type = a.integerValue;
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
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreen_height-78, MainScreen_width, 78)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.couponCenterBtn];
    }
    return _bottomView;
}
- (UIButton *)couponCenterBtn
{
    if (!_couponCenterBtn) {
        _couponCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _couponCenterBtn.backgroundColor = RGBColorFrom16(0xFF1659);
        _couponCenterBtn.titleLabel.font = CHINESE_BOLD(14);
        [_couponCenterBtn setTitle:@"COLLECT MORE COUPONS" forState:0];
        _couponCenterBtn.frame = CGRectMake(16, 16, MainScreen_width-32, 46);
        @weakify(self)
        [[_couponCenterBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            CouponCenterViewController *vc = [[CouponCenterViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _couponCenterBtn;
}
@end
