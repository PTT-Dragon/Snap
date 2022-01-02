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

@interface CategoryViewController ()<UITableViewDelegate>
@property (nonatomic, readwrite, strong) CategorySideTableView *sideTableView;//侧边栏
@property (nonatomic, readwrite, strong) CategoryContentCollectionView *contentCollectionView;//内容栏
@property (nonatomic, readwrite, strong) NSMutableDictionary *cacheDatas;//缓存数据
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Category";
    [self loadSides];
    [self loadsubviews];
//    self.sideTableView.dataArray = @[CategorySideModel.new,CategorySideModel.new];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loadsubviews {
    [self.view addSubview:self.sideTableView];
    [self.view addSubview:self.contentCollectionView];
}

- (void)loadSides {
    [SFNetworkManager get:SFNet.page.buyer_displaycatgs parameters:@{@"catgLevel":@"1"} success:^(id  _Nullable response) {
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
    [SFNetworkManager get:SFNet.page.buyer_displaycatgs parameters:@{@"parentCatgId":@(parentCatgId)} success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        NSArray *array = response;
        NSMutableArray *container = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            CategoryModel *model = [CategoryModel yy_modelWithDictionary:dict];
            if (model.children) {
                [container addObject:model.children];
            }
        }
        self.contentCollectionView.dataArray = container;
        [self.cacheDatas setObject:container forKey:[NSString stringWithFormat:@"%ld",parentCatgId]];
        [self.contentCollectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:error.localizedDescription];
    }];
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <CategoryModel *>*arr = [self.contentCollectionView.dataArray objectAtIndex:indexPath.section];
    CategoryModel *model = arr[indexPath.row];
    CategoryRankViewController *rank = [[CategoryRankViewController alloc] init];
    rank.model = model;
    [self.navigationController pushViewController:rank animated:YES];
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
        _sideTableView = [[CategorySideTableView alloc] initWithFrame:CGRectMake(0, navBarHei, KScale(95), self.view.bounds.size.height - navBarHei - tabbarHei) style:UITableViewStylePlain];
        _sideTableView.delegate = self;
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

@end
