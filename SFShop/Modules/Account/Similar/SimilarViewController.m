//
//  SimilarViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/27.
//

#import "SimilarViewController.h"
#import "ProductSimilarModel.h"
#import "CommunityWaterfallLayout.h"
#import "SimilarProductCell.h"
#import "ProductViewController.h"
#import "NSString+Fee.h"
#import "CategoryRankCell.h"

@interface SimilarViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CommunityWaterfallLayoutProtocol>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) CommunityWaterfallLayout *waterfallLayout;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong) UILabel *label;
@end

@implementation SimilarViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Similar_products");
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SimilarProductCell" bundle:nil] forCellWithReuseIdentifier:@"SimilarProductCell"];
    [self.collectionView registerClass:[CategoryRankCell class] forCellWithReuseIdentifier:@"CategoryRankCell"];
    
    [self.view addSubview:self.collectionView];
    [self loadDatas];
    [self initUI];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    _collectionView.frame = CGRectMake(0, _topView.jk_bottom+20, MainScreen_width, self.view.jk_height-154);
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(35);
    }];
}
- (void)initUI
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(_model.imgUrl)]];
    _nameLabel.text = _model.offerName;
    _priceLabel.text = [_model.salesPrice currency];
    _label = [[UILabel alloc] init];
    _label.font = CHINESE_BOLD(15);
    _label.backgroundColor = [UIColor whiteColor];
    _label.hidden = YES;
    _label.text = [NSString stringWithFormat:@"   %@",kLocalizedString(@"SIMILAR_PRODUCT_RECOMMENDATION")];
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(10);
        make.height.mas_equalTo(25);
    }];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.favorite.similar parameters:@{@"offerId": self.offerId} success:^(id  _Nullable response) {
        weakself.dataSource = [ProductSimilarModel arrayOfModelsFromDictionaries: response[@"pageInfo"][@"list"] error:nil];
        weakself.label.hidden = weakself.dataSource.count == 0;
        [weakself.collectionView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - btn.action

- (IBAction)buyAction:(UIButton *)sender {
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = [self.model.offerId integerValue];
    vc.productId = self.model.productId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
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
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductSimilarModel *model = self.dataSource[indexPath.row];
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = model.offerId;
    vc.productId = model.productId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    SimilarProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"SimilarProductCell" forIndexPath:indexPath];
//    [cell setContent:self.dataSource[indexPath.row]];
    
    CategoryRankCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryRankCell" forIndexPath:indexPath];
    cell.similarModel = self.dataSource[indexPath.row];
    cell.showType = 0;
    
    return cell;
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
//    ProductSimilarModel *cellModel = [self.dataSource[indexPath.row] copy];
////    NSString *labelString = cellModel.contentTitle;
////    CGFloat cellWidth = (MainScreen_width - 18 * 2) / 2;
////    CGFloat labelWidth = cellWidth - 8 * 2;
////    CGFloat labelHeight = [labelString jk_heightWithFont: [UIFont systemFontOfSize:14] constrainedToWidth: labelWidth];
////    CGFloat cellHeight = cellWidth + 8 + 20 + 24 + 8 + labelHeight;
//    NSString *score = (cellModel.evaluationAvg == 0 || !cellModel.evaluationAvg) ? @"": [NSString stringWithFormat:@"%.1f",cellModel.evaluationAvg];
//    return [cellModel.offerType isEqualToString:@"P"] ? [score isEqualToString:@""] ? 300: 305: [score isEqualToString:@""] ? 275:305;

    ProductSimilarModel *cellModel = self.dataSource[indexPath.row];
    if (!cellModel.height) {
        
//        CGFloat titleHeight = [cellModel.offerName calHeightWithFont:[UIFont boldSystemFontOfSize:14] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft limitSize:CGSizeMake((MainScreen_width - KScale(12) * 3 - KScale(16) * 2)/2, 100)];
        
        CGFloat titleHeight = [NSString jk_heightTextContent:cellModel.offerName withSizeFont:14 withMaxSize:CGSizeMake((MainScreen_width - KScale(12) * 3 - KScale(16) * 2)/2, CGFLOAT_MAX)];
                        
        CGFloat imageHeight = KScale(166);
        CGFloat tagHeight = 0;
        if (cellModel.sppType.length> 0) {
            tagHeight = KScale(14) + KScale(16);
        }
        
        CGFloat gradeHeught = 0;
        if (cellModel.evaluationAvg > 0 || cellModel.evaluationCnt > 0) {
            gradeHeught = KScale(12) + KScale(12);
        }
        CGFloat priceHeight = KScale(14);
        CGFloat discountHeight = KScale(14);
        cellModel.height = imageHeight + tagHeight + KScale(12) + titleHeight + KScale(6) + priceHeight + KScale(4) + discountHeight + KScale(12) + gradeHeught;
    }
    return cellModel.height;

}

@end
