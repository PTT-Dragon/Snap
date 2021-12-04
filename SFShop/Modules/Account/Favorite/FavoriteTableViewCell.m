//
//  FavoriteTableViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "FavoriteTableViewCell.h"
#import "SimilarViewController.h"

@interface FavoriteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIButton *similarBtn;
@property (weak, nonatomic) favoriteModel *model;
@end

@implementation FavoriteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _similarBtn.layer.borderWidth = 1;
    _similarBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
}
- (void)setContent:(favoriteModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.productName;
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",model.salesPrice];
    _downLabel.text = [NSString stringWithFormat:@"↓ RP %@",model.markdownPrice];
    _discountLabel.text = [NSString stringWithFormat:@" RP %@OFF ",model.markdownPrice];
}
- (IBAction)spCartAction:(id)sender {
    [SFNetworkManager post:SFNet.cart.cart parameters:@{@"isSelected":@"N",@"contactChannel":@"3",@"addon":@"",@"productId":_model.productId,@"storeId":_model.storeId,@"offerId":_model.offerId,@"num":@(1),@"unitPrice":_model.salesPrice} success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"ADD SUCCESS"];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD autoDismissShowHudMsg: error.localizedDescription];
    }];
}
- (IBAction)similarAction:(id)sender {
    SimilarViewController *vc = [[SimilarViewController alloc] init];
    vc.offerId = _model.offerId;
    vc.model = _model;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
