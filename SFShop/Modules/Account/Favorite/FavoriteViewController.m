//
//  FavoriteViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "FavoriteViewController.h"
#import "FavoriteChildViewController.h"
#import "CategoryRankFilterViewController.h"
#import "CategoryRankModel.h"
#import "NSString+Fee.h"


@interface FavoriteViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSArray<NSString *> *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;
@property (nonatomic,strong) VTMagicController *magicController;
@property (nonatomic,strong) FavoriteNumModel *numModel;

@end

@implementation FavoriteViewController
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
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"MY_FAVORITES");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(jumpToFilterDetail) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0 , 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"WX20220121-231052"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    self.menuList = @[@"All", @"Pricedown"];
    for (NSInteger idx = 0; idx<self.menuList.count; idx++) {
        favoriteVCModel *model = [[favoriteVCModel alloc] init];
        model.type = idx == 0 ? ALLTYPE: idx == 1 ? PRICEDOWNTYPE: PROMOTIONTYPE;
        [self.dataSource addObject:model];
    }
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei, MainScreen_width, MainScreen_height-navBarHei);
    self.currentMenuIndex = self.magicController.currentPage;
    [self.magicController switchToPage:self.currentMenuIndex animated:0];
    [_magicController.magicView reloadData];
    [self loadDatas];
}
- (void)jumpToFilterDetail
{
    //加载缓存配置到数据层
    self.dataModel.filterCache = self.filterCacheModel;
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        if (type != CategoryRankFilterRefreshCancel) {
            FavoriteChildViewController *vc = self.magicController.childViewControllers[self.magicController.currentPage];
            if (model.priceModel.minPrice > -1) {
                model.priceModel.minPrice = [[NSString stringWithFormat:@"%.ld",model.priceModel.minPrice] multiplyCurrencyFloat];
            }
            if (model.priceModel.maxPrice > -1) {
                model.priceModel.maxPrice = [[NSString stringWithFormat:@"%.ld",model.priceModel.maxPrice] multiplyCurrencyFloat];
            }
            vc.rankModel = model;
            [vc reloadDatas];
        }
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.favorite.num parameters:@{@"catgFlag":@"Y",@"priceDownFlag":@"Y",@"invalidFlag":@"Y",@"promotionFlag":@"Y"} success:^(id  _Nullable response) {
        NSArray *catgNumList = [response objectForKey:@"catgNumList"];
        NSMutableArray *catgs = [NSMutableArray array];
        for (NSDictionary *dict in catgNumList) {
            NSString *catgId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"catgId"]];
            NSString *catgName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"catgName"]];
            CategoryRankCategoryModel *model = [[CategoryRankCategoryModel alloc] init];
            model.idStr = catgId;
            model.name = catgName;
            model.catgName = catgName;
            [catgs addObject:model];
        }
        weakself.numModel = [[FavoriteNumModel alloc] initWithDictionary:response error:nil];
        [weakself updateNum];
        self.dataModel = [[CategoryRankModel alloc] init];
        self.dataModel.catgIds = catgs;
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)updateNum
{
    NSString *all = [NSString stringWithFormat:@"%@(%@)",kLocalizedString(@"All"),self.numModel.totalNum];
    NSString *Pricedown = [NSString stringWithFormat:@"%@(%@)",kLocalizedString(@"DROP_IN_PRICE"),self.numModel.priceDownNum];
    self.menuList = @[all, Pricedown];
    [self.magicController.magicView reloadMenuTitles];
}
- (void)loadView
{
    [super loadView];
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
        menuItem.titleLabel.font = [UIFont fontWithName:@"PingFangHK-Semibold" size:14.f];
    }
    [menuItem setSelected: (itemIndex == self.currentMenuIndex)];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"myFavorite.childController.identifier";
    FavoriteChildViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!gridViewController) {
        gridViewController = [[FavoriteChildViewController alloc] init];
    }
    gridViewController.type = pageIndex == 1 ? PRICEDOWNTYPE:ALLTYPE;
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
- (CategoryRankFilterCacheModel *)filterCacheModel {
    if (_filterCacheModel == nil) {
        _filterCacheModel = [[CategoryRankFilterCacheModel alloc] init];
        self.filterCacheModel.minPrice = -1;//初始化为-1,传参时,传入@""表示没有指定min价格
        self.filterCacheModel.maxPrice = -1;//初始化为-1,传参时,传入@""表示没有指定max价格
    }
    return _filterCacheModel;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = [UIColor jk_colorWithHexString:@"333333"];
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
