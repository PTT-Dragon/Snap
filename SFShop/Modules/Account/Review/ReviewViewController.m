//
//  ReviewViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/21.
//

#import "ReviewViewController.h"
#import "ReviewChildViewController.h"

@interface ReviewViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSArray<NSString *> *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic,strong) VTMagicController *magicController;


@end

@implementation ReviewViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Review");
    self.menuList = @[@"To Review", @"Rated"];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height-navBarHei);
    self.currentMenuIndex = self.magicController.currentPage;
    [self.magicController switchToPage:self.currentMenuIndex animated:0];
    [_magicController.magicView reloadData];
    
//    self.magicView.frame = CGRectMake(0, 0, MainScreen_width, 100);
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
    static NSString *reviewId = @"review.childController.identifier";
    ReviewChildViewController *reviewViewController = [magicView dequeueReusablePageWithIdentifier:reviewId];
    if (!reviewViewController) {
        reviewViewController = [[ReviewChildViewController alloc] init];
        reviewViewController.type = pageIndex == 0 ? 1: 2;
    }
    return reviewViewController;
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
@end
