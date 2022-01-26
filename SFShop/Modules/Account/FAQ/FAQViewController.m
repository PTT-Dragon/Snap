//
//  FAQViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "FAQViewController.h"
#import "FAQChildViewController.h"
#import "FAQListModel.h"
#import "SFSearchNav.h"

@interface FAQViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) NSArray<NSString *> *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@property (nonatomic,strong) VTMagicController *magicController;
@property (nonatomic,strong) UIView *emptyView;
@property (nonatomic,strong) UILabel *label;


@end

@implementation FAQViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Help_center");
    _dataSource = [NSMutableArray array];
    [self loadDatas];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.h5.faqList success:^(id  _Nullable response) {
        weakself.menuList = [FAQListModel arrayOfModelsFromDictionaries:response error:nil];
        [weakself initUI];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)initUI
{
    for (FAQListModel *model in self.menuList) {
        [self.dataSource addObject:model.faqCatgName];
    }
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei+50, MainScreen_width, MainScreen_height-navBarHei-44);
    [_magicController.magicView reloadData];
    [self.view addSubview:self.navSearchView];
}
/// VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return self.dataSource;
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
    FAQChildViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//    if (!gridViewController) {
        gridViewController = [[FAQChildViewController alloc] init];
        gridViewController.model = self.menuList[pageIndex];
    gridViewController.block = ^(BOOL show,NSString *qs) {
        if (show) {
            [self.view addSubview:self.emptyView];
            self.label.text = [NSString stringWithFormat:@"Sorry,we were unable to find results for %@",qs];
        }else{
            [self.emptyView removeFromSuperview];
        }
    };
//    }
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

#pragma mark - getter
- (SFSearchNav *)navSearchView {
    if (_navSearchView == nil) {
        __weak __typeof(self)weakSelf = self;
        _navSearchView = [[SFSearchNav alloc] initWithFrame:CGRectMake(-30, navBarHei, MainScreen_width+80, 44) backItme:nil rightItem:nil searchBlock:^(NSString * _Nonnull qs) {
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            FAQChildViewController *vc = strongSelf.magicController.currentViewController;
            vc.searchText = qs;
        }];
        _navSearchView.searchType = SFSearchTypeNoneInterface;
    }
    return _navSearchView;
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
- (UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navSearchView.bottom+10, MainScreen_width, 150)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        [_emptyView addSubview:self.label];
        UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, _label.bottom+10, MainScreen_width-32, 100)];
        explainLabel.numberOfLines = 0;
        explainLabel.textColor = RGBColorFrom16(0x999999);
        explainLabel.text = @"Please check the spelling use more general words and try again";
        [_emptyView addSubview:explainLabel];
    }
    return _emptyView;
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, MainScreen_width-32, 40)];
        _label.textColor = [UIColor blackColor];
        _label.font = CHINESE_BOLD(15);
        _label.numberOfLines = 0;
    }
    return _label;
}
@end
