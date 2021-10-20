//
//  FavoriteTableViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "FavoriteTableViewCell.h"

@interface FavoriteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UIButton *similarBtn;

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
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Host,model.imgUrl]]];
    _nameLabel.text = model.productName;
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",model.salesPrice];
    _downLabel.text = [NSString stringWithFormat:@"↓ RP %@",model.markdownPrice];
    _discountLabel.text = [NSString stringWithFormat:@" RP %@OFF ",model.markdownPrice];
}
- (IBAction)spCartAction:(id)sender {
}
- (IBAction)similarAction:(id)sender {
}
@end
