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

@interface FavoriteViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSArray<NSString *> *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;
@property (nonatomic,strong) VTMagicController *magicController;

@end

@implementation FavoriteViewController
- (BOOL)shouldCheckLoggedIn
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"My_Favorites");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(jumpToFilterDetail) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0 , 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"rank_filters"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    self.menuList = @[@"All", @"Pricedown", @"Promotion"];
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
    
    [self loadDatas];
}
- (void)jumpToFilterDetail
{
    //加载缓存配置到数据层
    self.dataModel.filterCache = self.filterCacheModel;
    
    CategoryRankPriceModel *priceModel = [CategoryRankPriceModel new];
    priceModel.minPrice = self.filterCacheModel.minPrice;
    priceModel.maxPrice = self.filterCacheModel.maxPrice;
    self.dataModel.priceModel = priceModel;

    for (CategoryRankCategoryModel *model in self.dataModel.catgIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.categoryId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        FavoriteChildViewController *vc = self.childViewControllers[self.magicController.currentPage];
//        vc.vcModel.catgId = model.catgIds.firstObject;
//        vc.vcModel.maxPrice =
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}
- (void)loadDatas
{
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
        
        self.dataModel = [[CategoryRankModel alloc] init];
        self.dataModel.catgIds = catgs;
    } failed:^(NSError * _Nonnull error) {
        
    }];
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
        menuItem.titleLabel.font = [UIFont fontWithName:@"Trueno" size:17.f];
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
    gridViewController.vcModel = self.dataSource[pageIndex];
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
