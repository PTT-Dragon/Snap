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
    [self loadDatas:1];
    [self loadsubviews];
    [self layout];
    // Do any additional setup after loading the view.
}

- (void)loadDatas:(NSInteger)currentPage {
    NSDictionary *parm = @{
      @"q": @"",
      @"pageIndex": @(currentPage),
      @"pageSize": @(10),
      @"sortType": @"2",
      @"offerIdList": [NSNull null],
      @"catgIds": @(self.model.inner.catgId)
    };
    [SFNetworkManager post:SFNet.offer.offers parameters:parm success:^(id  _Nullable response) {
        self.dataModel = [CategoryRankModel yy_modelWithDictionary:response];
        [self.collectionView reloadData];
        NSLog(@"");
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (void)loadsubviews {
    [self.view addSubview:self.collectionView];
}

- (void)layout {
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataModel.pageInfo.list.count > 0?1:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModel.pageInfo.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    return cell;
//    ArticleListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"community.article.list.cell" forIndexPath:indexPath];
//    if(!cell){
//        cell = [[ArticleListCell alloc] init];
//    }
//    ArticleModel *cellModel = [self.model.list[indexPath.row] copy];
//    if (indexPath.row % 2 == 0) {
//        cellModel.contentTitle = [NSString stringWithFormat:@"%@%@", cellModel.contentTitle, @"-增加一些内容使变成多行"];
//    }
//    cell.model = cellModel;
//    return cell;
    return  nil;
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankPageInfoListModel *cellModel = self.dataModel.pageInfo.list[indexPath.row];
//    if (indexPath.row % 2 == 0) {
//        cellModel.contentTitle = [NSString stringWithFormat:@"%@%@", cellModel.contentTitle, @"-增加一些内容使变成多行"];
//    }
//    NSString *labelString = cellModel.contentTitle;
//    CGFloat cellWidth = (MainScreen_width - 18 * 2) / 2;
//    CGFloat labelWidth = cellWidth - 8 * 2;
//    CGFloat labelHeight = [labelString jk_heightWithFont: [UIFont systemFontOfSize:14] constrainedToWidth: labelWidth];
//    CGFloat cellHeight = cellWidth + 8 + 20 + 24 + 8 + labelHeight;
//    return cellHeight;
    
    if (indexPath.row % 2 == 0) {
        return 100;
    }
    return 120;
}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if(!_collectionView){
        _waterfallLayout = [[CommunityWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = 12;
        _waterfallLayout.insets = UIEdgeInsetsMake(12, 18, 12, 18);
        
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
