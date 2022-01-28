//
//  CartTableViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartTableViewCell.h"
#import "CartChoosePromotion.h"
#import "NSString+Fee.h"
#import "UIButton+time.h"
#import "ProductViewController.h"

@interface CartTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *additonBtn;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *priceDownView;
@property (weak, nonatomic) IBOutlet UIButton *campaignsBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceDownLabel;

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skuAction)];
    [_skuLabel addGestureRecognizer:tap];
    [_selBtn setImage:[UIImage imageNamed:@"block"] forState:UIControlStateDisabled | UIControlStateSelected];
    [_selBtn setImage:[UIImage imageNamed:@"block"] forState:UIControlStateDisabled | UIControlStateNormal];
    [_selBtn setImage:[UIImage imageNamed:@"Vector"] forState:0];
    [_selBtn setImage:[UIImage imageNamed:@"已选中"] forState:1];
    self.subtractBtn.mm_acceptEventInterval = 1;
    self.additonBtn.mm_acceptEventInterval = 1;
    self.selBtn.mm_acceptEventInterval = 1;
    [self updateBtnState];
    UITapGestureRecognizer *productTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toProduct)];
    [self.contentView addGestureRecognizer:productTap];
}
- (void)toProduct
{
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = _model.offerId.integerValue;
    vc.productId = _model.productId.integerValue;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)setModel:(CartItemModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.productName;
    _countLabel.text = model.num;
    _priceLabel.text = [[NSString stringWithFormat:@"%.0f",model.salesPrice] currency];
    NSString *sku = @"";
    for (ProdSpcAttrsModel *prodModel in model.prodSpcAttrs) {
        sku = [sku stringByAppendingFormat:@"%@ ",prodModel.value];
    }
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",sku];
    _priceDownView.hidden = !model.cutRate;
    _priceDownLabel.text = model.cutRate;
    self.campaignsBtn.hidden = (model.campaigns && model.campaigns.count != 0);
    if (model.campaigns && model.campaigns.count != 0) {
        [self.campaignsBtn setTitle:[model.campaigns.firstObject campaignName] forState:0];
    }
    [self updateBtnState];
}
- (void)setIsInvalid:(BOOL)isInvalid
{
    _isInvalid = isInvalid;
}
- (void)updateBtnState
{
    self.subtractBtn.enabled = ![self.subtractBtn.titleLabel.text isEqualToString:@"1"];
    self.additonBtn.enabled = _countLabel.text.integerValue < _model.stock;
    if (_isInvalid) {
        _selBtn.enabled = NO;
        _additonBtn.enabled = NO;
        _subtractBtn.enabled = NO;
    }else{
        _additonBtn.enabled = YES;
        _subtractBtn.enabled = YES;
        _selBtn.enabled = YES;
        _selBtn.selected = [_model.isSelected isEqualToString:@"Y"];
    }
    [self.subtractBtn setImage: self.subtractBtn.enabled ? [UIImage imageNamed:@"subtract"]: [UIImage imageNamed:@"subtract-2"] forState:0];
    self.subtractBtn.layer.borderWidth = self.subtractBtn.enabled ? 1: 0;
    [self.additonBtn setImage:self.additonBtn.enabled ? [UIImage imageNamed:@"new-alternative"]:[UIImage imageNamed:@"new-alternative-2"] forState:0];
}
- (IBAction)selAction:(UIButton *)sender {
    _model.isSelected = sender.selected ? @"N": @"Y";
    [self cartModifyAction];
}
- (IBAction)addAction:(UIButton *)sender {
    if (_isInvalid) {
        return;
    }
    NSInteger i = _model.num.integerValue;
    i++;
    _model.num = [NSString stringWithFormat:@"%ld",i];
    [self setModel:_model];
    [self cartModifyAction];
    [self updateBtnState];
}
- (IBAction)subtractAction:(UIButton *)sender {
    if (_isInvalid) {
        return;
    }
    NSInteger i = _model.num.integerValue;
    if (i<2) {
        return;
    }
    i--;
    _model.num = [NSString stringWithFormat:@"%ld",i];
    [self setModel:_model];
    [self cartModifyAction];
    [self updateBtnState];
}
- (void)skuAction
{
    if (_isInvalid) {//$(MARKETING_VERSION)
        return;
    }
    [self.delegate skuActionWithModel:_model];
}
- (void)cartModifyAction
{
    NSDictionary *dic = [_model toDictionary];
    [self.delegate modifyCartInfoWithDic:dic];
}



@end
