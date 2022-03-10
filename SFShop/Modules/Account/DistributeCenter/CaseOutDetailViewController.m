//
//  CaseOutDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import "CaseOutDetailViewController.h"
#import "verifyCodeVC.h"
#import "SysParamsModel.h"
#import "NSString+Fee.h"

@interface CaseOutDetailViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bankField;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *accountNameField;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel3;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel4;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel5;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel6;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel7;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel8;

@end

@implementation CaseOutDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"CASH_OUT");
    [self.bankField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.accountField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.accountNameField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.amountField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    NSString *lauange = UserDefaultObjectForKey(@"Language");
    if ([lauange isEqualToString:@"id"]) {
        _tipsLabel.text = [NSString stringWithFormat:@"Tips: Penarikan maksimal sehari sebesar %@, dan penarikan minimum sebesar %@.",[@"" maxWithdraw],[@"" minWithdraw]];
    }else{
        _tipsLabel.text = [NSString stringWithFormat:@"Tips: The maximum daily withdrawal amount is %@, and the minimum withdrawal amount is %@.",[@"" maxWithdraw],[@"" minWithdraw]];
    }
    self.bankField.placeholder = kLocalizedString(@"BANK");
    self.accountField.placeholder = kLocalizedString(@"BANK_ACCOUNT");
    self.accountNameField.placeholder = kLocalizedString(@"ACCOUNT_NAME");
    self.amountField.placeholder = kLocalizedString(@"CASH_OUT_(RP)");
    [self.chargeBtn setTitle:kLocalizedString(@"SUBMIT") forState:0];
    self.bankField.delegate = self;
    self.accountField.delegate = self;
    self.accountNameField.delegate = self;
    self.amountField.delegate = self;
    self.bankField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.bankField.layer.borderWidth = 1;
    self.accountField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.accountField.layer.borderWidth = 1;
    self.accountNameField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.accountNameField.layer.borderWidth = 1;
    self.amountField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.amountField.layer.borderWidth = 1;
    _tipLabel1.text = kLocalizedString(@"BANK");
    _tipLabel2.text = kLocalizedString(@"BANK_ACCOUNT");
    _tipLabel3.text = kLocalizedString(@"ACCOUNT_NAME");
    _tipLabel4.text = kLocalizedString(@"CASH_OUT_(RP)");
    _tipLabel5.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"BANK"),kLocalizedString(@"IS_REQUIRE")];
    _tipLabel6.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"BANK_ACCOUNT"),kLocalizedString(@"IS_REQUIRE")];
    _tipLabel7.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"ACCOUNT_NAME"),kLocalizedString(@"IS_REQUIRE")];
    _tipLabel8.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"CASH_OUT_(RP)"),kLocalizedString(@"IS_REQUIRE")];
}
- (void)changedTextField:(UITextField *)textField
{
    if (textField == self.bankField) {
        _tipLabel1.hidden = NO;
        _tipLabel5.hidden = YES;
        textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    }
    if (textField == self.accountField) {
        _tipLabel2.hidden = NO;
        _tipLabel6.hidden = YES;
        textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    }
    if (textField == self.accountNameField) {
        _tipLabel3.hidden = NO;
        _tipLabel7.hidden = YES;
        textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    }
    if (textField == self.amountField) {
        _tipLabel4.hidden = NO;
        _tipLabel8.hidden = YES;
        textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    }
    if (![_accountField.text isEqualToString:@""] && ![_bankField.text isEqualToString:@""] && ![_accountNameField.text isEqualToString:@""] && ![_amountField.text isEqualToString:@""]) {
        _chargeBtn.backgroundColor = RGBColorFrom16(0xFF1659);
    }else{
        _chargeBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.bankField) {
        if ([textField.text isEqualToString:@""]) {
            textField.layer.borderColor = RGBColorFrom16(0xCE0000).CGColor;
            _tipLabel5.hidden = NO;
            _tipLabel1.hidden = YES;
        }else{
            textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
            _tipLabel1.hidden = NO;
        }
    }
    if (textField == self.accountField) {
        if ([textField.text isEqualToString:@""]) {
            textField.layer.borderColor = RGBColorFrom16(0xCE0000).CGColor;
            _tipLabel6.hidden = NO;
            _tipLabel2.hidden = YES;
        }else{
            textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
            _tipLabel2.hidden = NO;
        }
    }
    if (textField == self.accountNameField) {
        if ([textField.text isEqualToString:@""]) {
            textField.layer.borderColor = RGBColorFrom16(0xCE0000).CGColor;
            _tipLabel7.hidden = NO;
            _tipLabel3.hidden = YES;
        }else{
            textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
            _tipLabel3.hidden = NO;
        }
    }
    if (textField == self.amountField) {
        if ([textField.text isEqualToString:@""]) {
            textField.layer.borderColor = RGBColorFrom16(0xCE0000).CGColor;
            _tipLabel8.hidden = NO;
            _tipLabel4.hidden = YES;
        }else{
            textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
            _tipLabel4.hidden = NO;
        }
    }
}
- (IBAction)chargeAction:(UIButton *)sender {
    NSMutableDictionary *withdrawInfo = [NSMutableDictionary dictionary];
    
    verifyCodeVC *vc = [[verifyCodeVC alloc] init];
    vc.withdrawInfo = withdrawInfo;
    vc.type = CashOut_Code;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
