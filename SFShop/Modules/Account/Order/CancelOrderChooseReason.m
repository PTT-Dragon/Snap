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
    _reasonLabel.text = @"Please Select";// kLocalizedString(@"PLEASE_SELECT");
    @weakify(self);
    [self.backView jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        self.btn.selected = self.btn.selected;
        self.block(self.btn.selected);
    }];
}
- (IBAction)btnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.block(sender.selected);
}
@end
