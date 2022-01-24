//
//  OrderDetailGroupBuyCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "OrderDetailGroupBuyCell.h"
#import <OYCountDownManager/OYCountDownManager.h>



@interface OrderDetailGroupBuyCell ()

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *showImgView;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;

@end

@implementation OrderDetailGroupBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _inviteBtn.layer.borderWidth = 1;
    _inviteBtn.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNotification) name:OYCountDownNotification object:nil];
}
- (void)countDownNotification {
    /// 计算倒计时
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:_model.now];
    NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
    NSDate *expDate = [formatter dateFromString:_model.expDate];
    NSTimeInterval expTimeInterval = [expDate timeIntervalSince1970];
    NSInteger timeout = expTimeInterval - timeInterval-kCountDownManager.timeInterval; // 倒计时时间
    if (timeout <= 0) {
          // 倒计时结束时回调
          
    }else{
        /// 重新赋值
        self.stateLabel.text = [NSString stringWithFormat:@"%@%@ %@:%@:%@",[NSString stringWithFormat:@"%ld",_model.shareByNum-_model.memberQty],kLocalizedString(@"expire_one_tip"),[NSString stringWithFormat:@"%02ld",timeout/3600],[NSString stringWithFormat:@"%02ld",(timeout/60)%60],[NSString stringWithFormat:@"%02ld",timeout%60]];
    }
}
- (void)setModel:(OrderGroupModel *)model
{
    _model = model;
    if ([model.state isEqualToString:@"C"]) {
        [_shareBtn setTitle:kLocalizedString(@"view_more_group") forState:0];
        _stateLabel.text = kLocalizedString(@"Grouped");
        _inviteBtn.hidden = YES;
    }else if ([model.state isEqualToString:@"B"]){
        [_shareBtn setTitle:kLocalizedString(@"Invite_friends") forState:0];
        _stateLabel.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%ld",model.shareByNum-model.memberQty],kLocalizedString(@"expire_one_tip")];
    }
    CGFloat width = 48;
    NSInteger i = 0;
    CGFloat right = _model.groupMembers.count>3 ? 24: 50;
    for (ReviewUserInfoModel *memberModel in _model.groupMembers) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.showImgView.width-48-i*right, 0, width, width)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(memberModel.photo)]];
        imgView.clipsToBounds = YES;
        imgView.layer.cornerRadius = 24;
        [self.showImgView addSubview:imgView];
        i++;
    }
}


- (IBAction)shareAction:(UIButton *)sender {
}
@end
