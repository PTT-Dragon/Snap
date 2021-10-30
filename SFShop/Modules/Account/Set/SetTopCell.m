//
//  SetTopCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "SetTopCell.h"

@interface SetTopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SetTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    self.nameLabel.text = model.userRes.nickName;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.userRes.photo)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
