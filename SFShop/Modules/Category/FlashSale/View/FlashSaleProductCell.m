//
//  FlashSaleProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "FlashSaleProductCell.h"

@interface FlashSaleProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *OriginalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processWidth;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation FlashSaleProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
}
- (void)setModel:(FlashSaleProductModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.productImg)]];
    _nameLabel.text = model.productName;
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",model.specialPrice];
    _OriginalPriceLabel.text = [NSString stringWithFormat:@"%@",model.salesPrice];
    _offLabel.text = [NSString stringWithFormat:@" %@%% ",model.discountPercent];
    _rateLabel.text = [NSString stringWithFormat:@"%@ (%ld)",model.evaluationAvg,model.evaluationCnt];
    _processLabel.text = [NSString stringWithFormat:@"%ld Terjual",model.productCmpSaleNum];
    _processWidth.constant = (MainScreen_width-224)*model.productCmpSaleNum/model.stockNum;
}
@end
