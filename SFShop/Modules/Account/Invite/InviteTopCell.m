//
//  InviteTopCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "InviteTopCell.h"
#import "PublicShareView.h"
#import "PublicAlertView.h"

@interface InviteTopCell ()
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation InviteTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_inviteBtn setTitle:kLocalizedString(@"INVITE_NOW") forState:0];
    _label1.text = [NSString stringWithFormat:@"%@%@%@",kLocalizedString(@"SUCC_INVITE_NUM"),@"0",kLocalizedString(@"teman")];
    [_ruleBtn setTitle:kLocalizedString(@"RULE_DESCRIPTION") forState:0];
    _label2.text = kLocalizedString(@"INVITATION_RECORD");
}
- (IBAction)inviteAction:(id)sender {
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    NSString *shareUrl = [NSString stringWithFormat:@"%@/sign-up-gift/%@",Host,model.userRes.userCode];
    [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
}
- (IBAction)ruleAction:(UIButton *)sender {
    [SFNetworkManager get:SFNet.invite.activityInvRule parameters:@{} success:^(id  _Nullable response) {
        NSArray *arr = response;
        NSDictionary *dic = arr.firstObject;
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
        NSData *data = [dic[@"ctnDesc"] dataUsingEncoding:NSUTF8StringEncoding];
        NSAttributedString *str = [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
        PublicAlertView *alert = [[PublicAlertView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height) title:kLocalizedString(@"RULE") content:[str string] btnTitle:kLocalizedString(@"CLOSE") block:^{
            
        }];
        [[baseTool getCurrentVC].view addSubview:alert];;
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
