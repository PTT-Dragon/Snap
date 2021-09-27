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

@interface CategoryViewController ()
@property (nonatomic, readwrite, strong) CategorySideTableView *sideTableView;
@property (nonatomic, readwrite, strong) CategoryContentCollectionView *contentCollectionView;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    [self loadsubviews];
    
//    self.sideTableView.dataArray = @[CategorySideModel.new,CategorySideModel.new];
    // Do any additional setup after loading the view.
}

- (void)loadDatas {
    [SFNetworkManager get:SFNet.page.buyer_displaycatgs parameters:@{@"catgLevel":@"1"} success:^(id  _Nullable response) {
        NSArray *array = response;
        for (NSDictionary *dict in array) {
            CategoryModel *model = [CategoryModel yy_modelWithDictionary:dict];
            [self.sideTableView.dataArray addObject:model];
        }
        NSLog(@"");
        [self.sideTableView reloadData];
        [self.sideTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        CategoryModel *model = self.sideTableView.dataArray.firstObject;
        [self loadContentDatas:model.inner.catgId];
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (void)loadContentDatas:(NSInteger)parentCatgId {
    [SFNetworkManager get:SFNet.page.buyer_displaycatgs parameters:@{@"parentCatgId":@(parentCatgId)} success:^(id  _Nullable response) {
        NSArray *array = response;
        for (NSDictionary *dict in array) {
            CategoryModel *model = [CategoryModel yy_modelWithDictionary:dict];
            [self.contentCollectionView.dataArray addObject:model.children];
        }
        [self.contentCollectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"");
    }];
    
}

- (void)loadsubviews {
    [self.view addSubview:self.sideTableView];
    [self.view addSubview:self.contentCollectionView];
}

#pragma mark - Getter
- (CategorySideTableView *)sideTableView {
    if (_sideTableView == nil) {
        _sideTableView = [[CategorySideTableView alloc] initWithFrame:CGRectMake(0, navBarHei, KScale(95), self.view.bounds.size.height - navBarHei - tabbarHei) style:UITableViewStylePlain];
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
    }
    return _contentCollectionView;
}

@end