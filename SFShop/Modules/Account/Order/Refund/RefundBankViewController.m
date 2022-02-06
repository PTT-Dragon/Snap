//
//  RefundBankViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/2/4.
//

#import "RefundBankViewController.h"

@interface RefundBankViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UITextField *field3;

@end

@implementation RefundBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"BANK_ACCOUNT");
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.btn setTitle:kLocalizedString(@"SUBMIT") forState:0];
    self.field1.placeholder = kLocalizedString(@"BANK");
    self.field1.layer.borderWidth = 1;
    self.field1.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.label1.text = kLocalizedString(@"BANK");
    self.label2.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"BANK"),kLocalizedString(@"IS_REQUIRE")];
    self.field2.layer.borderWidth = 1;
    self.field2.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.field2.placeholder = kLocalizedString(@"ACCOUNT_NAME");
    self.label3.text = kLocalizedString(@"ACCOUNT_NAME");
    self.label4.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"ACCOUNT_NAME"),kLocalizedString(@"IS_REQUIRE")];
    self.field3.placeholder = kLocalizedString(@"BANK_ACCOUNT");
    self.field3.layer.borderWidth = 1;
    self.field3.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    self.label5.text = kLocalizedString(@"BANK_ACCOUNT");
    self.label6.text = [NSString stringWithFormat:@"%@ %@",kLocalizedString(@"BANK_ACCOUNT"),kLocalizedString(@"IS_REQUIRE")];
    [self.field1 addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.field1.delegate = self;
    [self.field2 addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.field2.delegate = self;
    [self.field3 addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.field3.delegate = self;
}
- (void)changedTextField:(UITextField *)textField
{
    if (textField == _field1) {
        if ([textField.text isEqualToString:@""]) {
            _label1.hidden = YES;
            _label2.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
        }else{
            _label1.hidden = NO;
            _label2.hidden = YES;
            textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
        }
    }else if (textField == _field2){
        if ([textField.text isEqualToString:@""]) {
            _label3.hidden = YES;
            _label4.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
        }else{
            _label3.hidden = NO;
            _label4.hidden = YES;
            textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
        }
    }else{
        if ([textField.text isEqualToString:@""]) {
            _label5.hidden = YES;
            _label6.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
            
        }else{
            _label5.hidden = NO;
            _label6.hidden = YES;
            textField.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
        }
    }
    if (![_field2.text isEqualToString:@""] && ![_field1.text isEqualToString:@""] && ![_field3.text isEqualToString:@""]) {
        self.btn.userInteractionEnabled = YES;
        self.btn.backgroundColor = RGBColorFrom16(0xff1659);
    }else{
        self.btn.userInteractionEnabled = NO;
        self.btn.backgroundColor = RGBColorFrom16(0xff1659);
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _field1) {
        if ([textField.text isEqualToString:@""]) {
            _label1.hidden = YES;
            _label2.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
        }
    }else if (textField == _field2){
        if ([textField.text isEqualToString:@""]) {
            _label3.hidden = YES;
            _label4.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
        }
    }else{
        if ([textField.text isEqualToString:@""]) {
            _label5.hidden = YES;
            _label6.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
            
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _field1) {
        if ([textField.text isEqualToString:@""]) {
            _label1.hidden = YES;
            _label2.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
        }
    }else if (textField == _field2){
        if ([textField.text isEqualToString:@""]) {
            _label3.hidden = YES;
            _label4.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
        }
    }else{
        if ([textField.text isEqualToString:@""]) {
            _label5.hidden = YES;
            _label6.hidden = NO;
            textField.layer.borderColor = [UIColor redColor].CGColor;
        }
    }
}
- (IBAction)btnAction:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_field2.text forKey:@"bankAcctName"];
    [params setValue:_field3.text forKey:@"bankAcctNbr"];
    [params setValue:_field1.text forKey:@"bankName"];
    [params setValue:_orderApplyId forKey:@"orderApplyId"];
    [params setValue:_refundOrderId forKey:@"refundOrderId"];
    
    [SFNetworkManager post:SFNet.refund.acct parameters:params success:^(id  _Nullable response) {
        if (self.block) {
            self.block();
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
