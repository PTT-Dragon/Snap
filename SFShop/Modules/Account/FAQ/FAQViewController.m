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
#import "BaseNavView.h"
#import "BaseMoreView.h"
#import "NSString+Add.h"

@interface FAQViewController ()<VTMagicViewDelegate, VTMagicViewDataSource,BaseNavViewDelegate>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) NSArray<NSString *> *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@property (nonatomic,strong) VTMagicController *magicController;
@property (nonatomic,strong) UIView *emptyView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *explainLabel;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;


@end

@implementation FAQViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView {
    [_moreView removeFromSuperview];
    _moreView = [[BaseMoreView alloc] init];
    [self.view addSubview:_moreView];
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(@"Help_center")];
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
    
    UIImageView *imgV = [[UIImageView alloc] init];
    [self.view addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_navSearchView).offset(9.5);
        make.right.offset(-30);
        make.width.height.mas_equalTo(25);
    }];
    imgV.image = [UIImage imageNamed:@"ic_nav_search"];
    UITapGestureRecognizer *searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchAction)];
    imgV.userInteractionEnabled = YES;
    [imgV addGestureRecognizer:searchTap];
    
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
        menuItem.titleLabel.font = kFontBlod(14);
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
            self.label.text = [NSString stringWithFormat:@"%@ %@%@",kLocalizedString(@"FAQ_NO_DATA_TITLE"),qs,kLocalizedString(@"FAQ_QUESTION")];
            self.label.height = [self.label.text calHeightWithFont:CHINESE_BOLD(15) lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width-32, MAXFLOAT)];
            self.explainLabel.top = self.label.bottom+10;
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
- (void)searchAction
{
    [_navSearchView searchClick:_navSearchView.searchBtn];
}

#pragma mark - getter
- (SFSearchNav *)navSearchView {
    if (_navSearchView == nil) {
        __weak __typeof(self)weakSelf = self;
        _navSearchView = [[SFSearchNav alloc] initWithFrame:CGRectMake(-30, navBarHei, MainScreen_width+80, 52) backItme:nil rightItem:nil searchBlock:^(NSString * _Nonnull qs) {
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            FAQChildViewController *vc = strongSelf.magicController.currentViewController;
            vc.searchText = qs;
        }];
        _navSearchView.searchType = SFSearchTypeNoneInterface;
        _navSearchView.backgroundColor = [UIColor clearColor];
    }
    return _navSearchView;
}
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor blackColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
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
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navSearchView.bottom+10, MainScreen_width, MainScreen_height - navBarHei-84)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        [_emptyView addSubview:self.label];
        _explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, _label.bottom+10, MainScreen_width-32, 44)];
        _explainLabel.numberOfLines = 0;
        _explainLabel.textColor = RGBColorFrom16(0x999999);
        _explainLabel.font = CHINESE_BOLD(15);
        _explainLabel.text = kLocalizedString(@"FAQ_NO_DATA_CONTENT");
        [_emptyView addSubview:_explainLabel];
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
        _label.textAlignment = NSTextAlignmentLeft;
    }
    return _label;
}
@end
