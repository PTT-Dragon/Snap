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
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation SetTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self updateDatas];
}
- (void)updateDatas
{
    FMDBManager *dbManager = [FMDBManager sharedInstance];
    @weakify(self)
    [RACObserve(dbManager, currentUser) subscribeNext:^(UserModel *  _Nullable model) {
        @strongify(self)
        self.nameLabel.text = model.userRes.nickName;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.userRes.photo)]];
        self.phoneLabel.text = model.userRes.mobilePhone;
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
