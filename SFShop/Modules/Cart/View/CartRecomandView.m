//
//  ProductionRecomandView.m
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import "CartRecomandView.h"
#import "CategoryRankCell.h"
#import "ProductViewController.h"
#import "UIView+Response.h"
#import "CommunityWaterfallLayout.h"

@interface CartRecomandView () <UICollectionViewDelegate, UICollectionViewDataSource,CommunityWaterfallLayoutProtocol>

@property (strong, nonatomic) UICollectionView *recommendCollectionView;
@property (nonatomic, readwrite, strong) CommunityWaterfallLayout *waterfallLayout;
@property(nonatomic, strong) NSMutableArray *similarList;

@end

@implementation CartRecomandView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self initView];
    [self initLayout];
}

#pragma mark - init

- (void)initView {
    [self addSubview:self.recommendCollectionView];
}

- (void)initLayout {
    [self.recommendCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)configDataWithSimilarList:(NSMutableArray<ProductSimilarModel *> *)similarList {
    self.similarList = similarList;
    [self.recommendCollectionView reloadData];
}


#pragma mark - UICollectionView delegate & dataSource

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:kSupplementaryViewKindHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kSupplementaryViewKindHeader withReuseIdentifier:@"ProductionRecommendHeader" forIndexPath:indexPath];
        view.backgroundColor = [UIColor jk_colorWithHexString:@"#ffffff"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, App_Frame_Width-32, 44)];
        [view addSubview:backView];
        backView.backgroundColor = [UIColor jk_colorWithHexString:@"#ffffff"];
        
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(20, 7, 150, 30)];
        title.text = kLocalizedString(@"Recommendations");
        title.font = [UIFont boldSystemFontOfSize:17];
        title.textColor = [UIColor blackColor];
        [view addSubview: title];
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.similarList.count == 0 ? CGSizeZero :CGSizeMake(MainScreen_width, 44);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.similarList.count == 0 ? 0 : self.similarList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankCell" forIndexPath:indexPath];
    CategoryRankPageInfoListModel *cellModel = self.similarList[indexPath.row];
    cell.model = cellModel;
    cell.showType = 0;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankPageInfoListModel *cellModel = self.similarList[indexPath.row];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = cellModel.offerId;
    vc.productId = cellModel.productId.integerValue;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankPageInfoListModel *cellModel = self.similarList[indexPath.row];
    return cellModel.height;
}

- (UICollectionView *)recommendCollectionView {
    if(!_recommendCollectionView){
        _waterfallLayout = [[CommunityWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = KScale(12);
        _waterfallLayout.insets = UIEdgeInsetsMake(KScale(12), KScale(16), KScale(12), KScale(16));
        
        _recommendCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 10 + navBarHei + KScale(64), MainScreen_width, MainScreen_height - 10 - navBarHei - KScale(64)) collectionViewLayout:_waterfallLayout];
        _recommendCollectionView.scrollEnabled = NO;
        _recommendCollectionView.delegate = self;
        _recommendCollectionView.dataSource = self;
        _recommendCollectionView.showsVerticalScrollIndicator = false;
        _recommendCollectionView.backgroundColor = [UIColor clearColor];
        
        [_recommendCollectionView registerClass:CategoryRankCell.class forCellWithReuseIdentifier:@"CategoryRankCell"];
        [_recommendCollectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:kSupplementaryViewKindHeader withReuseIdentifier:@"ProductionRecommendHeader"];
    }
    return _recommendCollectionView;
}

@end
