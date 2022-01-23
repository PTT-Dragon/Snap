//
//  SimilarProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/27.
//

#import "SimilarProductCell.h"


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
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.offerName;
    _priceLabel.text = [NSString stringWithFormat:@"RP%ld",model.salesPrice];
    _macketPriceLabel.text = [NSString stringWithFormat:@"%ld",model.marketPrice];
    _offLabel.text = [NSString stringWithFormat:@"%ld%%",model.discountPercent];
    NSString *score = ([model.evaluationRate isEqualToString:@"0"] || !model.evaluationRate) ? @"": model.evaluationRate;
    NSString *evaCount = ([model.evaluationCnt isEqualToString:@"0"] || !model.evaluationCnt) ? @"": model.evaluationRate;
    self.starImgView.hidden = ([model.evaluationRate isEqualToString:@"0"] || !model.evaluationRate);
    _scoreLabel.text = [NSString stringWithFormat:@"%@  %@",score,evaCount];
}
@end
