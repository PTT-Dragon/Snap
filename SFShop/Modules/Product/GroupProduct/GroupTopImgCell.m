//
//  GroupTopImgCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/16.
//

#import "GroupTopImgCell.h"

@interface GroupTopImgCell ()
@property (weak, nonatomic) IBOutlet UIButton *tipBtn;

@end

@implementation GroupTopImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [_tipBtn setTitle:kLocalizedString(@"TIPS") forState:0];
//    _tipBtn.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
//    _tipBtn.layer.borderWidth = 1;
}
- (IBAction)tipAction:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
