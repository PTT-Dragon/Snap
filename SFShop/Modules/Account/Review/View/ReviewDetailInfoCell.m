//
//  ReviewDetailInfoCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/5.
//

#import "ReviewDetailInfoCell.h"
#import "ProductDetailModel.h"
#import "ImageCollectionViewCell.h"
#import "NSDate+Helper.h"

@interface ReviewDetailInfoCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHei;

@end

@implementation ReviewDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
}
- (void)setModel:(ReviewDetailModel *)model
{
    EvaluatesModel *evaModel = model.evaluates.firstObject;
    _model = model;
    [_productImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(evaModel.product.imgUrl)]];
    _productNameLabel.text = evaModel.product.productName;
    NSDictionary *dic = [evaModel.product.productRemark jk_dictionaryValue];
    NSString *sku = @"";
    for (NSString *key in dic.allKeys) {
        sku = [sku stringByAppendingFormat:@"%@ ",dic[key]];
    }
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",sku];
    _userNameLabel.text = evaModel.user.nickName;
    [_userAvatarImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(evaModel.user.photo)]];
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f",[evaModel.rate floatValue]];;
//    _timeLabel.text = model.evaluateDate;
    _timeLabel.text = [[NSDate dateFromString:model.evaluateDate] dayMonthYearHHMM];
    _contentLabel.text = evaModel.evaluationComments;
    _collectionViewHei.constant = (MainScreen_width-32-24)/4;
    [_collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    EvaluatesModel *evaModel = _model.evaluates.firstObject;
    return evaModel.contents.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EvaluatesModel *evaModel = _model.evaluates.firstObject;
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage([evaModel.contents[indexPath.row] url])]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((MainScreen_width-32-30)/4 , (MainScreen_width-32-30)/4);
}
@end
