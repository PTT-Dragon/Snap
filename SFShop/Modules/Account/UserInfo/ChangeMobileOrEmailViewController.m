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
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet UILabel *redLabel1;
@property (weak, nonatomic) IBOutlet UILabel *redLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *field2Top;


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
        if ([textField.text isEqualToString:@""]) {
            _field.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
            _label.hidden = YES;
            _redLabel1.hidden = NO;
            _passwordSuccess1 = NO;
        }else{
            _label.hidden = NO;
            _redLabel1.hidden = YES;
            _field.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
            _passwordSuccess1 = YES;//[textField systemPhoneCheck:CHECKPASSWORDTYPE editType:EIDTTYPE];
        }
        if (_passwordSuccess1) {
            _label.hidden = NO;
            _label.textColor = RGBColorFrom16(0x7b7b7b);
        }else{
            
        }
    }else if(textField == _field2){
        _passwordSuccess2 = [textField systemPhoneCheck:CHECKPHONETYPE editType:EIDTTYPE];
        if (_passwordSuccess2) {
            _label2.hidden = NO;
            _label2.textColor = RGBColorFrom16(0x7b7b7b);
            _redLabel2.hidden = YES;
        }else{
            _label2.hidden = NO;
            _redLabel2.hidden = NO;
        }
        if ([textField.text isEqualToString:@""]) {
            _passwordSuccess2 = NO;
            _field2.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
            _redLabel2.text = kLocalizedString(@"REQUIREDTIP");
            _redLabel2.textColor = RGBColorFrom16(0xff1659);
            _label2.textColor = RGBColorFrom16(0xff1659);
            _label2.hidden = YES;
        }else{
            _redLabel2.text = kLocalizedString(@"INCORRECT_PHONE");
        }
    }
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (!model.userRes.mobilePhone || [model.userRes.mobilePhone isEqualToString:@""]) {
        if (_passwordSuccess2) {
            self.btn.backgroundColor = RGBColorFrom16(0xFF1659);
            self.btn.userInteractionEnabled = YES;
        }else{
            self.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
            self.btn.userInteractionEnabled = NO;
        }
    }else{
        if (_passwordSuccess1 && _passwordSuccess2) {
            self.btn.backgroundColor = RGBColorFrom16(0xFF1659);
            self.btn.userInteractionEnabled = YES;
        }else{
            self.btn.backgroundColor = RGBColorFrom16(0xFFE5EB);
            self.btn.userInteractionEnabled = NO;
        }
    }
    
}
- (void)layoutSubviews
{
    self.field.layer.borderWidth = 1;
    self.field2.layer.borderWidth = 1;
    self.field.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];//设置显示模式为永远显示(默认不显示)
    self.field.leftViewMode = UITextFieldViewModeAlways;
    self.field2.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];//设置显示模式为永远显示(默认不显示)
    self.field2.leftViewMode = UITextFieldViewModeAlways;
    _redLabel1.text = kLocalizedString(@"REQUIREDTIP");
    _redLabel2.text = kLocalizedString(@"REQUIREDTIP");
    _label2.text = kLocalizedString(@"NEW_MOBILE_NUMBER");
    _label.text = kLocalizedString(@"PASSWORD");
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    [_field addTarget:self action:@selector(changedTextField:) forControlEvents:(UIControlEventEditingChanged)];
    [_field2 addTarget:self action:@selector(changedTextField:) forControlEvents:(UIControlEventEditingChanged)];
    self.field.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];
    self.field.leftViewMode = UITextFieldViewModeAlways;
    self.field2.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,0)];
    self.field2.leftViewMode = UITextFieldViewModeAlways;
    if (_type == 1) {
        self.title = kLocalizedString(@"MOBILE_NUMBER");
        _label.text = kLocalizedString(@"PASSWORD");
        _field.placeholder = kLocalizedString(@"PASSWORD");
        _field2.placeholder = kLocalizedString(@"NEW_MOBILE_NUMBER");
        self.subTitle.text = kLocalizedString(@"CHANGE_MOBILE");
        [self.btn setTitle:kLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
        _label2.hidden = YES;
        _field2.hidden = NO;
        if (!model.userRes.mobilePhone || [model.userRes.mobilePhone isEqualToString:@""]) {
            //未有绑定的手机号
            [self.btn setTitle:kLocalizedString(@"BIND") forState:0];
            self.label.hidden = YES;
            self.redLabel1.hidden = YES;
            self.field.hidden = YES;
            _field2Top.constant = 88;
        }
//        self.label.hidden = YES;
//        self.label2.hidden = YES;
//        self.redLabel1.hidden = YES;
//        self.redLabel2.hidden = YES;
        
//        @weakify(self);
//        [[self.field rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//            @strongify(self);
//            if (x.length == 0) {
//                self.label.hidden = YES;
//                self.redLabel1.hidden = NO;
//                self.field.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
//            }else {
//                self.label.hidden = NO;
//                self.redLabel1.hidden = YES;
//                self.redLabel1.alpha = 1;
//                self.field.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
//            }
//        }];
        
//        [[self.field2 rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//            @strongify(self);
//            if (x.length == 0) {
//                self.label2.hidden = YES;
//                self.redLabel2.hidden = NO;
//            }else {
//                self.label2.hidden = NO;
//                self.redLabel2.hidden = YES;
//                self.redLabel2.alpha = 1;
//            }
//        }];
        
        
    }else{
        self.title = kLocalizedString(@"CHANGE_EMAIL");
        _label.text = kLocalizedString(@"EMAIL");
        _field.placeholder = kLocalizedString(@"CHANGE_EMAIL");
        _label2.hidden = YES;
        _field2.hidden = YES;
        _passwordSuccess2 = YES;
        self.subTitle.hidden = YES;
        self.topMargin.constant = 10;
        if (model.userRes.email && ![model.userRes.email isEqualToString:@""]) {
            _field.placeholder = model.userRes.email;
            [self.btn setTitle:kLocalizedString(@"CHANGE") forState:UIControlStateNormal];
            _field.userInteractionEnabled = NO;
            _btn.userInteractionEnabled = YES;
            self.btn.backgroundColor = RGBColorFrom16(0xFF1659);
        }else{
            [self.btn setTitle:kLocalizedString(@"SUBMIT") forState:UIControlStateNormal];
        }
        
    }
}
    
- (IBAction)submitAction:(UIButton *)sender {
    verifyCodeVC *vc = [[verifyCodeVC alloc] init];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    if (_type == 1) {
        if (!model.userRes.mobilePhone || [model.userRes.mobilePhone isEqualToString:@""]) {
            
        }else{
            vc.password = _field.text;
        }
        vc.type = ChangeMobileNumber_Code;
        vc.account = _field2.text;
    }else{
        if (model.userRes.email && ![model.userRes.email isEqualToString:@""]) {
            vc.account = model.userRes.email;
        }else{
            vc.account = _field.text;
        }
        vc.type = ChangeEmail_Code;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
