//
//  SimilarProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/27.
//

#import "SimilarProductCell.h"
#import "NSString+Fee.h"


@interface SimilarProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *macketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImgView;

@end

@implementation SimilarProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    self.contentView.layer.borderWidth = 1;
}
- (void)setContent:(ProductSimilarModel *)model
{
    _typeLabel.text = model.offerType;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.productImg.url)]];
    _nameLabel.text = model.offerName;
    _priceLabel.text = [[NSString stringWithFormat:@"%@",model.productImg.salesPrice] currency];
    _macketPriceLabel.text = [[NSString stringWithFormat:@"%@",model.productImg.marketPrice] currency];
    _offLabel.text = [NSString stringWithFormat:@"%ld%%",model.discountPercent];
    NSString *score = (model.evaluationAvg == 0 || !model.evaluationAvg) ? @"": [NSString stringWithFormat:@"%.1f",model.evaluationAvg];
    NSString *evaCount = ([model.evaluationCnt isEqualToString:@"0"] || !model.evaluationCnt) ? @"": [NSString stringWithFormat:@"(%@)",model.evaluationCnt];
    self.starImgView.hidden = (model.evaluationAvg == 0 || !model.evaluationAvg);
    _scoreLabel.text = [NSString stringWithFormat:@"%@  %@",score,evaCount];
    
}
@end
