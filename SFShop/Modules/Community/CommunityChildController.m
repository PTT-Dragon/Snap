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

@interface CommunityChildController ()<UICollectionViewDelegate, UICollectionViewDataSource, CommunityWaterfallLayoutProtocol>

@property(nonatomic, strong) ArticleListModel *model;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CommunityWaterfallLayout *waterfallLayout;

@end

@implementation CommunityChildController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    
    [self.view addSubview:self.collectionView];
    [self request];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

- (void)request {
    NSDictionary *param = @{
        @"articleCatgId": self.articleCatgId,
        @"pageIndex": @"0",
        @"pageSize": @"10"
    };
    [SFNetworkManager get: SFNet.article.articles parameters: param success:^(id  _Nullable response) {
        NSError *error;
        self.model = [[ArticleListModel alloc] initWithDictionary: response error: &error];
        [self.collectionView reloadData];
        NSLog(@"get articles success");
    } failed:^(NSError * _Nonnull error) {
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
    ArticleModel *cellModel = self.model.list[indexPath.row];
    CommunityDetailController *detailVC = [[CommunityDetailController alloc] init];
    detailVC.articleId = [NSString stringWithFormat:@"%ld", cellModel.communityArticleId];
    [self.navigationController pushViewController:detailVC animated: YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.list.count ? self.model.list.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"community.article.list.cell" forIndexPath:indexPath];
    if(!cell){
        cell = [[ArticleListCell alloc] init];
    }
    ArticleModel *cellModel = [self.model.list[indexPath.row] copy];
    if (indexPath.row % 2 == 0) {
        cellModel.contentTitle = [NSString stringWithFormat:@"%@%@", cellModel.contentTitle, @"-增加一些内容使变成多行"];
    }
    cell.model = cellModel;
    return cell;
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    ArticleModel *cellModel = [self.model.list[indexPath.row] copy];
    if (indexPath.row % 2 == 0) {
        cellModel.contentTitle = [NSString stringWithFormat:@"%@%@", cellModel.contentTitle, @"-增加一些内容使变成多行"];
    }
    NSString *labelString = cellModel.contentTitle;
    CGFloat cellWidth = (MainScreen_width - 18 * 2) / 2;
    CGFloat labelWidth = cellWidth - 8 * 2;
    CGFloat labelHeight = [labelString jk_heightWithFont: [UIFont systemFontOfSize:14] constrainedToWidth: labelWidth];
    CGFloat cellHeight = cellWidth + 8 + 20 + 24 + 8 + labelHeight;
    return cellHeight;
}

@end
