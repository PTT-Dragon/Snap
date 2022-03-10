//
//  RelationOrderCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/12.
//

#import "RelationOrderCell.h"
#import "ImageCollectionViewCell.h"
#import "NSDate+Helper.h"
#import "NSString+Fee.h"

@interface RelationOrderCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *storeIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *spLabel;

@end

@implementation RelationOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    _spLabel.layer.borderWidth = 2;
}
- (void)setModel:(RelationOrderListModel *)model
{
    _model = model;
    _spLabel.text = [model.settState isEqualToString:@"Settled"] ? @"S": @"P";
    _spLabel.layer.borderColor = [model.settState isEqualToString:@"Settled"] ? RGBColorFrom16(0xff1659).CGColor: RGBColorFrom16(0xff1659).CGColor;
    [_storeIconImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogoUrl)] placeholderImage:[UIImage imageNamed:@"toko"]];
    _storeNameLabel.text = model.storeName;
    _nameLabel.text = model.distributorName;
    _timeLabel.text = [[NSDate dateFromString:model.orderDate] dayMonthYearHHMM];
    _amountLabel.text = [model.orderPrice currency];
    _totalLabel.text = [model.kolCommission currency];
    _stateLabel.text = [model getStateStr];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.orderItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RelationOrderItemModel *itemModel = self.model.orderItems[indexPath.row];
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(itemModel.imagUrl)]];
    return cell;
}
- (IBAction)moreProductAction:(UIButton *)sender {
    
}

@end
