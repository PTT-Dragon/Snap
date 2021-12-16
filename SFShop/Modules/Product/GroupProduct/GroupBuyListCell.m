//
//  GroupBuyListCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/16.
//

#import "GroupBuyListCell.h"

@interface GroupBuyListCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;

@end

@implementation GroupBuyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _bgView.layer.borderWidth = 1;
}
- (void)setModel:(CategoryRankPageInfoListModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.offerName;
    _priceLabel.text = [NSString stringWithFormat:@"Rp %@", model.specialPrice];
    _marketPriceLabel.text = [NSString stringWithFormat:@"Rp %ld", (long)model.salesPrice];
    _groupCountLabel.text = [NSString stringWithFormat:@"%ld",model.evaluationCnt];
    _soldLabel.text = [NSString stringWithFormat:@"%ld Sold",(long)model.salesCnt];
}
@end
