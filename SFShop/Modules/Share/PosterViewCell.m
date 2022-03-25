//
//  PosterViewCell.m
//  SFShop
//
//  Created by 游挺 on 2022/3/25.
//

#import "PosterViewCell.h"

@interface PosterViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;

@end

@implementation PosterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(PosterContentModel *)model
{
    [_productImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.url)]];
    _qrCodeImgView.image = model.qrCodeImage;
}

@end
