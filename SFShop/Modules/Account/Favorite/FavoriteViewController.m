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
@property (nonatomic, readwrite, strong) CategoryRankFilterCacheModel *filterCacheModel;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"My Favorites";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(jumpToFilterDetail) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0 , 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"rank_filters"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:button];
    //    self.navigationItem.rightBarButtonItem = rightItem;
    
    //增加了一个spaceItem元素,用来控制customView距离右边的间距
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    //rightBarButtonItem中包装的button距离它父控件,也就是rightBarButtonItem的值是5,当我们把width设置为-15后,相当于把整个rightBarButtonItem向右移动了10
    spaceItem.width = -15;
    self.navigationItem.rightBarButtonItems = @[rightItem];
    self.menuList = @[@"All", @"Pricedown", @"Promotion"];
    
    self.magicView.frame = CGRectMake(0, 0, MainScreen_width, 100);
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
    for (CategoryRankServiceModel *model in self.dataModel.serviceIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.serverId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankCategoryModel *model in self.dataModel.catgIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.categoryId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankBrandModel *model in self.dataModel.brandIds) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.brandId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    for (CategoryRankEvaluationModel *model in self.dataModel.evaluations) {
        if (model.idStr && [model.idStr isEqualToString:self.filterCacheModel.evaluationId]) {
            model.isSelected = YES;
            break;
        }
    }
    
    CategoryRankFilterViewController *filterVc = [[CategoryRankFilterViewController alloc] init];
    filterVc.model = self.dataModel;
    filterVc.filterRefreshBlock = ^(CategoryRankFilterRefreshType type, CategoryRankModel * _Nonnull model) {
        FavoriteChildViewController *vc = self.childViewControllers[self.currentPage];
        
    };
    [self presentViewController:filterVc animated:YES completion:nil];
}
- (void)loadDatas
{
    [SFNetworkManager get:SFNet.favorite.num parameters:@{@"catgFlag":@"Y",@"priceDownFlag":@"Y",@"invalidFlag":@"Y",@"promotionFlag":@"Y"} success:^(id  _Nullable response) {
        self.dataModel = [CategoryRankModel yy_modelWithDictionary:response];
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
@end
