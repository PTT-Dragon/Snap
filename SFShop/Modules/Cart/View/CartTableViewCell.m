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
#import "UIButton+SGImagePosition.h"
#import "UIButton+EnlargeTouchArea.h"
#import "UseCouponViewController.h"

@interface CartTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *offNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
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
@property (weak, nonatomic) IBOutlet UIImageView *campaignsImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceDownLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTop;
@property (weak, nonatomic) IBOutlet UIButton *offBtn;
@property (weak, nonatomic) IBOutlet UILabel *noStockLabel;

@end

@implementation CartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _additonBtn.layer.borderColor = RGBColorFrom16(0xf0f0f0).CGColor;
    _additonBtn.layer.borderWidth = 1;
    _subtractBtn.layer.borderColor = RGBColorFrom16(0xf0f0f0).CGColor;
    _subtractBtn.layer.borderWidth = 1;
    _skuLabel.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _skuLabel.layer.borderWidth = 1;
    _campaignsBtn.layer.borderWidth = 1;
    _campaignsBtn.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
    _campaignsBtn.titleLabel.numberOfLines = 1;
    _campaignsBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_additonBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [_subtractBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [_selBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    _offLabel.text = [NSString stringWithFormat:@" %@ ",kLocalizedString(@"OFF")];
    [_offBtn setTitle:kLocalizedString(@"TO_SATISFY") forState:0];
    _offBtn.titleLabel.numberOfLines = 0;
    _noStockLabel.text = kLocalizedString(@"OUT_OF_STOCK");
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skuAction)];
    [_skuLabel addGestureRecognizer:tap];
    [_selBtn setImage:[UIImage imageNamed:@"block"] forState:UIControlStateDisabled | UIControlStateSelected];
    [_selBtn setImage:[UIImage imageNamed:@"block"] forState:UIControlStateDisabled | UIControlStateNormal];
    [_selBtn setImage:[UIImage imageNamed:@"Vector"] forState:0];
    [_selBtn setImage:[UIImage imageNamed:@"已选中"] forState:1];
    self.subtractBtn.mm_acceptEventInterval = 0.5;
    self.additonBtn.mm_acceptEventInterval = 0.5;
    self.selBtn.mm_acceptEventInterval = 0.5;
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
    _priceLabel.text = [[NSString stringWithFormat:@"%.0f",model.salesPrice] currency];
    NSString *sku = @"";
    for (ProdSpcAttrsModel *prodModel in model.prodSpcAttrs) {
        sku = [sku stringByAppendingFormat:@"%@ ",prodModel.value];
    }
    _skuLabel.text = [NSString stringWithFormat:@"  %@  ",sku];
    _priceDownView.hidden = !model.cutRateStr;
    _priceDownLabel.text = model.cutRateStr;
    [self updateBtnState];
}
- (void)setShowCampaignsView:(BOOL)showCampaignsView
{
    _showCampaignsView = showCampaignsView;
    _campaignsImgView.hidden = !showCampaignsView;
    if (showCampaignsView) {
        self.offBtn.hidden = NO;
        self.offLabel.hidden = NO;
        self.offNameLabel.hidden = NO;
        self.imgTop.constant = 45;
        self.offLabel.text = [_campaignsModel.buygetnInfo.promotType rangeOfString:@"C"].location != NSNotFound ? [NSString stringWithFormat:@" %@ ",kLocalizedString(@"OFF")]: [NSString stringWithFormat:@" %@ ",kLocalizedString(@"Discount")];
    }else{
        self.offBtn.hidden = YES;
        self.offLabel.hidden = YES;
        self.offNameLabel.hidden = YES;
        self.imgTop.constant = 15;
    }
}
- (void)setShowCampaignsBtn:(BOOL)showCampaignsBtn
{
    self.campaignsBtn.hidden = !showCampaignsBtn;
}
- (void)setCampaignsModel:(CartCampaignsModel *)campaignsModel
{
    _campaignsModel = campaignsModel;
    NSString *str = campaignsModel.campaignName.length > 10 ? [NSString stringWithFormat:@"%@..",[campaignsModel.campaignName substringToIndex:10]]: campaignsModel.campaignName;
    [self.campaignsBtn setTitle:[NSString stringWithFormat:@" %@    ",str] forState:0];
//    double a =
    [_campaignsBtn SG_imagePositionStyle:SGImagePositionStyleRight spacing:-2];
//    [self.campaignsBtn setTitle:[NSString stringWithFormat:@" %@ ",campaignsModel.campaignName] forState:0];
    _offNameLabel.text = campaignsModel.campaignName;
}
- (void)setIsInvalid:(BOOL)isInvalid
{
    _isInvalid = isInvalid;
}
- (void)updateBtnState
{
    if (_isInvalid || _model.stock == 0 || [_model.noStock isEqualToString:@"Y"]) {
        _selBtn.enabled = NO;
        _noStockLabel.hidden = NO;
        _countLabel.hidden = YES;
        _additonBtn.hidden = YES;
        _subtractBtn.hidden = YES;
        _countLabel.textColor = RGBColorFrom16(0x7b7b7b);
    }else{
        _selBtn.enabled = YES;
        _selBtn.selected = [_model.isSelected isEqualToString:@"Y"];
        _countLabel.text = _model.num;
        _noStockLabel.hidden = YES;
        _countLabel.textColor = [UIColor blackColor];
        _countLabel.hidden = NO;
        _additonBtn.hidden = NO;
        _subtractBtn.hidden = NO;
    }
    self.subtractBtn.enabled = _isInvalid ? NO: ![_countLabel.text isEqualToString:@"1"];
    NSInteger maxBuyCount = !_model.maxBuyCount ? 100000:[_model.maxBuyCount integerValue];
    self.additonBtn.enabled = (_isInvalid || _model.stock == 0) ? NO: (_countLabel.text.integerValue < _model.stock && _countLabel.text.integerValue < maxBuyCount);
    [self.subtractBtn setImage: self.subtractBtn.enabled ? [UIImage imageNamed:@"subtract"]: [UIImage imageNamed:@"subtract-2"] forState:0];
    self.additonBtn.backgroundColor = self.additonBtn.enabled ? [UIColor whiteColor]: RGBColorFrom16(0xf9f9f9);
    self.subtractBtn.backgroundColor = self.subtractBtn.enabled ? [UIColor whiteColor]: RGBColorFrom16(0xf9f9f9);
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
- (IBAction)campaignsAction:(UIButton *)sender {
    [self.delegate promotionWithModel:_model CartCampaignsModel:_campaignsModel];
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

- (IBAction)offAction:(UIButton *)sender {
    UseCouponViewController *vc = [[UseCouponViewController alloc] init];
    vc.buygetnInfoModel = _campaignsModel.buygetnInfo;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}


@end
