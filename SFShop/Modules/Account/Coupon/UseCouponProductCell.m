//
//  UseCouponProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/29.
//

#import "UseCouponProductCell.h"
#import "NSString+Fee.h"


@interface UseCouponProductCell ()
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *spCartBtn;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic,strong) CategoryRankPageInfoListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *starImgView;

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
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.productImg.url)]];
    _nameLabel.text = model.offerName;
    _priceLabel.text = [[NSString stringWithFormat:@"%ld",model.salesPrice] currency];
    _marketLabel.text = [[NSString stringWithFormat:@"%ld",model.marketPrice] currency];
    NSString *score = (model.evaluationAvg == 0 || !model.evaluationAvg) ? @"":[NSString stringWithFormat:@"%.1f",model.evaluationAvg];
    NSString *count = (model.evaluationCnt == 0 || !model.evaluationCnt) ? @"":[NSString stringWithFormat:@"(%ld)",model.evaluationCnt];
    self.starImgView.hidden = [score isEqualToString:@""];
    _scoreLabel.text = [NSString stringWithFormat:@"%@ %@",score,count];
    _offLabel.text = [NSString stringWithFormat:@" -%@ ",model.discountPercent];
}
- (IBAction)spCartAction:(UIButton *)sender {
    if (self.block) {
        self.block(_model);
    }
}

@end
