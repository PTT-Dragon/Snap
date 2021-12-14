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
        [_shareBtn setTitle:@"VIEW MORE GROUP BUY OFFER" forState:0];
        _stateLabel.text = @"Grouped";
    }else if ([model.state isEqualToString:@"B"]){
        [_shareBtn setTitle:@"INVITE FRIENDS" forState:0];
        _stateLabel.text = @"1 more buyer required Expire in";
    }
}


- (IBAction)shareAction:(UIButton *)sender {
}
@end