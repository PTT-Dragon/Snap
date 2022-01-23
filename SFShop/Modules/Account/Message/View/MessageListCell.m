//
//  MessageListCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "MessageListCell.h"

@interface MessageListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;

@end

@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _imgView.layer.borderWidth = 0.5;
}
- (void)setUnreadModel:(MessageUnreadModel *)unreadModel
{
    _unreadModel = unreadModel;
    _contentLabel.attributedText = unreadModel.messageSttrStr;
    _timeLabel.text = unreadModel.createDate;
    _unreadLabel.text = unreadModel.unreadNum == 0 ? @"": [NSString stringWithFormat:@"  %ld  ",unreadModel.unreadNum];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(unreadModel.storeLogoUrl)]];
    _nameLabel.text = unreadModel.storeName;
}
- (void)setContactModel:(MessageContactModel *)contactModel
{
    _contactModel = contactModel;
    _contentLabel.attributedText = contactModel.contentSttrStr;
    _timeLabel.text = contactModel.sendTime;
    _unreadLabel.text = contactModel.unreadNum == 0 ? @"": [NSString stringWithFormat:@"  %ld  ",contactModel.unreadNum];
    _nameLabel.text = kLocalizedString(@"Order_Logistics");
    _imgView.image = [UIImage imageNamed:@"联合 97"];
}
@end
