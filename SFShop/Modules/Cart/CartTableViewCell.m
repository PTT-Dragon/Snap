//
//  CartTableViewCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartTableViewCell.h"

@interface CartTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *additonBtn;
@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;

@end

@implementation CartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _additonBtn.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _additonBtn.layer.borderWidth = 1;
    _subtractBtn.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _subtractBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
