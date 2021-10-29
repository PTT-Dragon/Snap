//
//  InviteCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "InviteCell.h"

@interface InviteCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation InviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(InviteModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.url)]];
    _nameLabel.text = model.beInvdUserName;
    _timeLabel.text = model.regTime;
    _couponLabel.text = @"";
    _label.text = model.gift.firstObject;
}
@end
