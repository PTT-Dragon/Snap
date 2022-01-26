//
//  AddAddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import "AddAddressViewController.h"
#import "ChooseAreaViewController.h"
#import "UITextField+expand.h"

@interface AddAddressViewController ()<UITextFieldDelegate,ChooseAreaViewControllerDelegate>
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
@property (nonatomic,strong) AreaModel *selProvinceAreaMoel;
@property (nonatomic,strong) AreaModel *selCityAreaMoel;
@property (nonatomic,strong) AreaModel *selDistrictAreaMoel;
@property (nonatomic,strong) AreaModel *selStreetAreaMoel;
@property (weak, nonatomic) IBOutlet UIButton *selAgreementBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel6;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;

@end

@implementation AddAddressViewController
static BOOL changePhone = NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.model ? kLocalizedString(@"Modify_Address"): kLocalizedString(@"ADD_ADDRESS");
    _homeBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _homeBtn.layer.borderWidth = 1;
    _officeBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _officeBtn.layer.borderWidth = 1;
    _schoolBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _schoolBtn.layer.borderWidth = 1;
    _moreBtn.layer.borderColor = RGBColorFrom16(0x7b7b7b).CGColor;
    _moreBtn.layer.borderWidth = 1;
    _viewWidth.constant = MainScreen_width-32;
    _areaField.delegate = self;
    _streetField.delegate = self;
    _nameField.layer.borderWidth = 1;
    _areaField.layer.borderWidth = 1;
    _emailField.layer.borderWidth = 1;
    _phoneField.layer.borderWidth = 1;
    _detailField.layer.borderWidth = 1;
    _streetField.layer.borderWidth = 1;
    _titleLabel1.text = kLocalizedString(@"CONTACT_INFORMATION");
    _titleLabel2.text = kLocalizedString(@"ADDRESS_DETAIL");
    _tipLabel1.text = kLocalizedString(@"REQUIREDTIP");
    _tipLabel2.text = kLocalizedString(@"REQUIREDTIP");
    _tipLabel3.text = kLocalizedString(@"REQUIREDTIP");
    _tipLabel4.text = kLocalizedString(@"REQUIREDTIP");
    _tipLabel5.text = kLocalizedString(@"REQUIREDTIP");
    _tipLabel6.text = kLocalizedString(@"REQUIREDTIP");
    _label1.text = kLocalizedString(@"RECIPIENT_NAME");
    _nameField.placeholder = kLocalizedString(@"RECIPIENT_NAME");
    _label2.text = kLocalizedString(@"Phone_number");
    _phoneField.placeholder = kLocalizedString(@"Phone_number");
    _label3.text = kLocalizedString(@"Email");
    _emailField.placeholder = kLocalizedString(@"Email");
    _label4.text = kLocalizedString(@"PROVINCE_CITY_DISTRICT");
    _areaField.placeholder = kLocalizedString(@"PROVINCE_CITY_DISTRICT");
    _label5.text = kLocalizedString(@"STREET");
    _streetField.placeholder = kLocalizedString(@"STREET");
    _label6.text = kLocalizedString(@"OTHERDETAIL");
    _detailField.placeholder = kLocalizedString(@"OTHERDETAIL");
    _titleLabel3.text = kLocalizedString(@"ADDRESS_DEFAULT");
    _readLabel.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"HAVE_READ_AND_AGREED"),kLocalizedString(@"SF_AGREEMENT")];
    
    if (_model) {
        //修改地址
        changePhone = YES;
        self.nameField.text = _model.contactName;
        self.phoneField.text = _model.contactNbr;
        self.areaField.text = [NSString stringWithFormat:@"%@,%@,%@",_model.district,_model.city,_model.province];
        self.streetField.text = [NSString stringWithFormat:@"%@,%@",_model.street,_model.postCode];
        self.detailField.text = _model.contactAddress;
        self.defaultSwitch.on = [_model.isDefault isEqualToString:@"Y"];
        self.selAgreementBtn.selected = YES;
        self.emailField.text = _model.email;
        self.saveBtn.userInteractionEnabled = YES;
        self.saveBtn.backgroundColor = RGBColorFrom16(0xFF1659);
    }else{
        
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _areaField) {
        ChooseAreaViewController *vc = [[ChooseAreaViewController alloc] init];
        vc.selProvinceAreaMoel = _selProvinceAreaMoel;
        vc.selCityAreaMoel = _selCityAreaMoel;
        vc.selDistrictAreaMoel = _selDistrictAreaMoel;
        vc.type = _selDistrictAreaMoel ? 4: 1;
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
        return NO;
    }else if (textField == _streetField){
        if (!_selDistrictAreaMoel) {
            [MBProgressHUD autoDismissShowHudMsg:@"Please select the province first"];
            return NO;
        }
        ChooseAreaViewController *vc = [[ChooseAreaViewController alloc] init];
        vc.selProvinceAreaMoel = _selProvinceAreaMoel;
        vc.selCityAreaMoel = _selCityAreaMoel;
        vc.selDistrictAreaMoel = _selDistrictAreaMoel;
        vc.selStreetAreaMoel = _selStreetAreaMoel;
        vc.delegate = self;
        vc.type = _selStreetAreaMoel ? 5: 2;
        [self presentViewController:vc animated:YES completion:^{
                
        }];
        return NO;
    }else if (textField == _phoneField){
        changePhone = NO;
    }
    return YES;
}

