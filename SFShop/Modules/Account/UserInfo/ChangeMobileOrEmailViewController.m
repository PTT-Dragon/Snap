//
//  ChangeMobileOrEmailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "ChangeMobileOrEmailViewController.h"
#import "verifyCodeVC.h"


@interface ChangeMobileOrEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *field2;

@end

@implementation ChangeMobileOrEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self layoutSubviews];
    
}
- (void)layoutSubviews
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (_type == 1) {
        self.title = kLocalizedString(@"CHANGE_MOBILE");
        _label.text = kLocalizedString(@"PASSWORD");
        _field.placeholder = kLocalizedString(@"CHANGE_MOBILE");
        _label2.hidden = YES;
        _field2.hidden = YES;
        if (model.userRes.mobilePhone && ![model.userRes.mobilePhone isEqualToString:@""]) {
            _field.placeholder = model.userRes.mobilePhone;
        }
    }else{
        self.title = kLocalizedString(@"CHANGE_EMAIL");
        _label.text = kLocalizedString(@"EMAIL");
        _field.placeholder = kLocalizedString(@"CHANGE_EMAIL");
        _label2.hidden = YES;
        _field2.hidden = YES;
        if (model.userRes.email && ![model.userRes.email isEqualToString:@""]) {
            _field.placeholder = model.userRes.email;
        }
    }
}
- (IBAction)submitAction:(UIButton *)sender {
    verifyCodeVC *vc = [[verifyCodeVC alloc] init];
    vc.type = _type == 1 ? ChangeMobileNumber_Code: ChangeEmail_Code;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
