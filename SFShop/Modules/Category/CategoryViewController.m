//
//  CategoryViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/9/24.
//

#import "CategoryViewController.h"
#import "CategorySideTableView.h"
#import "CategoryModel.h"
#import "CategoryContentCollectionView.h"
#import "CategoryRankViewController.h"
#import "SFSearchNav.h"
#import "BaseNavView.h"
#import "BaseMoreView.h"
#import "ProductViewController.h"
#import "CouponCenterViewController.h"
#import "PublicWebViewController.h"

@interface CategoryViewController ()<UITableViewDelegate,UICollectionViewDelegate>
@property (nonatomic, readwrite, strong) CategorySideTableView *sideTableView;//侧边栏
@property (nonatomic, readwrite, strong) CategoryContentCollectionView *contentCollectionView;//内容栏
@property (nonatomic, readwrite, strong) NSMutableDictionary *cacheDatas;//缓存数据
@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@property (nonatomic, readwrite, strong) NSURLSessionDataTask *lastRequestTask;
@property (nonatomic, readwrite, strong) BaseMoreView *moreView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
//@property (nonatomic, readwrite, strong) SFSearchNav *navSearchView;
@end

@implementation CategoryViewController
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizedString(@"Category");
    [self loadSides];
    [self loadsubviews];
    [self addNoti];
}
- (void)addNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMoreView) name:@"KBaseMoreViewHidden" object:nil];;
}
- (void)hideMoreView
{
    [self.navSearchView clickRightBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadsubviews {
    [self.view addSubview:self.navSearchView];
    [self.view addSubview:self.sideTableView];
    [self.view addSubview:self.contentCollectionView];
//    [self.view addSubview:self.moreView];
}

- (void)loadSides {
    [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
     [SFNetworkManager get:SFNet.page.buyer_displaycatgs parameters:@{@"catgLevel":@"1"} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSArray *array = response;
        for (NSDictionary *dict in array) {
            CategoryModel *model = [CategoryModel yy_modelWithDictionary:dict];
            [self.sideTableView.dataArray addObject:model];
        }
        [self.sideTableView reloadData];
        [self.sideTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        CategoryModel *model = self.sideTableView.dataArray.firstObject;
        [self loadContentDatas:model.inner.catgId];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:error.localizedDescription];
    }];
}

- (void)loadContentDatas:(NSInteger)parentCatgId {
    [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
    if (self.lastRequestTask) {
        [self.lastRequestTask cancel];
    }
    __block NSURLSessionDataTask *task;
    task = [SFNetworkManager get:SFNet.page.buyer_displaycatgs parameters:@{@"parentCatgId":@(parentCatgId)} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSArray *array = response;
        NSMutableArray *container = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            CategoryModel *model = [CategoryModel yy_modelWithDictionary:dict];
            if (model.children) {
                for (CategoryModel *subModel in model.children) {
                    subModel.inner.groupName = model.inner.catgName;
                }
                [container addObject:model.children];
            }
        }
        
        if (task.taskIdentifier == self.lastRequestTask.taskIdentifier) {
            self.contentCollectionView.dataArray = container;
        }
        [self.cacheDatas setObject:container forKey:[NSString stringWithFormat:@"%ld",parentCatgId]];
        [self.contentCollectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        if (error.code == -999) {//取消
            [MBProgressHUD hideFromKeyWindow];
        } else {
            [MBProgressHUD autoDismissShowHudMsg:error.localizedDescription];
        }
    }];
    self.lastRequestTask = task;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <CategoryModel *>*arr = [self.contentCollectionView.dataArray objectAtIndex:indexPath.section];
    CategoryModel *model = arr[indexPath.row];
    NSString *objType = model.inner.catgRela.objType;
    NSString *objId = model.inner.catgRela.objValue.objId;
    if ([objType isEqualToString:@"Category"]) {//分类
        CategoryRankViewController *rank = [[CategoryRankViewController alloc] init];
        rank.model = model;
        [self.navigationController pushViewController:rank animated:YES];
    } else if ([objType isEqualToString:@"FilteredProducts"]) {//分类,初始化搜索
        CategoryRankViewController *rank = [[CategoryRankViewController alloc] init];
        if (model.inner.catgRela.objValue.filteredProductsRela) {
            NSMutableDictionary *filteredProductsRela = [NSMutableDictionary dictionaryWithDictionary:model.inner.catgRela.objValue.filteredProductsRela];
            NSString *q = [filteredProductsRela objectForKey:@"productName"];
            [filteredProductsRela setObject:q forKey:@"q"];
            [filteredProductsRela removeObjectForKey:@"productName"];
            model.inner.catgRela.objValue.filteredProductsRela = filteredProductsRela;
        }
        rank.model = model;
        [self.navigationController pushViewController:rank animated:YES];
    } else if ([objType isEqualToString:@"ProductDetail"]) {//详情页
        NSString *offerId = [objId componentsSeparatedByString:@","].firstObject;
        NSString *productId = [objId componentsSeparatedByString:@","].lastObject;
        ProductViewController *vc = [[ProductViewController alloc] init];
        vc.offerId = offerId.integerValue;
        vc.productId = productId.integerValue;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([objType isEqualToString:@"CustomizedPage"]) {//自定义页面
        PublicWebViewController *vc = [[PublicWebViewController alloc] init];
        UserModel *model = [FMDBManager sharedInstance].currentUser;
        vc.url = [NSString stringWithFormat:@"%@/group/%@",Host,objId];
        vc.sysAccount = model.account;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([objType isEqualToString:@"FunctionPage"]) {//领券中心
        CouponCenterViewController *vc = [[CouponCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(MainScreen_width, KScale(47));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(MainScreen_width, KScale(16));
}

#pragma mark UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *model = [self.sideTableView.dataArray objectAtIndex:indexPath.row];
    NSArray *arr = [self.cacheDatas objectForKey:[NSString stringWithFormat:@"%ld",model.inner.catgId]];
    if (arr) {
        self.contentCollectionView.dataArray = arr;
        [self.contentCollectionView reloadData];
    } else {
        [self loadContentDatas:model.inner.catgId];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

#pragma mark - Getter

- (CategorySideTableView *)sideTableView {
    if (_sideTableView == nil) {
        _sideTableView = [[CategorySideTableView alloc] initWithFrame:CGRectMake(0, navBarHei+10, KScale(95), self.view.bounds.size.height - navBarHei - tabbarHei-10) style:UITableViewStylePlain];
        _sideTableView.delegate = self;
        _sideTableView.backgroundColor = [UIColor jk_colorWithHexString:@"#f5f5f5"];
    }
    return _sideTableView;
}

- (CategoryContentCollectionView *)contentCollectionView {
    if (_contentCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.minimumLineSpacing = KScale(16);
        layout.minimumInteritemSpacing = KScale(16);
        layout.sectionInset = UIEdgeInsetsMake(KScale(8), KScale(8), KScale(8), KScale(8));
        layout.itemSize = CGSizeMake(KScale(72), KScale(106));
        _contentCollectionView = [[CategoryContentCollectionView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.sideTableView.frame), CGRectGetMinY(self.sideTableView.frame), KScale(280), CGRectGetHeight(self.sideTableView.frame)) collectionViewLayout:layout];
        _contentCollectionView.backgroundColor = [UIColor whiteColor];
        _contentCollectionView.delegate = self;
    }
    return _contentCollectionView;
}

- (NSMutableDictionary *)cacheDatas {
    if (_cacheDatas == nil) {
        _cacheDatas = [NSMutableDictionary dictionary];
    }
    return _cacheDatas;
}
- (SFSearchNav *)navSearchView {
    if (_navSearchView == nil) {
        SFSearchItem *backItem = [SFSearchItem new];
        backItem.icon = @"nav_back";
        backItem.itemActionBlock = ^(SFSearchState state, SFSearchModel *model,BOOL isSelected) {
            if (state == SFSearchStateInUnActive || state == SFSearchStateInFocuActive) {
                [self.moreView removeFromSuperview];
                [self.tabBarController setSelectedIndex:0];
            }
        };
        SFSearchItem *rightItem = [SFSearchItem new];
        rightItem.icon = @"more-horizontal";
        rightItem.selectedIcon = @"more-vertical";
        rightItem.itemActionBlock = ^(SFSearchState state, SFSearchModel * _Nullable model,BOOL isSelected) {
            if (isSelected) {
                self.navSearchView.textField.hidden = YES;
                self.navSearchView.backBtn.hidden = YES;
                self.titleLabel.hidden = NO;
                [self.moreView removeFromSuperview];
                self.moreView = [[BaseMoreView alloc] init];
                [self.tabBarController.view addSubview:self.moreView];
                [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.mas_equalTo(0);
                    make.top.mas_equalTo(self.navSearchView.mas_bottom);
                }];
            }else{
                self.navSearchView.backBtn.hidden = NO;
                self.titleLabel.hidden = YES;
                self.navSearchView.textField.hidden = NO;
                [self.moreView removeFromSuperview];
            }
            
        };
        __weak __typeof(self)weakSelf = self;
        _navSearchView = [[SFSearchNav alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, navBarHei + 10) backItme:backItem rightItem:rightItem searchBlock:^(NSString * _Nonnull qs) {

        }];
        _navSearchView.fakeTouchBock = ^{
            __weak __typeof(weakSelf)strongSelf = weakSelf;
            CategoryRankViewController *vc = [[CategoryRankViewController alloc] init];
            vc.activeSearch = YES;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
        _navSearchView.searchType = SFSearchTypeFake;
        
        [_navSearchView addSubview:self.titleLabel];
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_navSearchView.mas_centerY).offset(10);
            make.left.mas_equalTo(_navSearchView.mas_left).offset(20);
        }];
    }
    return _navSearchView;
}

- (BaseMoreView *)moreView {
    if (!_moreView) {
        _moreView = [[BaseMoreView alloc] initWithFrame:CGRectMake(0, self.navSearchView.bottom, MainScreen_width, self.view.height)];
    }
    return _moreView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.text = kLocalizedString(@"DIRECT_FUNCTION");
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}
@end
