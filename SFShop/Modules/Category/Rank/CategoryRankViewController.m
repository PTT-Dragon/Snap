//
//  CategoryRankViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import "CategoryRankViewController.h"
#import "CommunityWaterfallLayout.h"
#import "CategoryRankModel.h"
#import "CategoryRankCell.h"
#import "NSString+Add.h"
#import <MJRefresh/MJRefresh.h>

@interface CategoryRankViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CommunityWaterfallLayoutProtocol>
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) CommunityWaterfallLayout *waterfallLayout;
@property (nonatomic, readwrite, assign) NSInteger currentPage;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@property (nonatomic, readwrite, strong) CategoryRankModel *dataModel;
@end

@implementation CategoryRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadsubviews];
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)loadDatas:(NSInteger)currentPage {
    NSDictionary *parm = @{
      @"q": @"",
      @"pageIndex": @(currentPage),
      @"pageSize": @(20),
      @"sortType": @"2",
      @"offerIdList": [NSNull null],
      @"catgIds": @(self.model.inner.catgId)
    };
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        self.dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
            [self.dataArray removeAllObjects];
        }
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
        [self.dataArray addObjectsFromArray:self.dataModel.pageInfo.list];
        [self.collectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg:error.localizedDescription];
        if ([self.collectionView.mj_header isRefreshing]) {
            [self.collectionView.mj_header endRefreshing];
        }
        if ([self.collectionView.mj_footer isRefreshing]) {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)loadsubviews {
    [self.view addSubview:self.collectionView];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadDatas:self.currentPage];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage += 1;
        [self loadDatas:self.currentPage];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)layout {
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count > 0?1:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankCell" forIndexPath:indexPath];
    CategoryRankPageInfoListModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    return cell;
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankPageInfoListModel *cellModel = self.dataArray[indexPath.row];
    if (!cellModel.height) {
        CGFloat titleHeight = [cellModel.offerName calHeightWithFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width - KScale(12) * 3 - KScale(16) * 2, 100)];
        CGFloat imageHeigjt = KScale(166);
        CGFloat tagHeight = KScale(14);
        CGFloat priceHeight = KScale(14);
        CGFloat discountHeight = KScale(14);
        CGFloat levelHeight = KScale(12);
        cellModel.height = imageHeigjt + KScale(16) + tagHeight + KScale(12) + titleHeight + KScale(16) + priceHeight + KScale(4) + discountHeight + KScale(12) + levelHeight + KScale(25);
    }
    return cellModel.height;
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if(!_collectionView){
        _waterfallLayout = [[CommunityWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = KScale(12);
        _waterfallLayout.insets = UIEdgeInsetsMake(KScale(12), KScale(16), KScale(12), KScale(16));
        
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, navBarHei + 64, MainScreen_width, MainScreen_height - navBarHei - 64) collectionViewLayout:_waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor clearColor];

        [_collectionView registerClass:CategoryRankCell.class forCellWithReuseIdentifier:@"CategoryRankCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
