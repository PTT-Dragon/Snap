//
//  RelationOrderDetailProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/5.
//

#import "RelationOrderDetailProductCell.h"

@interface RelationOrderDetailProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation RelationOrderDetailProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
}
- (void)setModel:(orderItemsModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imagUrl)]];
    _nameLabel.text = model.productName;
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",model.unitPrice];
    _countLabel.text = [NSString stringWithFormat:@"X %@",model.offerCnt];
    NSDictionary *dic = [model.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
}
@end
