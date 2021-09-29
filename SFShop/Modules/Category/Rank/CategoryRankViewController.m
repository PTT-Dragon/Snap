//
//  CategoryRankViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import "CategoryRankViewController.h"
#import "CommunityWaterfallLayout.h"
#import "CategoryRankModel.h"

@interface CategoryRankViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,CommunityWaterfallLayoutProtocol>
@property (nonatomic, readwrite, strong) UICollectionView *collectionView;
@property (nonatomic, readwrite, strong) CommunityWaterfallLayout *waterfallLayout;
@property (nonatomic, readwrite, assign) NSInteger currentPage;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
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
        CategoryRankModel *model = [CategoryRankModel yy_modelWithDictionary:response];
        NSLog(@"");
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (void)loadsubviews {
    
}

- (void)layout {
    
}

//#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//#pragma mark - UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.model.list.count ? self.model.list.count : 0;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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
//}
//
//#pragma mark - CollectionWaterfallLayoutProtocol
//- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
//    ArticleModel *cellModel = [self.model.list[indexPath.row] copy];
//    if (indexPath.row % 2 == 0) {
//        cellModel.contentTitle = [NSString stringWithFormat:@"%@%@", cellModel.contentTitle, @"-增加一些内容使变成多行"];
//    }
//    NSString *labelString = cellModel.contentTitle;
//    CGFloat cellWidth = (MainScreen_width - 18 * 2) / 2;
//    CGFloat labelWidth = cellWidth - 8 * 2;
//    CGFloat labelHeight = [labelString jk_heightWithFont: [UIFont systemFontOfSize:14] constrainedToWidth: labelWidth];
//    CGFloat cellHeight = cellWidth + 8 + 20 + 24 + 8 + labelHeight;
//    return cellHeight;
//}

#pragma mark - getter
- (UICollectionView *)collectionView {
    if(!_collectionView){
        _waterfallLayout = [[CommunityWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = 12;
        _waterfallLayout.insets = UIEdgeInsetsMake(12, 18, 12, 18);
        
        _collectionView = [[UICollectionView alloc] initWithFrame: CGRectZero collectionViewLayout:_waterfallLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerNib: [UINib nibWithNibName:@"ArticleListCell" bundle:nil] forCellWithReuseIdentifier:@"community.article.list.cell"];
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
