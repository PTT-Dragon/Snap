//
//  savePosterView.m
//  SFShop
//
//  Created by 游挺 on 2022/3/25.
//

#import "savePosterView.h"
#import "NSString+Fee.h"

@interface savePosterView ()
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@end

@implementation savePosterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _longLabel.text = kLocalizedString(@"LONG_PRESS_TO_BUY");
}
- (void)setModel:(PosterPosterModel *)model
{
    [_productImgView sd_setImageWithURL:[NSURL URLWithString:SFImage([model.contents.firstObject url])]];
    _qrCodeImgView.image = model.qrCodeImage;
}
- (void)setProductModel:(DistributorRankProductModel *)productModel
{
    _productModel = productModel;
    _priceLabel.text = [productModel.salesPrice currency];
    _marketPriceLabel.text = [productModel.marketPrice currency];
    NSInteger precision = SysParamsItemModel.sharedSysParamsItemModel.CURRENCY_PRECISION.intValue;
    NSString *precisionStr = [NSString stringWithFormat:@"%%.%ldf", precision];//精度
    NSString *thousandthStr = [NSString stringWithFormat:precisionStr,[productModel.commissionRate currencyFloat]];
    _offLabel.text = [NSString stringWithFormat:@" %@%% ",thousandthStr];
    _contentLabel.text = productModel.offerName;
}
@end
