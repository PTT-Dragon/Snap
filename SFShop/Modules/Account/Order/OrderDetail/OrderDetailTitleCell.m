//
//  OrderDetailTitleCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/26.
//

#import "OrderDetailTitleCell.h"

@implementation OrderDetailTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.text = kLocalizedString(@"ORDER_INFORMATION");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
