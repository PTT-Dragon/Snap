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
}
- (void)setUnreadModel:(MessageUnreadModel *)unreadModel
{
    _unreadModel = unreadModel;
    _contentLabel.text = unreadModel.message;
    _timeLabel.text = unreadModel.createDate;
    _unreadLabel.text = unreadModel.unreadNum == 0 ? @"": [NSString stringWithFormat:@" %ld ",unreadModel.unreadNum];
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(unreadModel.storeLogoUrl)]];
    _nameLabel.text = unreadModel.storeName;
}
- (void)setContactModel:(MessageContactModel *)contactModel
{
    _contactModel = contactModel;
    _contentLabel.text = contactModel.content;
    _timeLabel.text = contactModel.sendTime;
    _unreadLabel.text = contactModel.unreadNum == 0 ? @"": [NSString stringWithFormat:@" %ld ",contactModel.unreadNum];
    _nameLabel.text = @"Order & Logistics";
}
@end
