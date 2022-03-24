//
//  FlashSaleProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "FlashSaleProductCell.h"
#import "SysParamsModel.h"
#import "NSString+Fee.h"

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
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation FlashSaleProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.borderWidth = 1;
    _bgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _tagLabel.text = [NSString stringWithFormat:@" %@ ",kLocalizedString(@"FLASH")];
}
- (void)setModel:(FlashSaleProductModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.offerName;
//    NSString *currency = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_DISPLAY;
    _priceLabel.text = [model.specialPrice currency];
    _OriginalPriceLabel.text = [model.marketPrice currency];
    _offLabel.text = model.discountPercent ? [NSString stringWithFormat:@" %@%% ",model.discountPercent] : @"";
    _rateLabel.text = [NSString stringWithFormat:@"%.2f (%f)",model.evaluationAvg.floatValue,model.evaluationCnt];
    _processLabel.text = [NSString stringWithFormat:@"%.2f%% %@",model.salePercent/100, kLocalizedString(@"Terjual")];
    _processWidth.constant = (MainScreen_width-224)*model.salePercent/10000;
}
@end
