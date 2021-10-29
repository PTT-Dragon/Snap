//
//  UseCouponProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/29.
//

#import "UseCouponProductCell.h"

@interface UseCouponProductCell ()
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *spCartBtn;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation UseCouponProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    self.subView.layer.borderWidth = 1;
    self.spCartBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    self.spCartBtn.layer.borderWidth = 1;
}
- (void)setContent:(CategoryRankPageInfoListModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.offerName;
    _priceLabel.text = [NSString stringWithFormat:@"RP %ld",model.salesPrice];
    _marketLabel.text = [NSString stringWithFormat:@"%ld",model.marketPrice];
    _scoreLabel.text = [NSString stringWithFormat:@"%@ (%ld)",model.evaluationRate,model.evaluationCnt];
    _offLabel.text = [NSString stringWithFormat:@" %@ ",model.discountPercent];
}
- (IBAction)spCartAction:(UIButton *)sender {
}

@end
