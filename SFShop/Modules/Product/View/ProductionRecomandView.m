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

@interface ProductionRecomandView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *recommendCollectionView;

@property(nonatomic, strong) NSMutableArray<ProductSimilarModel *> *similarList;

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
    ProductionRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductionRecommendCell" forIndexPath:indexPath];
    cell.model = self.similarList[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = self.similarList[indexPath.row].offerId;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}


- (UICollectionView *)recommendCollectionView {
    if (!_recommendCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeZero;
        layout.footerReferenceSize = CGSizeZero;
        layout.minimumLineSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.sectionInset = UIEdgeInsetsMake(8, 20, 8, 20);
        layout.itemSize = CGSizeMake((MainScreen_width - 60) / 2, (MainScreen_width - 60) / 2 + 120);
        _recommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _recommendCollectionView.backgroundColor = [UIColor whiteColor];
        _recommendCollectionView.delegate = self;
        _recommendCollectionView.dataSource = self;
        [_recommendCollectionView registerClass:[ProductionRecommendCell class] forCellWithReuseIdentifier:@"ProductionRecommendCell"];
        [_recommendCollectionView registerClass:[ProductionRecommendCell class] forCellWithReuseIdentifier:@"ProductionRecommendCell"];
        [_recommendCollectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ProductionRecommendHeader"];
    }
    return _recommendCollectionView;
}

@end
