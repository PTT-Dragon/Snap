//
//  FlashSaleProductCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "FlashSaleProductCell.h"

@interface FlashSaleProductCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *OriginalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processWidth;
@property (weak, nonatomic) IBOutlet UILabel *processLabel;

@end

@implementation FlashSaleProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
