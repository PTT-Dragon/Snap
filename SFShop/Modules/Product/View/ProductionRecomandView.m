//
//  ProductionRecomandView.m
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import "ProductionRecomandView.h"
#import "ProductionRecommendCell.h"
#import "ProductViewController.h"
#import "UIView+Response.h"
#import "CategoryRankCell.h"
#import "CommunityWaterfallLayout.h"

@interface ProductionRecomandView () <UICollectionViewDelegate, UICollectionViewDataSource,CommunityWaterfallLayoutProtocol>

@property (strong, nonatomic) UICollectionView *recommendCollectionView;
@property (strong, nonatomic) UILabel *titleLab;

@property(nonatomic, strong) NSMutableArray<ProductSimilarModel *> *similarList;
@property (nonatomic, readwrite, strong) CommunityWaterfallLayout *waterfallLayout;

@end

@implementation ProductionRecomandView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, 150, 44)];
    title.text = kLocalizedString(@"Recommendations");
    title.font = [UIFont boldSystemFontOfSize:17];
    title.textColor = [UIColor blackColor];
    [self addSubview: title];
    self.titleLab = title;
    
    self.recommendCollectionView.scrollEnabled = NO;
    [self addSubview:self.recommendCollectionView];
}

- (void)initLayout {
    
    [self.recommendCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.offset(44);
    }];
}

- (void)configDataWithSimilarList:(NSMutableArray<ProductSimilarModel *> *)similarList {
    self.similarList = similarList;
    self.titleLab.height = similarList.count==0 ? CGFLOAT_MIN:44;
    [self.recommendCollectionView reloadData];
}


#pragma mark - UICollectionView delegate & dataSource

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductionRecommendHeader" forIndexPath:indexPath];
//        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(20, 5, 150, 30)];
//        title.text = kLocalizedString(@"Recommendations");
//        title.font = [UIFont boldSystemFontOfSize:17];
//        title.textColor = [UIColor blackColor];
//        [view addSubview: title];
//        return view;
//    }
//    return nil;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(MainScreen_width, 44);
//    return self.similarList.count == 0 ? CGSizeZero :CGSizeMake(MainScreen_width, 44);
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.similarList.count == 0 ? 0 : self.similarList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//<<<<<<< HEAD
    CategoryRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankCell" forIndexPath:indexPath];
//    CategoryRankPageInfoListModel *cellModel = self.similarList[indexPath.row];
    cell.similarModel = self.similarList[indexPath.row];
    cell.showType = 0;
//=======
//    ProductionRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductionRecommendCell" forIndexPath:indexPath];
//    cell.model = self.similarList[indexPath.row];
//>>>>>>> 4d144dfc40f7593807ac273d9cc974cd537821c0
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    CategoryRankPageInfoListModel *cellModel = self.similarList[indexPath.row];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = self.similarList[indexPath.row].offerId;
    vc.productId = self.similarList[indexPath.row].productId;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductSimilarModel *cellModel = self.similarList[indexPath.row];
    return cellModel.height;
}

- (UICollectionView *)recommendCollectionView {
    if (!_recommendCollectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.headerReferenceSize = CGSizeZero;
//        layout.footerReferenceSize = CGSizeZero;
//        layout.minimumLineSpacing = 16;
//        layout.minimumInteritemSpacing = 16;
//        layout.sectionInset = UIEdgeInsetsMake(8, 20, 8, 20);
//        layout.itemSize = CGSizeMake((MainScreen_width - 60) / 2, (MainScreen_width - 60) / 2 + 120);
        
        _waterfallLayout = [[CommunityWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = KScale(12);
        _waterfallLayout.insets = UIEdgeInsetsMake(KScale(0), KScale(16), KScale(12), KScale(16));
        
        _recommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_waterfallLayout];
        _recommendCollectionView.backgroundColor = [UIColor whiteColor];
        _recommendCollectionView.delegate = self;
        _recommendCollectionView.dataSource = self;
        _recommendCollectionView.showsVerticalScrollIndicator = NO;
        [_recommendCollectionView registerClass:[ProductionRecommendCell class] forCellWithReuseIdentifier:@"ProductionRecommendCell"];
        [_recommendCollectionView registerClass:[ProductionRecommendCell class] forCellWithReuseIdentifier:@"ProductionRecommendCell"];
        [_recommendCollectionView registerClass:[CategoryRankCell class] forCellWithReuseIdentifier:@"CategoryRankCell"];

        [_recommendCollectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductionRecommendHeader"];
        
    }
    return _recommendCollectionView;
}

@end
