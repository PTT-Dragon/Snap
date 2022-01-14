//
//  ChangeMobileOrEmailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "ChangeMobileOrEmailViewController.h"
#import "verifyCodeVC.h"
#import "UITextField+expand.h"


@interface ChangeMobileOrEmailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ChangeMobileOrEmailViewController

static BOOL _passwordSuccess1 = NO;
static BOOL _passwordSuccess2 = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self layoutSubviews];
    
}
- (void)changedTextField:(UITextField *)textField
{
    if (textField == _field) {
        _passwordSuccess1 = [textField textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[]];
    }else if(textField == _field2){
        _passwordSuccess2 = [textField textFieldState:CHECKPASSWORDTYPE editType:EIDTTYPE labels:@[]];
    }
    if (_passwordSuccess1 && _passwordSuccess2) {
        self.btn.backgroundColor = RGBColorFrom16(0xFF1659);
        self.btn.userInteractionEnabled = YES;
    }else{
        self.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
        self.btn.userInteractionEnabled = NO;
    }
}
- (void)layoutSubviews
{
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (_type == 1) {
        self.title = kLocalizedString(@"CHANGE_MOBILE");
        _label.text = kLocalizedString(@"PASSWORD");
        _field.placeholder = kLocalizedString(@"PASSWORD");
        _label2.hidden = NO;
        _field2.hidden = NO;
        
    }else{
        self.title = kLocalizedString(@"CHANGE_EMAIL");
        _label.text = kLocalizedString(@"EMAIL");
        _field.placeholder = kLocalizedString(@"CHANGE_EMAIL");
        _label2.hidden = YES;
        _field2.hidden = YES;
        _passwordSuccess2 = YES;
        if (model.userRes.email && ![model.userRes.email isEqualToString:@""]) {
            _field.placeholder = model.userRes.email;
        }
    }
}
    
- (IBAction)submitAction:(UIButton *)sender {
    verifyCodeVC *vc = [[verifyCodeVC alloc] init];
    if (_type == 1) {
        vc.type = ChangeMobileNumber_Code;
        vc.account = _field2.text;
        vc.password = _field.text;
    }else{
        vc.type = ChangeEmail_Code;
        vc.account = _field.text;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
