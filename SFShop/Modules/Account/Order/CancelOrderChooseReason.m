//
//  CancelOrderChooseReason.m
//  SFShop
//
//  Created by 游挺 on 2021/10/31.
//

#import "CancelOrderChooseReason.h"


@implementation CancelOrderChooseReason

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.text = kLocalizedString(@"ORDER_CANCEL_REASON");
    _reasonLabel.text = kLocalizedString(@"PLEASE_SELECT");
}
- (IBAction)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.block(sender.selected);
}
@end
