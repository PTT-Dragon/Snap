//
//  RecentlyViewedCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/25.
//

#import "RecentlyViewedCell.h"
#import "SimilarViewController.h"
#import "NSString+Fee.h"
#import "UIButton+EnlargeTouchArea.h"

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
    [_cartBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    [_favoriteBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
}
- (void)setContent:(RecentlyModel *)model
{
    _model = model;
    _nameLabel.text = model.offerName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _priceLabel.text = [model.specialPrice currency];
    _favoriteBtn.selected = model.isCollection;
}
- (IBAction)cartAction:(UIButton *)sender {
    NSDictionary *params = @{@"storeId":_model.storeId,@"offerId":_model.offerId,@"num":@(1),@"unitPrice":_model.salesPrice,@"contactChannel":@"3",@"addon":@"",@"isSelected":@"N"};
    [SFNetworkManager post:SFNet.cart.cart parameters: params success:^(id  _Nullable response) {
//        [MBProgressHUD autoDismissShowHudMsg:@"ADD SUCCESS"];
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"ADD_TO_CART_SUCCESS")];
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
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.favorite.favorite parametersArr:@[@{@"offerId":_model.offerId}] success:^(id  _Nullable response) {
        weakself.model.isCollection = !weakself.model.isCollection;
        if (weakself.model.isCollection) {
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Favorite_success")];
        }else {
            [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Favorite_cancel")];
        }
        [weakself setContent:weakself.model];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

@end
