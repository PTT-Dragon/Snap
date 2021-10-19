//
//  AddAddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
@property (weak, nonatomic) IBOutlet UIButton *officeBtn;
@property (weak, nonatomic) IBOutlet UIButton *schoolBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *areaField;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *detailField;
@property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Modify Address";
    _homeBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _homeBtn.layer.borderWidth = 1;
    _officeBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _officeBtn.layer.borderWidth = 1;
    _schoolBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _schoolBtn.layer.borderWidth = 1;
    _moreBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _moreBtn.layer.borderWidth = 1;
    _viewWidth.constant = MainScreen_width-32;
}


- (IBAction)saveAction:(UIButton *)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_phoneField.text forKey:@"contactNbr"];
    [params setValue:_nameField.text forKey:@"contactName"];
    [params setValue:_defaultSwitch.isOn ? @"Y":@"N"  forKey:@"isDefault"];
    [params setValue:_detailField.text forKey:@"contactAddress"];
    
    [SFNetworkManager post:SFNet.address.addressList parameters:params success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
