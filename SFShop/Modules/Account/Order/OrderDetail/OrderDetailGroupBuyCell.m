//
//  OrderDetailGroupBuyCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "OrderDetailGroupBuyCell.h"

@interface OrderDetailGroupBuyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@end

@implementation OrderDetailGroupBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(OrderGroupModel *)model
{
    _model = model;
    ReviewUserInfoModel *userModel = model.groupMembers.firstObject;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(userModel.photo)]];
    if ([model.state isEqualToString:@"C"]) {
        [_shareBtn setTitle:kLocalizedString(@"view_more_group") forState:0];
        _stateLabel.text = kLocalizedString(@"Grouped");
    }else if ([model.state isEqualToString:@"B"]){
        [_shareBtn setTitle:kLocalizedString(@"") forState:0];
        _stateLabel.text = kLocalizedString(@"expire_one_tip");
    }
}


- (IBAction)shareAction:(UIButton *)sender {
}
@end
