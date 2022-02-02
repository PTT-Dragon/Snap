//
//  CommunityViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "CommunityViewController.h"
#import "CommunityChildController.h"
#import <Masonry/Masonry.h>
#import "CommunitySelectView.h"
#import "ArticleListModel.h"



@interface CommunityViewController ()

@property (nonatomic, strong) CommunityTabContainer *container;


@end

@implementation CommunityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = kLocalizedString(@"Community");

    self.container = [[CommunityTabContainer alloc] init];
    [self addChildViewController: self.container];
    [self.view addSubview: self.container.view];
    [self.container didMoveToParentViewController: self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 此处重新设置frame，因为VTMagicView内部对frame进行了处理
    self.container.view.frame = self.view.bounds;
}

@end



@interface CommunityTabContainer () <VTMagicViewDelegate, VTMagicViewDataSource>

@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, strong) NSArray<NSString *> *articleCatgIdList;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (nonatomic,strong) CommunitySelectView *selectView;
@property (nonatomic,strong) ArticleTitleModel *dataModel;
@property (nonatomic,strong) UIButton *rightBtn;

@end

@implementation CommunityTabContainer
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof CommunityChildController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj request];
    }];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self request];
}

- (void)request {
    [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
    [SFNetworkManager get: SFNet.article.articleCatgs parameters: nil success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        self.dataModel = [[ArticleTitleModel alloc] initWithDictionary:response error:nil];
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *recCatgs = [(NSDictionary *)response objectForKey:@"recCatgs"];
        NSArray *collCatgs = [(NSDictionary *)response objectForKey:@"collectCatgs"];
        if (recCatgs && recCatgs.count>0 && ![recCatgs isKindOfClass:[NSNull class]]) {
            [arr addObjectsFromArray:recCatgs];
        }
        if (collCatgs && recCatgs.count>0 && ![collCatgs isKindOfClass:[NSNull class]]) {
            [arr addObjectsFromArray:collCatgs];
        }
        self.menuList = [arr jk_map:^NSString *(NSDictionary *object) {
            return [object jk_stringForKey:@"articleCatgName"];
        }];
        self.articleCatgIdList = [arr jk_map:^NSString *(NSDictionary *object) {
            return [object jk_stringForKey:@"articleCatgId"];
        }];
        [self setupMagicView];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"error"]];
    }];
}

- (void)setupMagicView {
    self.currentMenuIndex = 0;
    [self.tabBarController.view addSubview:self.selectView];
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = [UIColor jk_colorWithHexString: @"#FF1659"];
    self.magicView.sliderHeight = 1.0f;
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.navigationHeight = 40.f;
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
    self.magicView.rightNavigatoinItem = self.rightBtn;
    
    [self.magicView reloadData];
}
- (void)showSelTableView
{
    
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
    static NSString *gridId = @"community.childController.identifier";
    CommunityChildController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//    if (!gridViewController) {
        gridViewController = [[CommunityChildController alloc] init];
//    }
    gridViewController.articleCatgId = self.articleCatgIdList[pageIndex];
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
- (void)updateTitleData
{
    NSMutableArray *arr = [NSMutableArray array];
    [self.dataModel.collectCatgs enumerateObjectsUsingBlock:^(ArticleTitleItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:@{@"articleCatgId":obj.articleCatgId,@"seq":@"0"}];
    }];
    [SFNetworkManager post:SFNet.article.collectionCatgs parametersArr:arr success:^(id  _Nullable response) {
        [self request];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (CommunitySelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[CommunitySelectView alloc] initWithFrame:CGRectMake(0, navBarHei+40, MainScreen_width, MainScreen_height)];
        _selectView.hidden = YES;
        _selectView.titleModel = self.dataModel;
        MPWeakSelf(self)
        _selectView.block = ^(ArticleTitleModel * _Nonnull titleModel) {
            weakself.dataModel = titleModel;
            [weakself updateTitleData];
            weakself.rightBtn.selected = NO;
            weakself.selectView.hidden = YES;
        };
    }
    return _selectView;
}
- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(10, MainScreen_width-40, 20, 20);
        [_rightBtn setImage:[UIImage imageNamed:@"swipe-down"] forState:0];
        [_rightBtn setImage:[UIImage imageNamed:@"swipe-up"] forState:UIControlStateSelected];
        @weakify(self)
        [[_rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
//            self.rightBtn.selected = !self.rightBtn.selected;
//            self.selectView.hidden = !self.rightBtn.selected;
            self.selectView.hidden = NO;
        }];
    }
    return _rightBtn;
}
@end
