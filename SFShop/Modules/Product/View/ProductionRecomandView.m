//
//  ProductionRecomandView.m
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import "ProductionRecomandView.h"
#import "CategoryRankCell.h"
#import "ProductViewController.h"
#import "UIView+Response.h"
#import "CommunityWaterfallLayout.h"

@interface ProductionRecomandView () <UICollectionViewDelegate, UICollectionViewDataSource,CommunityWaterfallLayoutProtocol>

@property (strong, nonatomic) UICollectionView *recommendCollectionView;
@property (nonatomic, readwrite, strong) CommunityWaterfallLayout *waterfallLayout;
@property(nonatomic, strong) NSMutableArray *similarList;

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
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductionRecommendHeader" forIndexPath:indexPath];
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(20, 5, 150, 30)];
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


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.similarList.count == 0 ? 0 : self.similarList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankCell" forIndexPath:indexPath];
    CategoryRankPageInfoListModel *cellModel = self.similarList[indexPath.row];
    cell.model = cellModel;
    cell.showType = 1;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductViewController *vc = [[ProductViewController alloc] init];
//    vc.offerId = self.similarList[indexPath.row].offerId;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}
#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (!self.showType) {
        CategoryRankPageInfoListModel *cellModel = self.similarList[indexPath.row];
        if (!cellModel.height) {
            CGFloat titleHeight = [cellModel.offerName calHeightWithFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake(MainScreen_width - KScale(12) * 3 - KScale(16) * 2, 100)];
            CGFloat imageHeight = KScale(166);
            CGFloat tagHeight = KScale(14);
            CGFloat priceHeight = KScale(14);
            CGFloat discountHeight = KScale(14);
            CGFloat levelHeight = KScale(12);
            //        + KScale(16) + tagHeight
            cellModel.height = imageHeight  + KScale(12) + titleHeight + KScale(16) + priceHeight + KScale(4) + discountHeight + KScale(12) + levelHeight + KScale(25);
        }
        return cellModel.height;
//    } else {
//        return 160;
//    }
}

- (UICollectionView *)recommendCollectionView {
//    if (!_recommendCollectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.headerReferenceSize = CGSizeZero;
//        layout.footerReferenceSize = CGSizeZero;
//        layout.minimumLineSpacing = 16;
//        layout.minimumInteritemSpacing = 16;
//        layout.sectionInset = UIEdgeInsetsMake(8, 20, 8, 20);
//        layout.itemSize = CGSizeMake((MainScreen_width - 60) / 2, (MainScreen_width - 60) / 2 + 120);
//        _recommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//        _recommendCollectionView.backgroundColor = [UIColor whiteColor];
//        _recommendCollectionView.delegate = self;
//        _recommendCollectionView.dataSource = self;
//        [_recommendCollectionView registerClass:[CategoryRankCell class] forCellWithReuseIdentifier:@"ProductionRecommendCell"];
//    }
//    return _recommendCollectionView;
    if(!_recommendCollectionView){
        _waterfallLayout = [[CommunityWaterfallLayout alloc] init];
        _waterfallLayout.delegate = self;
        _waterfallLayout.columns = 2;
        _waterfallLayout.columnSpacing = KScale(12);
        _waterfallLayout.insets = UIEdgeInsetsMake(KScale(12), KScale(16), KScale(12), KScale(16));
        
        _recommendCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 10 + navBarHei + KScale(64), MainScreen_width, MainScreen_height - 10 - navBarHei - KScale(64)) collectionViewLayout:_waterfallLayout];
        _recommendCollectionView.delegate = self;
        _recommendCollectionView.dataSource = self;
        _recommendCollectionView.showsVerticalScrollIndicator = false;
        _recommendCollectionView.backgroundColor = [UIColor clearColor];

        [_recommendCollectionView registerClass:CategoryRankCell.class forCellWithReuseIdentifier:@"CategoryRankCell"];
        [_recommendCollectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductionRecommendHeader"];
    }
    return _recommendCollectionView;
}

@end
