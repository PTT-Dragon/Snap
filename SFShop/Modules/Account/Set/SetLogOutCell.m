//
//  SetLogOutCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "SetLogOutCell.h"

@implementation SetLogOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.text = kLocalizedString(@"logout");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
