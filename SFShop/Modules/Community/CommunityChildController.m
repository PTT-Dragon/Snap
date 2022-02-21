//
//  CommunityChildController.m
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import "CommunityChildController.h"
#import <JKCategories/JKCategories.h>
#import "ArticleListModel.h"
#import "CommunityWaterfallLayout.h"
#import "ArticleListCell.h"
#import "CommunityDetailController.h"
#import <MJRefresh.h>

@interface CommunityChildController ()<UICollectionViewDelegate, UICollectionViewDataSource, CommunityWaterfallLayoutProtocol>

@property(nonatomic, strong) ArticleListModel *model;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CommunityWaterfallLayout *waterfallLayout;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CommunityChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    
    [self.view addSubview:self.collectionView];
    
    @weakify(self);
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.curPage = 0;
        [self request];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.curPage += 1;
        [self request];
    }];
    
    self.curPage = 0;
    [self request];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

- (void)request {
    [MBProgressHUD showHudMsg:kLocalizedString(@"Loading")];
    NSDictionary *param = @{
        @"articleCatgId": self.articleCatgId,
        @"pageIndex": @(self.curPage).stringValue,
        @"pageSize": @"10"
    };
    [SFNetworkManager get: SFNet.article.articles parameters: param success:^(id  _Nullable response) {
        [MBProgressHUD hideFromKeyWindow];
        if (self.curPage == 0) {
            [self.dataArray removeAllObjects];
        }
        NSError *error;
        ArticleListModel *model = [[ArticleListModel alloc] initWithDictionary: response error: &error];
        [self.dataArray addObjectsFromArray:model.list];
                
        self.model = [[ArticleListModel alloc] initWithDictionary: response error: &error];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        if (model.list.count != 10) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.collectionView.mj_footer endRefreshing];
        }
        NSLog(@"get articles success");
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [MBProgressHUD showTopErrotMessage:[NSMutableString getErrorMessage:error][@"error"]];
        NSLog(@"get articles failed");
    }];
}

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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleModel *cellModel = self.dataArray[indexPath.row];
    CommunityDetailController *detailVC = [[CommunityDetailController alloc] init];
    detailVC.articleId = [NSString stringWithFormat:@"%ld", cellModel.communityArticleId];
    [self.navigationController pushViewController:detailVC animated: YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"community.article.list.cell" forIndexPath:indexPath];
    if(!cell){
        cell = [[ArticleListCell alloc] init];
    }
    ArticleModel *cellModel = self.dataArray[indexPath.row];
    cell.model = cellModel;
    return cell;
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleModel *cellModel = self.dataArray[indexPath.row];
    NSString *labelString = cellModel.contentTitle;
    CGFloat cellWidth = (MainScreen_width - 18 * 2) / 2;
    CGFloat labelWidth = cellWidth - 8 * 2;
    CGFloat labelHeight = 25;//[labelString jk_heightWithFont: kFontRegular(14) constrainedToWidth: labelWidth];
    CGFloat cellHeight = cellWidth + 8 + 20 + 24 + 8 + labelHeight;
    return cellHeight;
}

/**
 数据初始化
 */
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
