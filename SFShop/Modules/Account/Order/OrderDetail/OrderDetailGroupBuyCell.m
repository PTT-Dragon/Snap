//
//  OrderDetailGroupBuyCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "OrderDetailGroupBuyCell.h"
#import <OYCountDownManager/OYCountDownManager.h>
#import "GroupListViewController.h"



@interface OrderDetailGroupBuyCell ()

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *showImgView;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showViewWidth;

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
    if ([self.model.state isEqualToString:@"B"]) {
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
    
}
- (void)setModel:(OrderGroupModel *)model
{
    _model = model;
    CGFloat viewWidth = 0 ;
    if ([model.state isEqualToString:@"C"]) {
        [_shareBtn setTitle:kLocalizedString(@"view_more_group") forState:0];
        _stateLabel.text = kLocalizedString(@"Grouped");
        _inviteBtn.hidden = YES;
        viewWidth = _model.groupMembers.count * 53;
    }else if ([model.state isEqualToString:@"B"]){
        [_shareBtn setTitle:kLocalizedString(@"Invite_friends") forState:0];
        _stateLabel.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%ld",model.shareByNum-model.memberQty],kLocalizedString(@"expire_one_tip")];
        viewWidth = (_model.groupMembers.count+1) * 53;
        _inviteBtn.frame = CGRectMake(_model.groupMembers.count * 53, 0, 48, 48);
    }else if ([model.state isEqualToString:@"D"]){
        
    }
    _showViewWidth.constant = viewWidth;
    CGFloat width = 48;
    NSInteger i = 0;
//    CGFloat right = _model.groupMembers.count>3 ? 24: 50;
    for (ReviewUserInfoModel *memberModel in _model.groupMembers) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*53, 0, width, width)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(memberModel.photo)]];
        imgView.clipsToBounds = YES;
        [self.showImgView addSubview:imgView];
        i++;
    }
}


- (IBAction)shareAction:(UIButton *)sender {
    if ([self.model.state isEqualToString:@"C"]) {
        //已经完成团购
        GroupListViewController *vc = [[GroupListViewController alloc] init];
        [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
    }else if ([self.model.state isEqualToString:@"B"]){
        NSString *shareUrl = [NSString stringWithFormat:@"%@/group-detail/%@",Host,self.model.shareBuyOrderNbr];
        [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
    }
}
- (IBAction)inviteAction:(UIButton *)sender {
    NSString *shareUrl = [NSString stringWithFormat:@"%@/group-detail/%@",Host,self.model.shareBuyOrderNbr];
    [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
}
@end
