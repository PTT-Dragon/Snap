//
//  CartTableViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartTableViewCell.h"

@interface CartTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *additonBtn;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation CartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _additonBtn.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _additonBtn.layer.borderWidth = 1;
    _subtractBtn.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _subtractBtn.layer.borderWidth = 1;
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
}

- (void)setModel:(CartItemModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.productName;
    _countLabel.text = model.num;
    _priceLabel.text = [NSString stringWithFormat:@" RP%.0f",model.salesPrice];
    ProdSpcAttrsModel *skuLabel = model.prodSpcAttrs.firstObject;
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",skuLabel.value];
    _selBtn.selected = [model.isSelected isEqualToString:@"Y"];
}
- (IBAction)selAction:(UIButton *)sender {
    _model.isSelected = sender.selected ? @"N": @"Y";
    [self setModel:_model];
    [self cartModifyAction];
}
- (IBAction)addAction:(UIButton *)sender {
    NSInteger i = _model.num.integerValue;
    i++;
    _model.num = [NSString stringWithFormat:@"%ld",i];
    [self setModel:_model];
    [self cartModifyAction];
}
- (IBAction)subtractAction:(UIButton *)sender {
    NSInteger i = _model.num.integerValue;
    if (i<2) {
        return;
    }
    i--;
    _model.num = [NSString stringWithFormat:@"%ld",i];
    [self setModel:_model];
    [self cartModifyAction];
}
- (void)cartModifyAction
{
    NSDictionary *dic = [_model toDictionary];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.cart.modify parameters:@{@"carts":@[dic]} success:^(id  _Nullable response) {
        [weakself.delegate refreshData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end