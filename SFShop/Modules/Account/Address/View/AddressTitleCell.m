//
//  AddressTitleCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/21.
//

#import "AddressTitleCell.h"

@interface AddressTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation AddressTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.text = kLocalizedString(@"DELIVERY_ADDRESS");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
