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

@interface SimilarViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, CommunityWaterfallLayoutProtocol>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) CommunityWaterfallLayout *waterfallLayout;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
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
    [self.view addSubview:self.collectionView];
    [self loadDatas];
    [self initUI];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = CGRectMake(0, _topView.jk_bottom+20, MainScreen_width, self.view.jk_height-154);
}
- (void)initUI
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(_model.imgUrl)]];
    _nameLabel.text = _model.offerName;
    _priceLabel.text = [NSString stringWithFormat:@"RP%@",_model.salesPrice];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.favorite.similar parameters:@{@"offerId": self.offerId} success:^(id  _Nullable response) {
        weakself.dataSource = [ProductSimilarModel arrayOfModelsFromDictionaries: response[@"pageInfo"][@"list"] error:nil];
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
    SimilarProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"SimilarProductCell" forIndexPath:indexPath];
    [cell setContent:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark - CollectionWaterfallLayoutProtocol
- (CGFloat)collectionViewLayout:(CommunityWaterfallLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductSimilarModel *cellModel = [self.dataSource[indexPath.row] copy];
//    NSString *labelString = cellModel.contentTitle;
//    CGFloat cellWidth = (MainScreen_width - 18 * 2) / 2;
//    CGFloat labelWidth = cellWidth - 8 * 2;
//    CGFloat labelHeight = [labelString jk_heightWithFont: [UIFont systemFontOfSize:14] constrainedToWidth: labelWidth];
//    CGFloat cellHeight = cellWidth + 8 + 20 + 24 + 8 + labelHeight;
    return [cellModel.offerType isEqualToString:@"P"] ? 330: 305;
}

@end
