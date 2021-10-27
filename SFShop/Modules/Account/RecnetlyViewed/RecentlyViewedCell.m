//
//  RecentlyViewedCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/25.
//

#import "RecentlyViewedCell.h"

@interface RecentlyViewedCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *similarBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;

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
    _nameLabel.text = model.offerName;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",Host,model.imgUrl]]];
    _priceLabel.text = [NSString stringWithFormat:@"RP %@",model.salesPrice];
    
}
- (IBAction)cartAction:(UIButton *)sender {
}
- (IBAction)similarAction:(UIButton *)sender {
}

- (IBAction)favoriteAction:(UIButton *)sender {
}

@end
