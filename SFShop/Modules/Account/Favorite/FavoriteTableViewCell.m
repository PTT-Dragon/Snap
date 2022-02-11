//
//  FavoriteTableViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "FavoriteTableViewCell.h"
#import "SimilarViewController.h"
#import "NSString+Fee.h"

@interface FavoriteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIButton *similarBtn;
@property (weak, nonatomic) IBOutlet UIButton *toCartBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading1;
@property (weak, nonatomic) favoriteModel *model;
@end

@implementation FavoriteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _similarBtn.layer.borderWidth = 1;
    _similarBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    if ([UserDefaultObjectForKey(@"Language") isEqualToString:kLanguageHindi]) {
        _leading1.priority = 750;
        _leading2.priority = 250;
    }else{
        _leading1.priority = 250;
        _leading2.priority = 750;
    }
    [_similarBtn setTitle:[NSString stringWithFormat:@" %@ ",kLocalizedString(@"FIND_SIMILAR")] forState:0];
    [_toCartBtn setTitle:[NSString stringWithFormat:@" %@ ",kLocalizedString(@"ADD_TO_CART")] forState:0];
    
}
- (void)setContent:(favoriteModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.productName;
    _priceLabel.text = [NSString stringWithFormat:@"%@",model.specialPrice ? [model.specialPrice currency] : [model.salesPrice currency]];
    _downLabel.text = model.markdownPrice.floatValue == 0 ? @"": [NSString stringWithFormat:@"↓ %@",[model.markdownPrice currency]];
    _discountLabel.text = [NSString stringWithFormat:@" RP %@OFF ",model.markdownPrice];
}
- (IBAction)spCartAction:(id)sender {
    [SFNetworkManager post:SFNet.cart.cart parameters:@{@"isSelected":@"N",@"contactChannel":@"3",@"addon":@"",@"productId":_model.productId,@"storeId":_model.storeId,@"offerId":_model.offerId,@"num":@(1),@"unitPrice":_model.salesPrice} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"ADD_TO_CART_SUCCESS")];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD showTopErrotMessage: [NSMutableString getErrorMessage:error][@"message"]];
    }];
}
- (IBAction)similarAction:(id)sender {
    SimilarViewController *vc = [[SimilarViewController alloc] init];
    vc.offerId = _model.offerId;
    vc.model = _model;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