#pragma mark - delegate
- (void)chooseProvince:(AreaModel *)provinceModel city:(AreaModel *)cityModel district:(AreaModel *)districtModel
{
    _selProvinceAreaMoel = provinceModel;
    _selCityAreaMoel = cityModel;
    _selDistrictAreaMoel = districtModel;
    self.areaField.text = [NSString stringWithFormat:@"%@,%@,%@",districtModel.stdAddr,cityModel.stdAddr,provinceModel.stdAddr];
}
- (void)chooseStreet:(AreaModel *)streetModel
{
    _selStreetAreaMoel = streetModel;
    self.streetField.text = streetModel.stdAddr;
}
- (BOOL)checkAction
{
    BOOL canPublish = NO;
    BOOL b = NO;
    if (changePhone) {
        //不需要修改手机号
        b = YES;
    }else{
        b = [_phoneField textFieldState:CHECKPHONETYPE label:_label2 tipLabel:_tipLabel2];
    }
    BOOL a = [_nameField textFieldState:ANOTHERTYPE label:_label1 tipLabel:_tipLabel1];
    BOOL c = [_emailField textFieldState:CHECKEMAILTYPE label:_label3 tipLabel:_tipLabel3];
    BOOL d = [_areaField textFieldState:ANOTHERTYPE label:_label4 tipLabel:_tipLabel4];
    BOOL e = [_streetField textFieldState:ANOTHERTYPE label:_label5 tipLabel:_tipLabel5];
    BOOL f = [_detailField textFieldState:ANOTHERTYPE label:_label6 tipLabel:_tipLabel6];
    canPublish = a && b && c && d && e && f;
    return canPublish;
}
- (IBAction)selAgreementAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.saveBtn.userInteractionEnabled = sender.selected;
    self.saveBtn.backgroundColor = sender.selected ? RGBColorFrom16(0xFF1659): RGBColorFrom16(0xFFE5EB);
}

- (IBAction)saveAction:(UIButton *)sender {
    if (!_selAgreementBtn.selected) {
        [MBProgressHUD autoDismissShowHudMsg:@"Sel Agreement First"];
        return;
    }
    if (![self checkAction]) {
        return;
    }
    [self checkAction];
    if (_model) {
        //修改地址
        [self modifyAction];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_phoneField.text forKey:@"contactNbr"];
    [params setValue:_nameField.text forKey:@"contactName"];
    [params setValue:_defaultSwitch.isOn ? @"Y":@"N"  forKey:@"isDefault"];
    [params setValue:_detailField.text forKey:@"contactAddress"];
    [params setValue:_selStreetAreaMoel.stdAddrId forKey:@"contactStdId"];
    [params setValue:_selStreetAreaMoel.zipcode forKey:@"postCode"];
    [params setValue:_emailField.text forKey:@"email"];
    MPWeakSelf(self)
    [SFNetworkManager post:SFNet.address.addressList parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:@"ADD SUCCESS"];
        [weakself.delegate addNewAddressSuccess];
        [weakself.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)modifyAction
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!changePhone) {
        [params setValue:_phoneField.text forKey:@"contactNbr"];
    }
    [params setValue:_nameField.text forKey:@"contactName"];
    [params setValue:_defaultSwitch.isOn ? @"Y":@"N"  forKey:@"isDefault"];
    [params setValue:_detailField.text forKey:@"contactAddress"];
    [params setValue:_selStreetAreaMoel ? _selStreetAreaMoel.stdAddrId : _model.contactStdId forKey:@"contactStdId"];
    [params setValue:_selStreetAreaMoel ? _selStreetAreaMoel.zipcode : _model.postCode forKey:@"postCode"];
    [params setValue:_model.deliveryAddressId forKey:@"deliveryAddressId"];
    [params setValue:_emailField.text forKey:@"email"];
    MPWeakSelf(self)
    [SFNetworkManager post:[SFNet.address setAddressModifyOfdeliveryAddressId:_model.deliveryAddressId] parameters:params success:^(id  _Nullable response) {
        [MBProgressHUD autoDismissShowHudMsg:kLocalizedString(@"Modify_success")];
        [weakself.delegate addNewAddressSuccess];
        [weakself.navigationController popViewControllerAnimated:YES];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
