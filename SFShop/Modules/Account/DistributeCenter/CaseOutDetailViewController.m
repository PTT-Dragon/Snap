//
//  CaseOutDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import "CaseOutDetailViewController.h"
#import "verifyCodeVC.h"

@interface CaseOutDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bankField;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *accountNameField;
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;

@end

@implementation CaseOutDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Cash_out");
    [self.bankField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.accountField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.accountNameField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.amountField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
}
- (void)changedTextField:(UITextField *)textField
{
    if (![_accountField.text isEqualToString:@""] && ![_bankField.text isEqualToString:@""] && ![_accountNameField.text isEqualToString:@""] && ![_amountField.text isEqualToString:@""]) {
        _chargeBtn.backgroundColor = RGBColorFrom16(0xFF1659);
    }else{
        _chargeBtn.backgroundColor = RGBColorFrom16(0xFFE5EB);
    }
}
- (IBAction)chargeAction:(UIButton *)sender {    
    verifyCodeVC *vc = [[verifyCodeVC alloc] init];
    vc.type = CashOut_Code;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
