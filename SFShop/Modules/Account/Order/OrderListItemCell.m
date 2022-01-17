//
//  OrderListItemCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import "OrderListItemCell.h"
#import "NSString+Fee.h"

@interface OrderListItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *afterSaleBtn;

@end

@implementation OrderListItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
}
- (void)setContent:(orderItemsModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imagUrl)]];
    _nameLabel.text = model.productName;
    NSDictionary *dic = [model.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _countLabel.text = [NSString stringWithFormat:@"X%@",model.offerCnt];
    _priceLabel.text = [NSString stringWithFormat:@"%@",[model.unitPrice currency]];
}
- (void)setOrderContent:(orderItemsModel *)model state:(NSString *)state
{
    _afterSaleBtn.hidden = ![state isEqualToString:@"D"];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imagUrl)]];
    _nameLabel.text = model.productName;
    NSDictionary *dic = [model.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _countLabel.text = [NSString stringWithFormat:@"X%@",model.offerCnt];
    _priceLabel.text = [NSString stringWithFormat:@"%@",[model.unitPrice currency]];
}
- (void)setRefundContent:(RefundDetailItemsModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imagUrl)]];
    _nameLabel.text = model.productName;
    NSDictionary *dic = [model.productRemark jk_dictionaryValue];
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
    _countLabel.text = [NSString stringWithFormat:@"X%@",model.submitNum];
    _priceLabel.text = [NSString stringWithFormat:@"%@",[model.unitPrice currency]];
}
- (IBAction)blockAction:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}
@end
