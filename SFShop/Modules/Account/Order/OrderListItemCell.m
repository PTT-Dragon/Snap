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
@property (weak, nonatomic) IBOutlet UILabel *inAfterSaleLabel;

@end

@implementation OrderListItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
    [_afterSaleBtn setTitle:[NSString stringWithFormat:@"  %@  ",kLocalizedString(@"REFUND_RETURN")] forState:0];
    _inAfterSaleLabel.text = [NSString stringWithFormat:@" %@ ",kLocalizedString(@"inAfterSale")];
}
- (void)setContent:(orderItemsModel *)model isInAfterSale:(BOOL)isInAfterSale
{
    _inAfterSaleLabel.hidden = !isInAfterSale;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imagUrl)]];
    _nameLabel.text = model.productName;
    NSDictionary *dic = [model.productRemark jk_dictionaryValue];
    NSString *sku = @"";
    for (NSString *key in dic.allKeys) {
        sku = [sku stringByAppendingFormat:@"%@",dic[key]];
    }
    _skuLabel.text = [NSString stringWithFormat:@"   %@   ",sku];
    _countLabel.text = [NSString stringWithFormat:@"X%@",model.offerCnt];
    _priceLabel.text = [NSString stringWithFormat:@"%@",[model.unitPrice currency]];
}
- (void)setOrderContent:(orderItemsModel *)model state:(NSString *)state showIsAfterSale:(BOOL)isAfterSale
{
    _inAfterSaleLabel.hidden = !isAfterSale;
    _afterSaleBtn.hidden = (![state isEqualToString:@"D"] || [model.canReturn isEqualToString:@"N"]);
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imagUrl)]];
    _nameLabel.text = model.productName;
    NSDictionary *dic = [model.productRemark jk_dictionaryValue];
    NSString *sku = @"";
    for (NSString *key in dic.allKeys) {
        sku = [sku stringByAppendingFormat:@"%@",dic[key]];
    }
    _skuLabel.text = [NSString stringWithFormat:@"   %@   ",sku];
    _countLabel.text = [NSString stringWithFormat:@"X%@",model.offerCnt];
    _priceLabel.text = [NSString stringWithFormat:@"%@",[model.unitPrice currency]];
}
- (void)setRefundContent:(RefundDetailItemsModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imagUrl)]];
    _nameLabel.text = model.productName;
    NSDictionary *dic = [model.productRemark jk_dictionaryValue];
    NSString *sku = @"";
    for (NSString *key in dic.allKeys) {
        sku = [sku stringByAppendingFormat:@"%@",dic[key]];
    }
    _priceLabel.textColor = [UIColor blackColor];
    _skuLabel.text = [NSString stringWithFormat:@"   %@   ",sku];
    _countLabel.text = [NSString stringWithFormat:@"X%@",model.submitNum];
    _priceLabel.text = [NSString stringWithFormat:@"%@",[model.unitPrice currency]];
}
- (void)setRefund2Content:(orderItemsModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imagUrl)]];
    _nameLabel.text = model.productName;
    NSDictionary *dic = [model.productRemark jk_dictionaryValue];
    NSString *sku = @"";
    for (NSString *key in dic.allKeys) {
        sku = [sku stringByAppendingFormat:@"%@",dic[key]];
    }
    _skuLabel.text = [NSString stringWithFormat:@"   %@   ",sku];
    _countLabel.text = [NSString stringWithFormat:@"X%@",model.offerCnt];
    _priceLabel.text = [NSString stringWithFormat:@"%@",[model.unitPrice currency]];
}
- (IBAction)blockAction:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}
@end
