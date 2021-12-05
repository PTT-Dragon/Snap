//
//  RecentlyViewedCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/25.
//

#import "RecentlyViewedCell.h"
#import "SimilarViewController.h"

@interface RecentlyViewedCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *similarBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak,nonatomic) RecentlyModel *model;
@end

@implementation RecentlyViewedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _similarBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _similarBtn.layer.borderWidth = 1;
}
- (void)setContent:(RecentlyModel *)model
{
    _model = model;
    _nameLabel.text = model.offerName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",model.salesPrice];
    _favoriteBtn.selected = model.isCollection;
}
- (IBAction)cartAction:(UIButton *)sender {
    NSDictionary *params = @{@"storeId":_model.storeId,@"offerId":_model.offerId,@"num":@(1),@"unitPrice":_model.salesPrice,@"contactChannel":@"3",@"addon":@"",@"isSelected":@"N"};
    [SFNetworkManager post:SFNet.cart.cart parameters: params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"ADD SUCCESS"];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (IBAction)similarAction:(UIButton *)sender {
    SimilarViewController *vc = [[SimilarViewController alloc] init];
    vc.offerId = _model.offerId;
    vc.model = _model;
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (IBAction)favoriteAction:(UIButton *)sender {
    [SFNetworkManager post:SFNet.favorite.favorite parametersArr:@[@{@"offerId":_model.offerId}] success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

@end
